DeclareModule PureBasic
  Macro PB_DIRECTORY_ID
    i
  EndMacro
  
  Macro PB_LIBRARY_ID
    i
  EndMacro
  
  Macro PB_THREAD_ID
    i
  EndMacro
  
  Macro PB_WINDOW_ID
    i
  EndMacro
  
  Declare.a MinA(a.a, b.a)
  Declare.a MaxA(a.a, b.a)
  Declare.b MinB(a.b, b.b)
  Declare.b MaxB(a.b, b.b)
  Declare.c MinC(a.c, b.c)
  Declare.c MaxC(a.c, b.c)
  Declare.w MinW(a.w, b.w)
  Declare.w MaxW(a.w, b.w)
  Declare.u MinU(a.u, b.u)
  Declare.u MaxU(a.u, b.u)
  Declare.l MinL(a.l, b.l)
  Declare.l MaxL(a.l, b.l)
  Declare.i MinI(a.i, b.i)
  Declare.i MaxI(a.i, b.i)
  Declare.q MinQ(a.q, b.q)
  Declare.q MaxQ(a.q, b.q)
  Declare.f MinF(a.f, b.f)
  Declare.f MaxF(a.f, b.f)
  Declare.d MinD(a.d, b.d)
  Declare.d MaxD(a.d, b.d)
  Declare.s MinS(a.s, b.s)
  Declare.s MaxS(a.s, b.s)
EndDeclareModule

Module PureBasic
  Procedure.a MinA(a.a, b.a)
    If a<b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.a MaxA(a.a, b.a)
    If a>b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.b MinB(a.b, b.b)
    If a<b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.b MaxB(a.b, b.b)
    If a>b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.c MinC(a.c, b.c)
    If a<b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.c MaxC(a.c, b.c)
    If a>b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.w MinW(a.w, b.w)
    If a<b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.w MaxW(a.w, b.w)
    If a>b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.u MinU(a.u, b.u)
    If a<b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.u MaxU(a.u, b.u)
    If a>b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.l MinL(a.l, b.l)
    If a<b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.l MaxL(a.l, b.l)
    If a>b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.i MinI(a.i, b.i)
    If a<b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.i MaxI(a.i, b.i)
    If a>b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.q MinQ(a.q, b.q)
    If a<b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.q MaxQ(a.q, b.q)
    If a>b
      ProcedureReturn a
    EndIf
    
    ProcedureReturn b
  EndProcedure
  
  Procedure.f MinF(a.f, b.f)
    If a.f<b.f
      ProcedureReturn a.f
    EndIf
    
    ProcedureReturn b.f
  EndProcedure
  
  Procedure.f MaxF(a.f, b.f)
    If a.f>b.f
      ProcedureReturn a.f
    EndIf
    
    ProcedureReturn b.f
  EndProcedure
  
  Procedure.d MinD(a.d, b.d)
    If a.d<b.d
      ProcedureReturn a.d
    EndIf
    
    ProcedureReturn b.d
  EndProcedure
  
  Procedure.d MaxD(a.d, b.d)
    If a.d>b.d
      ProcedureReturn a.d
    EndIf
    
    ProcedureReturn b.d
  EndProcedure
  
  Procedure.s MinS(a.s, b.s)
    If a.s<b.s
      ProcedureReturn a.s
    EndIf
    
    ProcedureReturn b.s
  EndProcedure
  
  Procedure.s MaxS(a.s, b.s)
    If a.s>b.s
      ProcedureReturn a.s
    EndIf
    
    ProcedureReturn b.s
  EndProcedure
EndModule

CompilerIf #PB_Compiler_Version<=550
CompilerIf #PB_Compiler_Debugger
  Import ""
    PB_DEBUGGER_SendError(Message.p-ascii)
    PB_DEBUGGER_SendWarning(Message.p-ascii)
  EndImport
CompilerElse
  Macro PB_DEBUGGER_SendError(Message
  EndMacro
  Macro PB_DEBUGGER_SendWarning(Message)
  EndMacro
CompilerEndIf

Macro DebuggerError(Message)
  PB_DEBUGGER_SendError(Message)
EndMacro

Macro DebuggerWarning(Message)
  PB_DEBUGGER_SendWarning(Message)
EndMacro
CompilerEndIf

CompilerIf #PB_Compiler_Unicode
  Prototype.i _PB_Prototype_StringAsAddress(String.p-unicode)
CompilerElse
  Prototype.i _PB_Prototype_StringAsAddress(String.p-ascii)
CompilerEndIf

Procedure.i _PB_Definition_StringAsAddress(*String)
  ProcedureReturn *String
EndProcedure

PB_StringAsAddress._PB_Prototype_StringAsAddress=@_PB_Definition_StringAsAddress()

CompilerIf #PB_Compiler_Version<550
#PB_MessageRequester_Info=#PB_MessageRequester_Ok
#PB_MessageRequester_Warning=#PB_MessageRequester_Ok
#PB_MessageRequester_Error=#PB_MessageRequester_Ok
CompilerEndIf

CompilerIf #PB_Compiler_Version<570
  CompilerIf #PB_Compiler_OS=#PB_OS_Windows
    #PS$="\"
  CompilerElse
    #PS$="/"
  CompilerEndIf
CompilerEndIf

CompilerIf #PB_Compiler_OS=#PB_OS_Windows
  CompilerIf #PB_Compiler_Version=540 And Not #PB_Compiler_Unicode
    Import "Kernel32.lib"
      Module32First_(hSnapshot.i, *lpme) As "Module32First"
      Module32Next_(hSnapshot.i, *lpme) As "Module32Next"
    EndImport
  CompilerEndIf
CompilerEndIf
