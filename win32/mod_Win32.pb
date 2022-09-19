XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Assertion.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_PureBasic.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_SAL.pb"
XIncludeFile #CODESPUNK_HOME+"/purebasic/mod_Type.pb"

EnableExplicit

; DeclareModule _Win32_Type
; EndDeclareModule
; 
; Module _Win32_Type
; EndModule

DeclareModule _Win32
EndDeclareModule

Module _Win32
EndModule

DeclareModule Win32
  EnableExplicit
  
  UseModule SAL
  
  #RIDEV_INPUTSINK=$00000100
  #RID_INPUT=$10000003
  #RIM_TYPEMOUSE=0
  #RI_MOUSE_WHEEL=$0400
  #RIM_TYPEHID=2
  #RIM_TYPEKEYBOARD=1
  #SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE=$2
  #FILE_ATTRIBUTE_REPARSE_POINT=$400
  #FACILITY_WIN32=7
  
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
  CompilerElse
  Structure _PB_Win32_RAWHID Extends RAWHID
  EndStructure
  Macro RAWHID
    Win32::_PB_Win32_RAWHID
  EndMacro
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
  CompilerElse
  Structure _PB_Win32_RAWKEYBOARD Extends RAWKEYBOARD
  EndStructure
  Macro RAWKEYBOARD
    Win32::_PB_Win32_RAWKEYBOARD
  EndMacro
  CompilerEndIf
  
  CompilerIf Not Defined(USEBUTTON,#PB_Structure)
  Structure USEBUTTON Align #PB_Structure_AlignC
    usFlags.w
    usData.w
  EndStructure
  CompilerElse
  Structure _PB_Win32_USEBUTTON Extends USEBUTTON
  EndStructure
  Macro USEBUTTON
    Win32::_PB_Win32_USEBUTTON
  EndMacro
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
    Win32::_PB_Win32_RAWMOUSE
  EndMacro
  CompilerEndIf
  
  CompilerIf Not Defined(RAWINPUTHEADER,#PB_Structure)
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
    Win32::_PB_Win32_RAWINPUTHEADER
  EndMacro
  CompilerEndIf
  
  CompilerIf Not Defined(RAWINPUT,#PB_Structure)
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
    Win32::_PB_Win32_RAWINPUT
  EndMacro
  CompilerEndIf
  
  CompilerIf Not Defined(RAWINPUTDEVICE,#PB_Structure)
  Structure RAWINPUTDEVICE Align #PB_Structure_AlignC
    usUsagePage.w
    usUsage.w
    dwFlags.l
    hwndTarget.i
  EndStructure
  CompilerElse
  Structure _PB_Win32_RAWINPUTDEVICE Extends RAWINPUTDEVICE
  EndStructure
  Macro RAWINPUTDEVICE
    Win32::_PB_Win32_RAWINPUTDEVICE
  EndMacro
  CompilerEndIf
  
  CompilerIf Not Defined(MSLLHOOKSTRUCT,#PB_Structure)
  Structure MSLLHOOKSTRUCT Align #PB_Structure_AlignC
    pt.POINT
    mouseData.l
    flags.l
    time.l
    dwExtraInfo.i
  EndStructure
  CompilerElse
  Structure _PB_Win32_MSLLHOOKSTRUCT Extends MSLLHOOKSTRUCT
  EndStructure
  Macro MSLLHOOKSTRUCT
    Win32::_PB_Win32_MSLLHOOKSTRUCT
  EndMacro
  CompilerEndIf
  
  Macro LOBYTE(Word)
    (Word&$FF)
  EndMacro
  
  Macro HIBYTE(Word)
    ((Word>>8)&$FF)
  EndMacro
  
  Macro LOWORD(Long)
    (Long&$FFFF)
  EndMacro
  
  Macro HIWORD(Long)
    ((Long>>16)&$FFFF)
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
  
  Macro DWORD_REFERENCE
    Type::INT_32_REFERENCE
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
  
  Macro FARPROC
    Type::UINT_32_64
  EndMacro
  
  Macro SIZE_T
    Type::UINT_32_64
  EndMacro
  
  Macro SIZE_T_REFERENCE
    Type::INT_32_64_REFERENCE
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
  
  Macro MAKE_HRESULT(sev, fac, code)
    ((sev<<31)|(fac<<16)|(code))
  EndMacro
  
  Macro MODULEENTRY32
    MODULEENTRY32
  EndMacro
EndDeclareModule

Module Win32
EndModule

DeclareModule _Win32_KERNEL32
  EnableExplicit
  
  UseModule Assertion
  UseModule PureBasic
  UseModule SAL
  
  Define l.PB_LIBRARY_ID=OpenLibrary(#PB_Any,"kernel32.dll")
  ASSERT(l<>0)
  
  CompilerIf Not #PB_Compiler_Unicode
  Define *FormatMessage=GetFunction(l,"FormatMessageA")
  CompilerElse
  Define *FormatMessage=GetFunction(l,"FormatMessageW")
  CompilerEndIf
  ASSERT(*FormatMessage<>0)
  
  Define *GetThreadId=GetFunction(l,"GetThreadId")
  ASSERT(*GetThreadId<>0)
  
  Define *OpenThread=GetFunction(l,"OpenThread")
  ASSERT(*OpenThread<>0)
  
  Define *GetProcAddress=GetFunction(l,"GetProcAddress")
  ASSERT(*GetProcAddress<>0)
  
  Define *CreateToolhelp32Snapshot=GetFunction(l,"CreateToolhelp32Snapshot")
  ASSERT(*CreateToolhelp32Snapshot<>0)
  
  Define *Module32First=GetFunction(l,"Module32First")
  ASSERT(*Module32First<>0)
  
  Define *Module32Next=GetFunction(l,"Module32Next")
  ASSERT(*Module32Next<>0)
  
  Define *GetLastError=GetFunction(l,"GetLastError")
  ASSERT(*GetLastError<>0)
  
  Define *GetExitCodeProcess=GetFunction(l,"GetExitCodeProcess")
  ASSERT(*GetExitCodeProcess<>0)
  
  Define *CloseHandle=GetFunction(l,"CloseHandle")
  ASSERT(*CloseHandle<>0)
  
  Define *ReadProcessMemory=GetFunction(l,"ReadProcessMemory")
  ASSERT(*ReadProcessMemory<>0)
  
  Define *WriteProcessMemory=GetFunction(l,"WriteProcessMemory")
  ASSERT(*WriteProcessMemory<>0)
  
  Prototype.Win32::HANDLE _KERNEL32DLL_OpenThread(_IN desiredAccess.Win32::DWORD, _IN inheritHandle.Win32::BOOL, _In threadId.Win32::DWORD)
  Prototype.Win32::DWORD _KERNEL32DLL_GetThreadId(_IN threadId.Win32::HANDLE)
  Prototype.Win32::FARPROC _KERNEL32DLL_GetProcAddress(_IN hModule.Win32::HANDLE, lpProcName.p-ascii)
  Prototype.Win32::HANDLE _KERNEL32DLL_CreateToolhelp32Snapshot(_IN flags.Win32::DWORD, _IN processId.Win32::DWORD)
  Prototype.Win32::BOOL _KERNEL32DLL_Module32First(_IN hSnapshot.Win32::HANDLE, _OUT *moduleEntry.Win32::MODULEENTRY32)
  Prototype.Win32::BOOL _KERNEL32DLL_Module32Next(_IN hSnapshot.Win32::HANDLE, _OUT *moduleEntry.Win32::MODULEENTRY32)
  Prototype.Win32::DWORD _KERNEL32DLL_GetLastError()
  Prototype.Win32::BOOL _KERNEL32DLL_GetExitCodeProcess(_IN hSnapshot.Win32::HANDLE, _OUT *exitCode.Win32::DWORD_REFERENCE)
  Prototype.Win32::BOOL _KERNEL32DLL_CloseHandle(_IN hObject.Win32::HANDLE)
  Prototype.Win32::BOOL _KERNEL32DLL_ReadProcessMemory(_IN hProcess.Win32::HANDLE, _IN *baseAddress, _OUT *buffer, _IN size.Win32::SIZE_T, _OUT *numberOfBytesRead.Win32::SIZE_T_REFERENCE)
  Prototype.Win32::BOOL _KERNEL32DLL_WriteProcessMemory(_IN hProcess.Win32::HANDLE, _IN *baseAddress, _IN *buffer, _IN size.Win32::SIZE_T, _OUT *numberOfBytesWritten.Win32::SIZE_T_REFERENCE)
EndDeclareModule

Module _Win32_KERNEL32
EndModule

DeclareModule Win32_KERNEL32
  EnableExplicit
  
  UseModule Assertion
  UseModule SAL
  UseModule Type
  
  Global OpenThread._Win32_KERNEL32::_KERNEL32DLL_OpenThread=_Win32_KERNEL32::*OpenThread
  Global GetThreadId._Win32_KERNEL32::_KERNEL32DLL_GetThreadId=_Win32_KERNEL32::*GetThreadId
  Global GetProcAddress._Win32_KERNEL32::_KERNEL32DLL_GetProcAddress=_Win32_KERNEL32::*GetProcAddress
  Global CreateToolhelp32Snapshot._Win32_KERNEL32::_KERNEL32DLL_CreateToolhelp32Snapshot=_Win32_KERNEL32::*CreateToolhelp32Snapshot
  Global Module32First._Win32_KERNEL32::_KERNEL32DLL_Module32First=_Win32_KERNEL32::*Module32First
  Global Module32Next._Win32_KERNEL32::_KERNEL32DLL_Module32Next=_Win32_KERNEL32::*Module32Next
  Global GetLastError._Win32_KERNEL32::_KERNEL32DLL_GetLastError=_Win32_KERNEL32::*GetLastError
  Global GetExitCodeProcess._Win32_KERNEL32::_KERNEL32DLL_GetExitCodeProcess=_Win32_KERNEL32::*GetExitCodeProcess
  Global CloseHandle._Win32_KERNEL32::_KERNEL32DLL_CloseHandle=_Win32_KERNEL32::*CloseHandle
  Global ReadProcessMemory._Win32_KERNEL32::_KERNEL32DLL_ReadProcessMemory=_Win32_KERNEL32::*ReadProcessMemory
  Global WriteProcessMemory._Win32_KERNEL32::_KERNEL32DLL_WriteProcessMemory=_Win32_KERNEL32::*WriteProcessMemory
  
  Declare.s FormatMessage(_IN messageId.Win32::DWORD, _IN flags.Win32::DWORD=#FORMAT_MESSAGE_FROM_SYSTEM, _IN_OPT *source=0, _IN LanguageId.Win32::DWORD=0, _IN_OPT *arguments=0)
EndDeclareModule

Module Win32_KERNEL32
  EnableExplicit
  
  UseModule Assertion
  UseModule SAL
  UseModule Type
  
  Procedure.s FormatMessage(_IN messageId.Win32::DWORD, _IN flags.Win32::DWORD=#FORMAT_MESSAGE_FROM_SYSTEM, _IN_OPT *source=0, _IN languageId.Win32::DWORD=0, _IN_OPT *arguments=0)
    Protected buffer.s{4096}
    Protected charsWritten.Win32::DWORD
    
    charsWritten=FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM,0,messageId,0,@buffer.s,4096-1,0)
    
    If charsWritten
      ProcedureReturn Left(buffer.s,charsWritten-2)
    EndIf
    
    ProcedureReturn ""
  EndProcedure
EndModule

DeclareModule _Win32_DWMAPI
  EnableExplicit
  
  UseModule Assertion
  UseModule PureBasic
  UseModule SAL
  UseModule Type
  
  Structure DWM_THUMBNAIL_PROPERTIES
    dwFlags.l
    rcDestination.RECT
    rcSource.RECT
    opacity.b
    fVisible.b
    padding.c[3]
    fSourceClientAreaOnly.b
  EndStructure
  
  Macro DWMAPI
    Win32::HRESULT
  EndMacro
  
  Macro HTHUMBNAIL
    Win32::HANDLE
  EndMacro
  
  Macro HTHUMBNAIL_POINTER
    Type::POINTER_TYPE
  EndMacro
  
  Define l.PB_LIBRARY_ID=OpenLibrary(#PB_Any,"dwmapi.dll")
  ASSERT(l<>0)
  
  Define *DwmRegisterThumbnail=GetFunction(l,"DwmRegisterThumbnail")
  ASSERT(*DwmRegisterThumbnail<>0)
  
  Define *DwmUpdateThumbnailProperties=GetFunction(l,"DwmUpdateThumbnailProperties")
  ASSERT(*DwmUpdateThumbnailProperties<>0)
  
  Define *DwmUnregisterThumbnail=GetFunction(l,"DwmUnregisterThumbnail")
  ASSERT(*DwmUnregisterThumbnail<>0)
  
  Prototype.DWMAPI _DWMAPIDLL_DwmRegisterThumbnail(_IN hwndDestination.Win32::HWND, _IN hwndSource.Win32::HWND, _OUT *hThumbnailId.HTHUMBNAIL_POINTER)
  Prototype.DWMAPI _DWMAPIDLL_DwmUpdateThumbnailProperties(_IN hThumbnailId.HTHUMBNAIL, _IN *tnProperties.DWM_THUMBNAIL_PROPERTIES)
  Prototype.DWMAPI _DWMAPIDLL_DwmUnregisterThumbnail(_IN hThumbnailId.HTHUMBNAIL)
EndDeclareModule

Module _Win32_DWMAPI
EndModule

DeclareModule Win32_DWMAPI
  EnableExplicit
  
  Global DwmRegisterThumbnail._Win32_DWMAPI::_DWMAPIDLL_DwmRegisterThumbnail=_Win32_DWMAPI::*DwmRegisterThumbnail
  Global DwmUpdateThumbnailProperties._Win32_DWMAPI::_DWMAPIDLL_DwmUpdateThumbnailProperties=_Win32_DWMAPI::*DwmUpdateThumbnailProperties
  Global DwmUnregisterThumbnail._Win32_DWMAPI::_DWMAPIDLL_DwmUnregisterThumbnail=_Win32_DWMAPI::*DwmUnregisterThumbnail
EndDeclareModule

Module Win32_DWMAPI
  EnableExplicit
  
  UseModule Assertion
  UseModule SAL
  UseModule Type
  
  Structure DWM_THUMBNAIL_PROPERTIES Extends _Win32_DWMAPI::DWM_THUMBNAIL_PROPERTIES
  EndStructure
  
  Macro DWMAPI
    _Win32_DWMAPI::DWMAPI
  EndMacro
  
  Macro HTHUMBNAIL
    _Win32_DWMAPI::HTHUMBNAIL
  EndMacro
  
  Macro HTHUMBNAIL_POINTER
    _Win32_DWMAPI::HTHUMBNAIL_POINTER
  EndMacro
EndModule

DeclareModule _Win32_USER32
  UseModule Assertion
  UseModule PureBasic
  UseModule SAL
  UseModule Type
  
  Define l.PB_LIBRARY_ID=OpenLibrary(#PB_Any,"user32.dll")
  ASSERT(l<>0)
  
  *GetRawInputData=GetFunction(l,"GetRawInputData")
  ASSERT(*GetRawInputData<>0)
  
  *RegisterRawInputDevices=GetFunction(l,"RegisterRawInputDevices")
  ASSERT(*RegisterRawInputDevices<>0)
  
  Prototype.Win32::UINT _USER32DLL_GetRawInputData(_IN rawInput.Win32::HRAWINPUT, _IN command.Type::UINT_32_64, _OUT_OPT *pData, _IN_OUT *pSize.Type::UINT_32_64_REFERENCE, _IN sizeHeader.Win32::UINT)
  Prototype.Win32::BOOL _USER32DLL_RegisterRawInputDevices(_IN *pRawInputDevices.Win32::PCRAWINPUTDEVICE, _IN numDevices.Win32::UINT, _IN size.Win32::UINT)
EndDeclareModule

Module _Win32_USER32
EndModule

DeclareModule Win32_USER32
  EnableExplicit
  
  UseModule Assertion
  UseModule SAL
  UseModule Type
  
  Global GetRawInputData._Win32_USER32::_USER32DLL_GetRawInputData=_Win32_USER32::*GetRawInputData
  Global RegisterRawInputDevices._Win32_USER32::_USER32DLL_RegisterRawInputDevices=_Win32_USER32::*RegisterRawInputDevices
EndDeclareModule

Module Win32_USER32
EndModule

; ###

CompilerIf #PB_Compiler_Unicode
Macro GetProcAddress_(hModule_, lpProcName_)
  Win32_KERNEL32::GetProcAddress(hModule_, lpProcName_)
EndMacro
CompilerEndIf

Macro FormatMessage_(messageId_, flags_, source_, languageId_, arguments_)
  Win32_KERNEL32::FormatMessage(messageId_, flags_, source_, languageId_, arguments_)
EndMacro

;/ Fixes an incorrect resident definition; implemented in 5.42
CompilerIf #PB_Compiler_Version<542
Macro RAWMOUSE
  Win32::RAWMOUSE
EndMacro
CompilerEndIf

;/ Fixes an incorrect resident definition; implemented in 5.42
CompilerIf #PB_Compiler_Version<542
Macro RAWINPUTHEADER
  Win32::RAWINPUTHEADER
EndMacro
CompilerEndIf

;/ Fixes an incorrect resident definition; implemented in 5.42
CompilerIf #PB_Compiler_Version<542
Macro RAWINPUT
  Win32::RAWINPUT
EndMacro
CompilerEndIf

DisableExplicit
