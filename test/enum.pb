XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Enum.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_SAL.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Type.pb"

DeclareModule _ENUM_CARDINAL_DIRECTION
  UseModule SAL
  
  #ENUM_CARDINAL_DIRECTION_NONE=0
  #ENUM_CARDINAL_DIRECTION_NORTH=2<<0
  #ENUM_CARDINAL_DIRECTION_EAST=2<<1
  #ENUM_CARDINAL_DIRECTION_SOUTH=2<<2
  #ENUM_CARDINAL_DIRECTION_WEST=2<<3
  #ENUM_CARDINAL_DIRECTION_NORTHEAST=#ENUM_CARDINAL_DIRECTION_NORTH|#ENUM_CARDINAL_DIRECTION_EAST
  #ENUM_CARDINAL_DIRECTION_SOUTHEAST=#ENUM_CARDINAL_DIRECTION_SOUTH|#ENUM_CARDINAL_DIRECTION_WEST
  #ENUM_CARDINAL_DIRECTION_SOUTHWEST=#ENUM_CARDINAL_DIRECTION_NORTH|#ENUM_CARDINAL_DIRECTION_EAST
  #ENUM_CARDINAL_DIRECTION_NORTHWEST=#ENUM_CARDINAL_DIRECTION_SOUTH|#ENUM_CARDINAL_DIRECTION_WEST
  #ENUM_CARDINAL_DIRECTION_UP=2<<4
  #ENUM_CARDINAL_DIRECTION_DOWN=2<<5
EndDeclareModule

Module _ENUM_CARDINAL_DIRECTION
EndModule

DeclareModule ENUM_CARDINAL_DIRECTION
  UseModule _ENUM_CARDINAL_DIRECTION
  UseModule SAL
  
  Macro OBJECT_POINTER
    Type::POINTER
  EndMacro
  
  Interface IObject Extends ENUM::IObject
  EndInterface
  
  ;/ Static
  Global NewMap values.ENUM::IObject()
  
  ;/ Static methods
  Declare.OBJECT_POINTER fromOrdinal(_IN ordinal.Type::INT_32)
  Declare.OBJECT_POINTER valueOf(_IN name.s)
  
  ;/ Static variables
  NONE.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_NONE,"CARDINAL_DIRECTION_NONE")
  NORTH.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_NORTH,"CARDINAL_DIRECTION_NORTH")
  EAST.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_EAST,"CARDINAL_DIRECTION_EAST")
  SOUTH.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_SOUTH,"CARDINAL_DIRECTION_SOUTH")
  WEST.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_WEST,"CARDINAL_DIRECTION_WEST")
  NORTHEAST.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_NORTHEAST,"CARDINAL_DIRECTION_NORTHEAST")
  SOUTHEAST.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_SOUTHEAST,"CARDINAL_DIRECTION_SOUTHEAST")
  SOUTHWEST.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_SOUTHWEST,"CARDINAL_DIRECTION_SOUTHWEST")
  NORTHWEST.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_NORTHWEST,"CARDINAL_DIRECTION_NORTHWEST")
  UP.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_UP,"CARDINAL_DIRECTION_UP")
  DOWN.IObject=_Enum::new(values(),#ENUM_CARDINAL_DIRECTION_DOWN,"CARDINAL_DIRECTION_DOWN")
  
  Declare.OBJECT_POINTER fromOrdinal(_IN ordinal.Type::INT_32)
  Declare.OBJECT_POINTER valueOf(_IN name.s)
EndDeclareModule

Module ENUM_CARDINAL_DIRECTION
  Procedure.OBJECT_POINTER fromOrdinal(_IN ordinal.Type::INT_32)
    ProcedureReturn _Enum::fromOrdinal(values(), ordinal)
  EndProcedure
  
  Procedure.OBJECT_POINTER valueOf(_IN name.s)
    ProcedureReturn _Enum::valueOf(values(), name.s)
  EndProcedure
EndModule

;/ Enums can have names (for debug and serialization)
Debug ENUM_CARDINAL_DIRECTION::NONE\name()

Debug "--"

;/ Query the enum for all values
ForEach ENUM_CARDINAL_DIRECTION::values()
  With ENUM_CARDINAL_DIRECTION::values()
    Debug Str(\ordinal())+" "+\name()
  EndWith
Next

Debug "--"

;/ From ordinal
Define result.ENUM_CARDINAL_DIRECTION::IObject

result=ENUM_CARDINAL_DIRECTION::fromOrdinal(4)

Debug result\name()

Debug "--"

;/ Deserialize and validation
If Not ENUM_CARDINAL_DIRECTION::valueOf("UNKNOWN")
  Debug "No enum by that name"
EndIf
