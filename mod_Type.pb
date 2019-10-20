DeclareModule Type
  Structure POINTER_TYPE
  EndStructure
  
  Macro VOID
    i
  EndMacro
  
  Macro POINTER
    i
  EndMacro
  
  Macro BOOLEAN
    b
  EndMacro
  
  Macro UCHAR_8
    a
  EndMacro
  
  Macro CHAR_8_16
    c
  EndMacro
  
  Macro INT_8
    b
  EndMacro
  
  Macro UINT_8
    a
  EndMacro
  
  Macro INT_16
    w
  EndMacro
  
  Macro UINT_16
    u
  EndMacro
  
  Macro INT_32
    l
  EndMacro
  
  Macro UINT_32
    l
  EndMacro
  
  Macro INT_64
    q
  EndMacro
  
  Macro UINT_64
    q
  EndMacro
  
  Macro INT_32_64
    i
  EndMacro
  
  Macro UINT_32_64
    i
  EndMacro
  
  Structure _Type_Boolean_Reference
    deref.b
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure BOOLEAN_REFERENCE Extends _Type_Boolean_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro BOOLEAN_REFERENCE
    Type::_Type_Boolean_Reference
  EndMacro
  
  Structure _Type_Character_Reference
    deref.c
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure CHAR_REFERENCE Extends _Type_Character_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro CHAR_REFERENCE
    Type::_Type_Character_Reference
  EndMacro
  
  Structure _Type_Ascii_Reference
    deref.a
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure ASCII_REFERENCE Extends _Type_Ascii_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro ASCII_REFERENCE
    Type::_Type_Ascii_Reference
  EndMacro
  
  Structure _Type_Unicode_Reference
    deref.u
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure UNICODE_REFERENCE Extends _Type_Unicode_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro UNICODE_REFERENCE
    Type::_Type_Unicode_Reference
  EndMacro
  
  Structure _Type_Byte_Reference
    deref.b
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure INT_8_REFERENCE Extends _Type_Ascii_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro INT_8_REFERENCE
    Type::_Type_Byte_Reference
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure UINT_8_REFERENCE Extends _Type_Ascii_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro UINT_8_REFERENCE
    Type::_Type_Ascii_Reference
  EndMacro
  
  Structure _Type_Word_Reference
    deref.w
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure INT_16_REFERENCE Extends _Type_Word_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro INT_16_REFERENCE
    Type::_Type_Word_Reference
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure UINT_16_REFERENCE Extends _Type_Unicode_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro UINT_16_REFERENCE
    Type::_Type_Unicode_Reference
  EndMacro
  
  Structure _Type_Long_Reference
    deref.l
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure INT_32_REFERENCE Extends _Type_Long_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro INT_32_REFERENCE
    Type::_Type_Long_Reference
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure UINT_32_REFERENCE Extends _Type_Long_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro UINT_32_REFERENCE
    Type::_Type_Long_Reference
  EndMacro
  
  Structure _Type_Integer_Reference
    deref.i
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure INT_32_64_REFERENCE Extends _Type_Integer_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro INT_32_64_REFERENCE
    Type::_Type_Integer_Reference
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure UINT_32_64_REFERENCE Extends _Type_Integer_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro UINT_32_64_REFERENCE
    Type::_Type_Integer_Reference
  EndMacro
  
  Structure _Type_Quad_Reference
    deref.q
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure INT_64_REFERENCE Extends _Type_Quad_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro INT_64_REFERENCE
    Type::_Type_Quad_Reference
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure UINT_64_REFERENCE Extends _Type_Quad_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro UINT_64_REFERENCE
    Type::_Type_Quad_Reference
  EndMacro
  
  Structure _Type_Pointer_Reference
    deref.i
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure POINTER_REFERENCE Extends _Type_Pointer_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro POINTER_REFERENCE
    Type::_Type_Pointer_Reference
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure VOID_REFERENCE Extends _Type_Pointer_Reference
  EndStructure
  CompilerEndIf
  ;/ -
  Macro VOID_REFERENCE
    Type::_Type_Pointer_Reference
  EndMacro
  
  Macro INT16_LOW(Word)
    ((Word)|$FFFF0000)
  EndMacro
  
  Macro INT16_HIGH(Word)
    ((Word)>>16)
  EndMacro
  
  Macro UINT16_LOW(Word)
    ((Word)&$FFFF)
  EndMacro
  
  Macro UINT16_HIGH(Word)
    (((Word)>>16)&$FFFF)
  EndMacro
  
  Macro INT32_LOW(Long)
    ((Long)|$FFFFFFFF00000000)
  EndMacro
  
  Macro INT32_HIGH(Long)
    ((Long)>>32)
  EndMacro
  
  Macro UINT32_LOW(Long)
    ((Long)&$FFFFFFFF)
  EndMacro
  
  Macro UINT32_HIGH(Long)
    (((Long)>>32)&$FFFFFFFF)
  EndMacro
  
  Macro INT64_LOW(Quad)
    ((Quad)|$FFFFFFFFFFFFFFFF0000000000000000)
  EndMacro
  
  Macro INT64_HIGH(Quad)
    ((Quad)>>64)
  EndMacro
  
  Macro UINT64_LOW(Quad)
    ((Quad)&$FFFFFFFFFFFFFFFF)
  EndMacro
  
  Macro UINT64_HIGH(Quad)
    (((Quad)>>64)&$FFFFFFFFFFFFFFFF)
  EndMacro
  
  CompilerIf #PB_Compiler_Processor=#PB_Processor_x64
  Macro UINT(Integer)
    ((Integer)&$FFFFFFFFFFFFFFFF)
  EndMacro
  CompilerElse
  Macro UINT(Integer)
    ((Integer)&$FFFFFFFF)
  EndMacro
  CompilerEndIf
  
  Macro UINT8(Byte)
    ((Byte)&$FF)
  EndMacro
  
  Macro UINT16(Word)
    ((Word)&$FFFF)
  EndMacro
  
  Macro UINT32(Long)
    ((Long)&$FFFFFFFF)
  EndMacro
  
  Macro UINT64(Quad)
    ((Quad)&$FFFFFFFFFFFFFFFF)
  EndMacro
  
  Macro INT8(Byte)
    Type::_Type_INT8((Byte)&$FF)
  EndMacro
  
  Macro INT16(Word)
    Type::_Type_INT16((Word)&$FFFF)
  EndMacro
  
  Macro INT32(Long)
    Type::_Type_INT32((Long)&$FFFFFFFF)
  EndMacro
  
  Macro INT64(Quad)
    Type::_Type_INT64((Quad)&$FFFFFFFFFFFFFFFF)
  EndMacro
  
  Structure CHAR_ARRAY
    deref.c[0]
  EndStructure
  
  Structure ASCII_ARRAY
    deref.a[0]
  EndStructure
  
  Structure INT8_ARRAY
    deref.b[0]
  EndStructure
  
  Structure INT16_ARRAY
    deref.w[0]
  EndStructure
  
  Structure INT32_ARRAY
    deref.l[0]
  EndStructure
  
  Structure INT64_ARRAY
    deref.q[0]
  EndStructure
  
  Structure UINT8_ARRAY
    deref.a[0]
  EndStructure
  
  Structure UINT16_ARRAY
    deref.u[0]
  EndStructure
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure U8 Extends ASCII_ARRAY
  EndStructure
  CompilerEndIf
  ;/ -
  Macro U8
    Type::ASCII_ARRAY
  EndMacro
  
  CompilerIf #False
  Structure U16 Extends UINT16_ARRAY
  EndStructure
  CompilerEndIf
  ;/ -
  Macro U16
    Type::UINT16_ARRAY
  EndMacro
  
  CompilerIf #False
  Structure U32 Extends INT32_ARRAY
  EndStructure
  CompilerEndIf
  ;/ -
  Macro U32
    Type::INT32_ARRAY
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure USTRING8 Extends ASCII_ARRAY
  EndStructure
  CompilerEndIf
  ;/ -
  Macro USTRING8
    Type::ASCII_ARRAY
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure USTRING16 Extends UINT16_ARRAY
  EndStructure
  CompilerEndIf
  ;/ -
  Macro USTRING16
    Type::UINT16_ARRAY
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure USTRING32 Extends INT32_ARRAY
  EndStructure
  CompilerEndIf
  ;/ -
  Macro USTRING32
    Type::INT32_ARRAY
  EndMacro
  
  Macro USTRING8_CHAR
    a
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure USTRING8_CHAR_REFERENCE Extends UCHAR_8_REFERENCE
  EndStructure
  CompilerEndIf
  ;/ -
  Macro USTRING8_CHAR_REFERENCE
    Type::_Type_Ascii_Reference
  EndMacro
  
  Macro USTRING16_CHAR
    a
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure USTRING16_CHAR_REFERENCE Extends UCHAR_8_REFERENCE
  EndStructure
  CompilerEndIf
  ;/ -
  Macro USTRING16_CHAR_REFERENCE
    Type::_Type_Unicode_Reference
  EndMacro
  
  Macro USTRING32_CHAR
    l
  EndMacro
  
  ;/ IDE auto-complete workaround
  CompilerIf #False
  Structure USTRING32_CHAR_REFERENCE Extends UCHAR_8_REFERENCE
  EndStructure
  CompilerEndIf
  ;/ -
  Macro USTRING32_CHAR_REFERENCE
    Type::_Type_Long_Reference
  EndMacro
  
  Declare.INT_8 _Type_INT8(byte.UINT_8)
  Declare.INT_16 _Type_INT16(word.UINT_16)
  Declare.INT_32 _Type_INT32(long.UINT_32)
  Declare.INT_64 _Type_INT64(quad.UINT_64)
  
  Macro MUTEX
    i
  EndMacro
  
  Macro SEMAPHORE
    i
  EndMacro
EndDeclareModule

Module Type
  Procedure.INT_8 _Type_INT8(byte.UINT_8)
    ProcedureReturn byte
  EndProcedure
  
  Procedure.INT_16 _Type_INT16(word.UINT_16)
    ProcedureReturn word
  EndProcedure
  
  Procedure.INT_32 _Type_INT32(long.UINT_32)
    ProcedureReturn long
  EndProcedure
  
  Procedure.INT_64 _Type_INT64(quad.UINT_64)
    ProcedureReturn quad
  EndProcedure
EndModule
