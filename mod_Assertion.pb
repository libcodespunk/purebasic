DeclareModule Assertion
  Macro ASSERT(expression_, errorString_="")
    CompilerIf #PB_Compiler_Debugger
    If Not Bool(expression_)
      If Not errorString_=""
        DebuggerError("[ASSERT] Line "+Str(#PB_Compiler_Line)+": "+errorString_+" ("+#PB_Compiler_File+")")
      EndIf
      
      DebuggerError("[ASSERT] Line "+Str(#PB_Compiler_Line)+": Unhandled assertion ("+#PB_Compiler_File+")")
      
      End 1
    EndIf
    CompilerEndIf
  EndMacro
  
  Macro ASSERT_MAP_KEY(mapName_, mapKey_)
    Assertion::ASSERT(FindMapElement(mapName_,mapKey_),"Unknown map key: "+mapKey_)
  EndMacro
EndDeclareModule

Module Assertion
EndModule
