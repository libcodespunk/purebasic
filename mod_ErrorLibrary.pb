XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Assertion.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_SAL.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Type.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/win32/mod_Win32.pb"

EnableExplicit

DeclareModule _ErrorLibrary
  UseModule Type
  
  Structure VTable
    *addErrorString
    *addSetLastError
    *getLastError
  EndStructure
  
  Structure Class
    *vTable
    libraryId.Type::INT_32
  EndStructure
  
  Interface _IObject
    addErrorString.Type::VOID(errorId, *stringConstant)
    addSetLastError.Type::VOID(errorId, fileName.s, line.l)
  EndInterface
  
  ;/ Static
  Global vTable.VTable
EndDeclareModule

Module _ErrorLibrary
EndModule

DeclareModule ErrorLibrary
  UseModule Type
  
  Structure LastError
  	libraryId.l
  	errorId.l
  	errorLine.i
  	sourceFile.s
  	customString.s
  	date.i
  EndStructure
  
  Interface IObject
    addErrorString(errorId, *stringConstant)
    setLastError(errorId, fileName.s, line.l, customString.s="")
  EndInterface
  
  Macro OBJECT_POINTER
    Type::Pointer
  EndMacro
  
  Declare.OBJECT_POINTER new()
  Declare.s getLastError(*lastError.LastError, locale.l=0)
EndDeclareModule

Module ErrorLibrary
  UseModule _ErrorLibrary
  UseModule SAL
  UseModule Assertion
  
  Structure ErrorString
  	libraryId.l
  	errorID.l
  	locale.l
  	*string
  EndStructure
  
  Structure Library
    Map errorString.i()
  EndStructure
  
  Structure ModuleState
    Map libraryById.Library()
    Map lastErrorByThreadId.LastError()
    threadLock.Type::MUTEX
    watchdogLock.Type::SEMAPHORE
  EndStructure
  
  Global g_moduleState.ModuleState
  
  g_moduleState\threadLock=CreateMutex()
  g_moduleState\watchdogLock=CreateSemaphore()
  
  Procedure.OBJECT_POINTER new()
    Protected *instance.Class
    Protected libraryId
    
    LockMutex(g_moduleState\threadLock)
    
    libraryId=MapSize(g_moduleState\libraryById())+1
    
    g_moduleState\libraryById(Str(libraryId))
    
    UnlockMutex(g_moduleState\threadLock)
    
    *instance=AllocateStructure(Class)
    *instance\vTable=@vTable
    
    *instance\libraryId=libraryId
    
    ProcedureReturn *instance
  EndProcedure
  
  Procedure addErrorString(_IN *this.Class, errorId.l, *string, locale.l=0)
    Protected libraryId=*this\libraryId
    Protected key.s
    
    key.s=Str(libraryId)
    
    ASSERT_MAP_KEY(g_moduleState\libraryById(),key.s)
    
    g_moduleState\libraryById(key.s)\errorString(Str(errorId))=*string
  EndProcedure
  
  Procedure.l setLastError(_IN *this.Class, errorId.l, sourceFile.s, errorLine.l, customString.s="")
    Protected libraryId=*this\libraryId
    Protected threadId
    Protected *lastError.LastError
    Protected key.s
    
    threadId=GetCurrentThreadId_()
    
    key.s=Str(threadId)
    
    Debug "Adding for threadId: "+key.s
    
    ASSERT_MAP_KEY(g_moduleState\libraryById(),Str(libraryId))
    
    If Not FindMapElement(g_moduleState\lastErrorByThreadId(),key.s)
      g_moduleState\lastErrorByThreadId(key.s)
      SignalSemaphore(g_moduleState\watchdogLock)
    EndIf
    
    *lastError=g_moduleState\lastErrorByThreadId(key.s)
    
    ASSERT_MAP_KEY(g_moduleState\lastErrorByThreadId(),key.s)
    
;     If *lastError\date
;       Debug "Error already exists"
;     EndIf
    
    *lastError\libraryId=libraryId
    *lastError\errorId=errorId
    *lastError\sourceFile=sourceFile.s
    *lastError\errorLine=errorLine
    *lastError\date=Date()
    
    If Not customString.s=""
      *lastError\customString.s=customString.s
    EndIf
    
    ProcedureReturn errorId
  EndProcedure
  
  Procedure.s getLastError(*lastError.LastError, locale.l=0)
    Protected *threadError.LastError
    Protected libraryId.l
    Protected errorId
    Protected key.s
    
    If Not threadId
      threadId=GetCurrentThreadId_()
    EndIf
    
    key.s=Str(threadId)
    
    ASSERT_MAP_KEY(g_moduleState\lastErrorByThreadId(),key.s)
    
    If Not FindMapElement(g_moduleState\lastErrorByThreadId(),key.s)
      ProcedureReturn ""
    EndIf
    
    *threadError=g_moduleState\lastErrorByThreadId(key.s)
    
    libraryId=*threadError\libraryId
    
    key.s=Str(libraryId)
    
    ASSERT_MAP_KEY(g_moduleState\libraryById(),key.s)
    
    If Not *threadError\customString.s=""
      ProcedureReturn *threadError\customString.s
    EndIf
    
    ProcedureReturn PeekS(g_moduleState\libraryById(key.s)\errorString(Str(*threadError\errorId)))
  EndProcedure
  
  Procedure _threadErrorWatchdog(null)
    Protected mapSize
    Protected threadId
    Protected hThread
    Protected errorThreadCount
    Protected exitCode.Win32::DWORD
    
    Repeat
      WaitSemaphore(g_moduleState\watchdogLock)
      
      mapSize=MapSize(g_moduleState\lastErrorByThreadId())
      
      If Not mapSize=errorThreadCount
        Debug "Check new map size: "+Str(errorThreadCount)+" "+Str(mapSize)
        
        errorThreadCount=mapSize
        
        LockMutex(g_moduleState\threadLock)
        
        ForEach g_moduleState\lastErrorByThreadId()
          threadId=Val(MapKey(g_moduleState\lastErrorByThreadId()))
          hThread=Win32_KERNEL32::OpenThread(#THREAD_ALL_ACCESS,0,threadId)
          
          ASSERT(hThread<>0,"Unable to resolve thread handle: "+Str(hThread))
          
          GetExitCodeThread_(hThread,@exitCode)
          
          CloseHandle_(hThread)
          
          ;/ Delete entries for threads which no longer exist
          If Not exitCode=#STILL_ACTIVE
            DeleteMapElement(g_moduleState\lastErrorByThreadId())
            
            Debug "Deleted entry for threadId: "+Str(threadId)
            
            errorThreadCount-1
          EndIf
          
          Debug "threadId: "+Str(threadId)+" "+Str(hThread)
        Next
        
        UnlockMutex(g_moduleState\threadLock)
      EndIf
    ForEver
  EndProcedure
  
  vTable\addErrorString=@addErrorString()
  vTable\addSetLastError=@setLastError()
  
  CreateThread(@_threadErrorWatchdog(),#Null)
EndModule

DisableExplicit

; Enumeration -1 Step -1
;   #Error_1
;   #Error_2
;   #Error_3
;   #Error_4
;   #Error_5
;   #Error_6
;   #Error_7
;   #Error_8
;   #Error_9
;   #Error_10
;   #Error_11
; EndEnumeration
; 
; Define library.ErrorLibrary::IObject
; Define lastError.ErrorLibrary::LastError
; 
; library=ErrorLibrary::new()
; 
; library\addErrorString(#Error_1,@"Error 1")
; library\addErrorString(#Error_2,@"Error 2")
; library\addErrorString(#Error_3,@"Error 3")
; 
; library\setLastError(#Error_1,#PB_Compiler_File,#PB_Compiler_Line)
; Debug ErrorLibrary::getLastError(@lastError)
; 
; library\setLastError(#Error_2,#PB_Compiler_File,#PB_Compiler_Line)
; Debug ErrorLibrary::getLastError(@lastError)
; 
; library\setLastError(#Error_3,#PB_Compiler_File,#PB_Compiler_Line,"Error 4")
; Debug ErrorLibrary::getLastError(@lastError)
