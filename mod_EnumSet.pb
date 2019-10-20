XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Enum.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_SAL.pb"

DeclareModule EnumSet
  UseModule SAL
  UseModule Enum
  
  Macro TYPE(enum_)
    Enum::ORDINAL_TYPE
  EndMacro
  
  Macro ORDINAL_SET
    Enum::ORDINAL_TYPE
  EndMacro
  
  Declare.ORDINAL_SET allOf(_IN Map values.IObject())
  Declare.ORDINAL_SET copyOf(_IN ordinalSet.ORDINAL_SET)
  Declare.ORDINAL_SET noneOf(_IN Map values.IObject())
  Declare.ORDINAL_SET of(_IN e1.IObject, _IN_OPT e2.IObject=0,
    _IN_OPT e3.IObject=0, _IN_OPT e4.IObject=0, _IN_OPT e5.IObject=0,
    _IN_OPT e6.IObject=0, _IN_OPT e7.IObject=0, _IN_OPT e8.IObject=0,
    _IN_OPT e9.IObject=0, _IN_OPT e10.IObject=0, _IN_OPT e11.IObject=0,
    _IN_OPT e12.IObject=0, _IN_OPT e13.IObject=0, _IN_OPT e14.IObject=0,
    _IN_OPT e15.IObject=0, _IN_OPT e16.IObject=0, _IN_OPT e17.IObject=0,
    _IN_OPT e18.IObject=0, _IN_OPT e19.IObject=0, _IN_OPT e20.IObject=0,
    _IN_OPT e21.IObject=0, _IN_OPT e22.IObject=0, _IN_OPT e23.IObject=0,
    _IN_OPT e24.IObject=0, _IN_OPT e25.IObject=0, _IN_OPT e26.IObject=0)
EndDeclareModule

Module EnumSet
  Procedure.ORDINAL_SET allOf(_IN Map values.IObject())
    Protected r
    
    ForEach values()
      r|values()\ordinal()
    Next
    
    ProcedureReturn r
  EndProcedure
  
  Procedure.ORDINAL_SET copyOf(_IN ordinalSet.ORDINAL_SET)
    ProcedureReturn ordinalSet
  EndProcedure
  
  Procedure.ORDINAL_SET noneOf(_IN Map values.IObject())
    ProcedureReturn 0
  EndProcedure
  
  Procedure.ORDINAL_SET of(_IN e1.IObject, _IN_OPT e2.IObject=0,
    _IN_OPT e3.IObject=0, _IN_OPT e4.IObject=0, _IN_OPT e5.IObject=0,
    _IN_OPT e6.IObject=0, _IN_OPT e7.IObject=0, _IN_OPT e8.IObject=0,
    _IN_OPT e9.IObject=0, _IN_OPT e10.IObject=0, _IN_OPT e11.IObject=0,
    _IN_OPT e12.IObject=0, _IN_OPT e13.IObject=0, _IN_OPT e14.IObject=0,
    _IN_OPT e15.IObject=0, _IN_OPT e16.IObject=0, _IN_OPT e17.IObject=0,
    _IN_OPT e18.IObject=0, _IN_OPT e19.IObject=0, _IN_OPT e20.IObject=0,
    _IN_OPT e21.IObject=0, _IN_OPT e22.IObject=0, _IN_OPT e23.IObject=0,
    _IN_OPT e24.IObject=0, _IN_OPT e25.IObject=0, _IN_OPT e26.IObject=0)
    Protected r
    
    If e1
      r|e1\ordinal()
    EndIf
    
    If e2
      r|e2\ordinal()
    EndIf
    
    If e3
      r|e3\ordinal()
    EndIf
    
    If e4
      r|e4\ordinal()
    EndIf
    
    If e5
      r|e5\ordinal()
    EndIf
    
    If e6
      r|e6\ordinal()
    EndIf
    
    If e7
      r|e7\ordinal()
    EndIf
    
    If e8
      r|e8\ordinal()
    EndIf
    
    If e9
      r|e9\ordinal()
    EndIf
    
    If e10
      r|e10\ordinal()
    EndIf
    
    If e11
      r|e11\ordinal()
    EndIf
    
    If e12
      r|e12\ordinal()
    EndIf
    
    If e13
      r|e13\ordinal()
    EndIf
    
    If e14
      r|e14\ordinal()
    EndIf
    
    If e15
      r|e15\ordinal()
    EndIf
    
    If e16
      r|e16\ordinal()
    EndIf
    
    If e17
      r|e17\ordinal()
    EndIf
    
    If e18
      r|e18\ordinal()
    EndIf
    
    If e19
      r|e19\ordinal()
    EndIf
    
    If e20
      r|e20\ordinal()
    EndIf
    
    If e21
      r|e21\ordinal()
    EndIf
    
    If e22
      r|e22\ordinal()
    EndIf
    
    If e23
      r|e23\ordinal()
    EndIf
    
    If e24
      r|e24\ordinal()
    EndIf
    
    If e25
      r|e25\ordinal()
    EndIf
    
    If e26
      r|e26\ordinal()
    EndIf
    
    ProcedureReturn r
  EndProcedure
EndModule
