XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_SAL.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Type.pb"

DeclareModule Win32
  UseModule SAL
  
  #RIDEV_INPUTSINK=$00000100
  #RID_INPUT=$10000003
  #RIM_TYPEMOUSE=0
  #RI_MOUSE_WHEEL=$0400
  #RIM_TYPEHID=2
  #RIM_TYPEKEYBOARD=1
  #SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE=$2
  #FILE_ATTRIBUTE_REPARSE_POINT=$400
  
  ; CompilerIf Not Defined(MSLLHOOKSTRUCT,#PB_Structure)
  ;   Structure MSLLHOOKSTRUCT
  ;     pt.POINT
  ;     mouseData.l
  ;     flags.l
  ;     time.l
  ;     *dwExtraInfo
  ;   EndStructure
  ; CompilerEndIf
  
  CompilerIf Not Defined(RAWHID,#PB_Structure)
  Structure RAWHID Align #PB_Structure_AlignC
    dwSizeHid.l
    dwCount.l
    bRawData.b[0]
  EndStructure
  CompilerEndIf
  
  CompilerIf Not Defined(RAWKEYBOARD,#PB_Structure)
  Structure RAWKEYBOARD Align #PB_Structure_AlignC
    makeCode.w
    flags.w
    reserved.w
    vKey.w
    message.l
    extraInformation.l
  EndStructure
  CompilerEndIf
  
  CompilerIf Not Defined(USEBUTTON,#PB_Structure)
  Structure USEBUTTON Align #PB_Structure_AlignC
    usFlags.w
    usData.w
  EndStructure
  CompilerEndIf
  
  CompilerIf Not Defined(RAWMOUSE,#PB_Structure)
  Structure RAWMOUSE Align #PB_Structure_AlignC
    usFlags.w
    StructureUnion
      ulButtons.l
      usButton.USEBUTTON
    EndStructureUnion
    ulRawButtons.l
    lLastX.l
    lLastY.l
    ulExtraInformation.l
  EndStructure
  CompilerEndIf
  
  ;/ Fixes an incorrect resident definition; implemented in 5.42
  CompilerIf #PB_Compiler_Version<542
  Structure RAWMOUSE Align #PB_Structure_AlignC
    usFlags.w
    StructureUnion
      ulButtons.l
      usButton.USEBUTTON
    EndStructureUnion
    ulRawButtons.l
    lLastX.l
    lLastY.l
    ulExtraInformation.l
  EndStructure
  CompilerElse
  Structure _PB_Win32_RAWMOUSE Align #PB_Structure_AlignC
    usFlags.w
    StructureUnion
      ulButtons.l
      usButton.USEBUTTON
    EndStructureUnion
    ulRawButtons.l
    lLastX.l
    lLastY.l
    ulExtraInformation.l
  EndStructure
  Macro RAWMOUSE
    _PB_Win32_RAWMOUSE
  EndMacro
  CompilerEndIf
  
  CompilerIf #PB_Compiler_Version<542
  Structure RAWINPUTHEADER Align #PB_Structure_AlignC
    dwType.l
    dwSize.l
    hDevice.i
    wParam.i
  EndStructure
  CompilerElse
  ;/ Fixes an incorrect resident definition; implemented in 5.42
  Structure _PB_Win32_RAWINPUTHEADER Align #PB_Structure_AlignC
    dwType.l
    dwSize.l
    hDevice.i
    wParam.i
  EndStructure
  Macro RAWINPUTHEADER
    _PB_Win32_RAWINPUTHEADER
  EndMacro
  CompilerEndIf
  
  ;/ Fixes an incorrect resident definition; implemented in 5.42
  CompilerIf #PB_Compiler_Version<542
  Structure RAWINPUT Align #PB_Structure_AlignC
    header.RAWINPUTHEADER
    StructureUnion
      mouse.RAWMOUSE
      keyboard.RAWKEYBOARD
      hid.RAWHID
    EndStructureUnion
  EndStructure
  CompilerElse
  Structure _PB_Win32_RAWINPUT Align #PB_Structure_AlignC
    header.RAWINPUTHEADER
    StructureUnion
      mouse.RAWMOUSE
      keyboard.RAWKEYBOARD
      hid.RAWHID
    EndStructureUnion
  EndStructure
  Macro RAWINPUT
    _PB_Win32_RAWINPUT
  EndMacro
  CompilerEndIf
  
  CompilerIf Not Defined(RAWINPUTDEVICE,#PB_Structure)
  Structure RAWINPUTDEVICE Align #PB_Structure_AlignC
    usUsagePage.w
    usUsage.w
    dwFlags.l
    hwndTarget.i
  EndStructure
  CompilerEndIf
  
  CompilerIf Not Defined(MSLLHOOKSTRUCT,#PB_Structure)
  Structure MSLLHOOKSTRUCT Align #PB_Structure_AlignC
    pt.POINT
    mouseData.l
    flags.l
    time.l
    dwExtraInfo.i
  EndStructure
  CompilerEndIf
  
  Macro LOBYTE(Byte)
    (Byte&$FF)
  EndMacro
  
  Macro HIBYTE(Byte)
    ((Byte>>8)&$FF)
  EndMacro
  
  Macro LOWORD(Word)
    (Word&$FFFF)
  EndMacro
  
  Macro HIWORD(Word)
    ((Word>>16)&$FFFF)
  EndMacro
  
  Macro MAKEWORD(a, b)
    (a&$FF)|((b&$FF)<<8)
  EndMacro
  
  Macro MAKELONG(a, b)
    ((a&$FFFF)+b<<16)
  EndMacro
  
  Macro WPARAM
    Type::UINT_32_64
  EndMacro
  
  Macro LPARAM
    Type::INT_32_64
  EndMacro
  
  Macro LRESULT
    Type::INT_32_64
  EndMacro
  
  Macro PUINT
    Type::UINT_32_64_POINTER
  EndMacro
  
  Macro HANDLE
    Type::UINT_32_64
  EndMacro
  
  Macro HWND
    Win32::HANDLE
  EndMacro
  
  Macro HRAWINPUT
    Win32::HANDLE
  EndMacro
  
  Macro HHOOK
    Win32::HANDLE
  EndMacro
  
  Macro BOOL
    Type::INT_32
  EndMacro
  
  Macro BOOLEAN
    Type::UINT_8
  EndMacro
  
  Macro HDC
    Win32::HANDLE
  EndMacro
  
  Macro DWORD
    Type::UINT_32
  EndMacro
  
  Macro LONG
    Type::INT_32
  EndMacro
  
  Macro UINT
    Type::UINT_32_64
  EndMacro
  
  Macro HINSTANCE
    Win32::HANDLE
  EndMacro
  
  Macro HRESULT
    Win32::LONG
  EndMacro
  
  Macro FAILED(a)
    Bool((a)<0)
  EndMacro
  
  Macro CHAR_POINTER_REFERENCE
    Type::UINT_32_64
  EndMacro
  
  Macro TCHAR_POINTER_REFERENCE
    Type::UINT_32_64
  EndMacro
  
  Structure PCRAWINPUTDEVICE
    arrayIndex.RAWINPUTDEVICE[0]
  EndStructure
  
  Prototype.UINT _USER32DLL_GetRawInputData(_IN RawInput.HRAWINPUT, _IN Command.Type::UINT_32_64, _OUT_OPT *pData, _IN_OUT *pSize.Type::UINT_32_64_REFERENCE, _IN SizeHeader.UINT)
  Prototype.BOOL _USER32DLL_RegisterRawInputDevices(_IN *pRawInputDevices.PCRAWINPUTDEVICE, _IN NumDevices.UINT, _IN Size.UINT)
  Prototype.HANDLE _KERNEL32DLL_OpenThread(_IN DesiredAccess.DWORD, _IN InheritHandle.BOOL, _In ThreadId.DWORD)
  
  CompilerIf #PB_Compiler_Unicode
  Declare.i _GetProcAddress(*hModule, *lpProcName)
  CompilerEndIf
  
  Declare.s _FormatMessage(_IN messageId.DWORD, _IN flags.DWORD=#FORMAT_MESSAGE_FROM_SYSTEM, _IN_OPT *source=0, _IN LanguageId.DWORD=0, _IN_OPT *arguments=0)
  Declare.DWORD GetThreadId(_IN threadId)
  Declare.HANDLE OpenThread(_IN dwDesiredAccess.DWORD, _IN bInheritHandle.BOOL, _IN dwThreadId.DWORD)
EndDeclareModule

Module Win32
  CompilerIf #PB_Compiler_Unicode
  Procedure.i _GetProcAddress(*hModule, *lpProcName)
    Protected *ascii=Ascii(PeekS(*lpProcName))
    Protected *address=GetProcAddress_(*hModule,*ascii)
    
    FreeMemory(*ascii)
    
    ProcedureReturn *address
  EndProcedure
  CompilerEndIf
  
  Procedure.s _FormatMessage(_IN messageId.DWORD, _IN flags.DWORD=#FORMAT_MESSAGE_FROM_SYSTEM, _IN_OPT *source=0, _IN languageId.DWORD=0, _IN_OPT *arguments=0)
    Protected buffer.s{4096}
    Protected charsWritten.DWORD
    
    charsWritten=FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM,0,messageId,0, @buffer.s,4096-1,0)
    
    If charsWritten
      ProcedureReturn Left(buffer.s,charsWritten-2)
    EndIf
    
    ProcedureReturn ""
  EndProcedure
  
  Procedure.DWORD GetThreadId(_IN threadId)
    Static *p
    
    If Not *p
      *p=_GetProcAddress(GetModuleHandle_(@"kernel32.dll"),@"GetThreadId")
    EndIf
    
    CompilerIf #PB_Compiler_Debugger
    If Not *p
      DebuggerError("Invalid or missing procedure")
    EndIf
    CompilerEndIf
    
    ProcedureReturn CallFunctionFast(*p,threadId)
  EndProcedure
  
  Procedure.HANDLE OpenThread(_IN dwDesiredAccess.DWORD, _IN bInheritHandle.BOOL, _IN dwThreadId.DWORD)
    Static *p
    
    If Not *p
      *p=_GetProcAddress(GetModuleHandle_(@"kernel32.dll"),@"OpenThread")
    EndIf
    
    CompilerIf #PB_Compiler_Debugger
    If Not *p
      DebuggerError("Invalid or missing procedure")
    EndIf
    CompilerEndIf
    
    ProcedureReturn CallFunctionFast(*p,dwDesiredAccess,bInheritHandle,dwThreadId)
  EndProcedure
EndModule

CompilerIf #PB_Compiler_Unicode
Macro GetProcAddress_(hModule, lpProcName)
  Win32::_GetProcAddress(hModule, lpProcName)
EndMacro
CompilerEndIf

Macro FormatMessage_(messageId_, flags_, source_, languageId_, arguments_)
  Win32::_FormatMessage(messageId_, flags_, source_, languageId_, arguments_)
EndMacro
