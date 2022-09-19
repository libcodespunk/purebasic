#CODESPUNK_HOME="C:/home/development/sdk/codespunk/lib"

XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Assertion.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_SAL.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Type.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_PureBasic.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/win32/mod_Win32.pb"

EnableExplicit

DeclareModule Memory
  Declare.i getBaseAddress(hProcess)
  Declare.i readToBuffer(hProcess, *address, *buffer, bufferSize)
  Declare.l readAsLong(hProcess, *address)
  Declare.i readAsInteger(hProcess, *address)
  Declare.f readAsFloat(hProcess, *address)
  Declare.b readAsByte(hProcess, *address)
  Declare.w readAsWord(hProcess, *address)
  Declare.s readAsStringA(hProcess, *address, maxSize)
  Declare writeAsFloat(hProcess, *address, value.f)
  Declare writeAsLong(hProcess, *address, value.l)
  Declare writeAsInteger(hProcess, *address, value.i)
  Declare writeFromBuffer(hProcess, *address, *buffer, bufferSize)
  Declare writeAsByte(hProcess, *address, value.b)
  Declare writeAsWord(hProcess, *address, value.w)
  Declare findBytePattern(hProcess, pattern.s, bufferSize=4096, *baseAddress=0)
  Declare getAddressOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.f readAsFloatWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.i readAsIntegerWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.l readAsLongWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.w readAsWordWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.b readAsByteWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.f writeAsFloatWithOffset(hProcess, *address, value.f, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.i writeAsIntegerWithOffset(hProcess, *address, value, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.l writeAsLongWithOffset(hProcess, *address, value.l, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.w writeAsWordWithOffset(hProcess, *address, value.w, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
  Declare.b writeAsByteWithOffset(hProcess, *address, value.b, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
EndDeclareModule

Module Memory
  EnableExplicit
  
  Procedure getBaseAddress(hProcess)
    Protected entry.MODULEENTRY32
    Protected processId
    Protected hSnapshot
    Protected result
    Protected exitCode
    Protected lastError
    Protected lib
    Static *ptrGetprocessId
    
    If Not *ptrGetprocessId
      lib=OpenLibrary(#PB_Any,"Kernel32.dll")
      *ptrGetprocessId=GetFunction(lib,"GetProcessId")
    EndIf
    
    processId=CallFunctionFast(*ptrGetprocessId,hProcess)
    
    entry\dwSize=SizeOf(MODULEENTRY32)
    
    hSnapshot=Win32_KERNEL32::CreateToolhelp32Snapshot(#TH32CS_SNAPMODULE|#TH32CS_SNAPMODULE32,processId)
   
    If hSnapshot=#INVALID_HANDLE_VALUE
      ProcedureReturn 0
    EndIf
    
    Repeat
      result=Win32_KERNEL32::Module32First(hSnapshot,@Entry)
      lastError=Win32_KERNEL32::GetLastError()
      
      Win32_KERNEL32::GetExitCodeProcess(hProcess,@ExitCode)
    Until Not lastError=#ERROR_BAD_LENGTH Or Not exitCode=#STILL_ACTIVE
    
    If Not result
      Win32_KERNEL32::CloseHandle(hSnapshot)
      
      ProcedureReturn 0
    EndIf
    
    Win32_KERNEL32::CloseHandle(hSnapshot)
    
    ProcedureReturn entry\modBaseAddr
  EndProcedure
  
  Procedure.s readAsStringA(hProcess, *address, maxSize)
    Protected *mem
    Protected string.s
    
    *mem=AllocateMemory(maxSize)
    
    readToBuffer(hProcess,*address,*mem,maxSize)
    
    ;/ Set null byte
    PokeB(*mem+maxSize-1,0)
    
    string.s=PeekS(*mem,-1,#PB_Ascii)
    
    FreeMemory(*mem)
    
    ProcedureReturn string.s
  EndProcedure
  
  Procedure.i readToBuffer(hProcess, *address, *buffer, bufferSize)
    Protected bytesRead
    
    Win32_KERNEL32::ReadProcessMemory(hProcess,*address,*buffer,bufferSize,@bytesRead)
    
    ProcedureReturn bytesRead
  EndProcedure
  
  Procedure.l readAsLong(hProcess, *address)
    Protected bytesRead
    Protected long.l
    
    Win32_KERNEL32::ReadProcessMemory(hProcess,*address,@long,SizeOf(long),@bytesRead)
    
    ProcedureReturn long
  EndProcedure
  
  Procedure.i readAsInteger(hProcess, *address)
    Protected bytesRead
    Protected integer
    
    Win32_KERNEL32::ReadProcessMemory(hProcess,*address,@integer,SizeOf(integer),@bytesRead)
    
    ProcedureReturn integer
  EndProcedure
  
  Procedure.f readAsFloat(hProcess, *address)
    Protected bytesRead
    Protected float.f
    
    Win32_KERNEL32::ReadProcessMemory(hProcess,*address,@float.f,SizeOf(float),@bytesRead)
    
    ProcedureReturn float.f
  EndProcedure
  
  Procedure.b readAsByte(hProcess, *address)
    Protected bytesRead
    Protected byte.b
    
    Win32_KERNEL32::ReadProcessMemory(hProcess,*address,@byte,SizeOf(byte),@bytesRead)
    
    ProcedureReturn byte.b
  EndProcedure
  
  Procedure.w readAsWord(hProcess, *address)
    Protected bytesRead
    Protected word.w
    
    Win32_KERNEL32::ReadProcessMemory(hProcess,*address,@word,SizeOf(word),@bytesRead)
    
    ProcedureReturn word
  EndProcedure
  
  Procedure writeAsFloat(hProcess, *address, value.f)
    Protected bytesWritten
    
    Win32_KERNEL32::WriteProcessMemory(hProcess,*address,@value.f,SizeOf(float),@bytesWritten)
  EndProcedure
  
  Procedure writeAsLong(hProcess, *address, value.l)
    Protected bytesWritten
    
    Win32_KERNEL32::WriteProcessMemory(hProcess,*address,@value,SizeOf(long),@bytesWritten)
  EndProcedure
  
  Procedure writeAsInteger(hProcess, *address, value)
    Protected bytesWritten
    
    Win32_KERNEL32::WriteProcessMemory(hProcess,*address,@value,SizeOf(integer),@bytesWritten)
  EndProcedure
  
  Procedure writeFromBuffer(hProcess, *address, *buffer, bufferSize)
    Protected bytesWritten
    Protected i
    
    If *buffer=0
      *buffer=AllocateMemory(bufferSize)
      
      ;/ Fill buffer with NOPs
      For i=0 To bufferSize-1
        PokeB(*buffer+i,$90)
      Next i
      
      Win32_KERNEL32::WriteProcessMemory(hProcess,*address,*buffer,bufferSize,@bytesWritten)
      
      FreeMemory(*buffer)
      
      ProcedureReturn
    EndIf
    
    Win32_KERNEL32::WriteProcessMemory(hProcess,*address,*buffer,bufferSize,@bytesWritten)
  EndProcedure
  
  Procedure writeAsByte(hProcess, *address, value.b)
    Protected bytesWritten
    
    Win32_KERNEL32::WriteProcessMemory(hProcess,*address,@value,SizeOf(byte),@bytesWritten)
  EndProcedure
  
  Procedure writeAsWord(hProcess, *address, value.w)
    Protected bytesWritten
    
    Win32_KERNEL32::WriteProcessMemory(hProcess,*address,@value,SizeOf(word),@bytesWritten)
  EndProcedure
  
  ;/ Pattern in hex delimited by spaces
  Procedure findBytePattern(hProcess, pattern.s, bufferSize=4096, *baseAddress=0)
    Protected *buffer
    Protected bytesRead
    Protected matchCount
    Protected i
    Protected *matchAddress
    Protected entry.s
    
    NewList patternList.l()
    
    For i=1 To CountString(pattern.s," ")+1
      AddElement(patternList())
      
      entry.s=StringField(pattern.s,i," ")
      
      If Not entry.s="?"
        patternList()=Val("$"+entry.s)
      Else
        patternList()=-1
      EndIf
    Next i
    
    If Not *baseAddress
      *baseAddress=getBaseAddress(hProcess)
    EndIf
    
    Repeat
      *buffer=AllocateMemory(bufferSize)
      *baseAddress+bytesRead
      
      bytesRead=readToBuffer(hProcess,*baseAddress,*buffer,bufferSize)
      
      FirstElement(patternList())
      
      For i=0 To bytesRead-1
        If patternList()=-1 Or PeekA(*buffer+i)=patternList()
          NextElement(patternList())
          matchCount+1
          
          If matchCount=ListSize(patternList())
            *matchAddress=*baseAddress+i-ListSize(patternList())+1
            
            Break
          EndIf
        Else
          FirstElement(patternList())
          matchCount=0
        EndIf
      Next i
      
      FreeMemory(*buffer)
    Until bytesRead<bufferSize Or matchCount=ListSize(patternList())
    
    If matchCount=ListSize(patternList())
      ProcedureReturn *matchAddress
    EndIf
    
    ProcedureReturn 0
  EndProcedure
  
  Procedure getAddressOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    If Not offset1=-2147483648
      *address+offset1
    EndIf
    
    If Not offset2=-2147483648
      *address=readAsInteger(hProcess,*address)
      *address+offset2
    EndIf
    
    If Not offset3=-2147483648
      *address=readAsInteger(hProcess,*address)
      *address+offset3
    EndIf
    
    If Not offset4=-2147483648
      *address=readAsInteger(hProcess,*address)
      *address+offset4
    EndIf
    
    If Not offset5=-2147483648
      *address=readAsInteger(hProcess,*address)
      *address+offset5
    EndIf
    
    If Not offset6=-2147483648
      *address=readAsInteger(hProcess,*address)
      *address+offset6
    EndIf
    
    If Not offset7=-2147483648
      *address=readAsInteger(hProcess,*address)
      *address+offset7
    EndIf
    
    If Not offset8=-2147483648
      *address=readAsInteger(hProcess,*address)
      *address+offset8
    EndIf
    
    ProcedureReturn *address
  EndProcedure
  
  Procedure.f readAsFloatWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    Protected result.f
    
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    result.f=readAsFloat(hProcess,*address)
    
    ProcedureReturn result.f
  EndProcedure
  
  Procedure.i readAsIntegerWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    Protected result
    
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    result=readAsInteger(hProcess,*address)
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.l readAsLongWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    Protected result.l
    
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    result.l=readAsLong(hProcess,*address)
    
    ProcedureReturn result.l
  EndProcedure
  
  Procedure.w readAsWordWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    Protected result.w
    
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    result.w=readAsWord(hProcess,*address)
    
    ProcedureReturn result.w
  EndProcedure
  
  
  Procedure.b readAsByteWithOffset(hProcess, *address, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    Protected result.b
    
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    result.b=readAsByte(hProcess,*address)
    
    ProcedureReturn result.b
  EndProcedure
  
  Procedure.f writeAsFloatWithOffset(hProcess, *address, value.f, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    writeAsFloat(hProcess,*address,value.f)
  EndProcedure
  
  Procedure.i writeAsIntegerWithOffset(hProcess, *address, value, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    writeAsInteger(hProcess,*address,value)
  EndProcedure
  
  Procedure.l writeAsLongWithOffset(hProcess, *address, value.l, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    writeAsLong(hProcess,*address,value)
  EndProcedure
  
  Procedure.w writeAsWordWithOffset(hProcess, *address, value.w, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    writeAsWord(hProcess,*address,value)
  EndProcedure
  
  
  Procedure.b writeAsByteWithOffset(hProcess, *address, value.b, offset1=-2147483648, offset2=-2147483648, offset3=-2147483648, offset4=-2147483648, offset5=-2147483648, offset6=-2147483648, offset7=-2147483648, offset8=-2147483648)
    *address=getAddressOffset(hProcess,*address,offset1,offset2,offset3,offset4,offset5,offset6,offset7,offset8)
    
    writeAsByte(hProcess,*address,value)
  EndProcedure
EndModule

DisableExplicit