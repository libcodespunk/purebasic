DeclareModule Assertion
  Macro ASSERT(expression_, errorString_="")
    CompilerIf #PB_Compiler_Debugger
    If Not Bool(expression_)
      If Not errorString_=""
        DebuggerError("ASSERT: '"+errorString_+"' at line "+Str(#PB_Compiler_Line)+" in file "+#DQUOTE$+#PB_Compiler_File+#DQUOTE$)
      EndIf
      
      Debug "ASSERT: Failure at line "+Str(#PB_Compiler_Line)+" in file "+#DQUOTE$+#PB_Compiler_File+#DQUOTE$
      
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
