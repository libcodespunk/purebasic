XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Assertion.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_SAL.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Type.pb"

EnableExplicit

DeclareModule Enum
  UseModule SAL
  
  Macro ORDINAL_TYPE
    Type::INT_32
  EndMacro
  
  Interface IObject
    name.s()
    ordinal.ORDINAL_TYPE()
  EndInterface
  
  Macro OBJECT_POINTER
    Type::POINTER
  EndMacro
EndDeclareModule

Module Enum
  UseModule SAL
EndModule

DeclareModule _Enum
  UseModule SAL
  UseModule Enum
  
  Structure VTable
    *name
    *ordinal
  EndStructure
  
  Structure Class
    *vTable
    name.s
    ordinal.ORDINAL_TYPE
  EndStructure
  
  ;/ Static
  Global vTable.VTable
  
  Declare.OBJECT_POINTER new(_IN_OUT Map values.IObject(), _IN ordinal.ORDINAL_TYPE, _IN name.s)
  Declare.OBJECT_POINTER fromOrdinal(_IN_OUT Map values.IObject(), _IN ordinal.ORDINAL_TYPE)
  Declare.OBJECT_POINTER valueOf(_IN_OUT Map values.IObject(), _IN name.s)
EndDeclareModule

Module _Enum
  UseModule Assertion
  UseModule SAL
  
  Procedure.OBJECT_POINTER new(_IN_OUT Map values.IObject(), _IN ordinal.ORDINAL_TYPE, _IN name.s)
    Protected *instance.Class
    
    *instance=AllocateStructure(Class)
    *instance\vTable=@vTable
    
    *instance\name.s=name.s
    *instance\ordinal=ordinal
    
    values(Str(ordinal))=*instance
    
    ProcedureReturn *instance
  EndProcedure
  
  Procedure.OBJECT_POINTER fromOrdinal(_IN_OUT Map values.IObject(), _IN ordinal.ORDINAL_TYPE)
    ASSERT_MAP_KEY(values(),Str(ordinal))
    
    ProcedureReturn values(Str(ordinal))
  EndProcedure
 
  Procedure.OBJECT_POINTER valueOf(_IN_OUT Map values.IObject(), _IN name.s)
    ForEach values()
      If values()\name()=name.s
        ProcedureReturn values()
      EndIf
    Next
    
    ASSERT(#False,"Invalid name")
    
    ProcedureReturn #Null
  EndProcedure
  
  ;/ IObject methods
  Procedure.s name(_IN *this.Class)
    ProcedureReturn *this\name.s
  EndProcedure
  
  Procedure.ORDINAL_TYPE ordinal(_IN *this.Class)
    ProcedureReturn *this\ordinal
  EndProcedure
  
  vTable\name=@name()
  vTable\ordinal=@ordinal()
EndModule

DisableExplicit
