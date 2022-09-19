;/ Enable variable protected mode
EnableExplicit

;/******************************************************************************
;/* Searches a linked list of structured type ImageList for a matching string or
;/* integer. If a match is found the variable passed by-address as *Match will
;/* be set to #True, the matching element will be the current element of the
;/* list, and the return value of the function will be #False. This function
;/* does not report an error if the address passed for ToFind is null and the 
;/* search type is for a string. It will instead return early with a match
;/* result of #False.
;/* 
;/* @param ListResult - The linked list of structured type ImageList to
;/*        return the result of the list to be sorted. If a match is found then
;/*        the matching element will be the current element.
;/* 
;/* @param ToFind - An integer to find or an address to a null terminated string
;/* 
;/* @param OffsetOf - The offset of the list's structure to search.
;/* 
;/* @param SearchType - The search type.
;/*           Possible values are:
;/*             #Image_Search_Integer
;/*             #Image_Search_String
;/* 
;/* @param *Match - The match flag passed by-adress identifies the result of the
;/*         list search. If the value is #True then a match was found. Otherwise
;/*         the result is #False.
;/* 
;/* @rparam If the function succeeds, the return value is the #False. Otherwise 
;/*         the result is true. Pass this value to ErrorLib_IntegerDeMuxResult
;/*         and resolve the error using ErrorLib_ResolveError for additional
;/*         information.
;/* 
;/* @rparam success=false
;/* @errorh errorlibrary=true
;/*****************************************************************************/
Procedure SearchImageList(*ImageListResult.ImageList, ToFind.i, OffsetOf.i, SearchType.i, *Match)
  ;/ Initialize library constructor when the first public function is called
  If Not Private_Image_ConstructorInitialized()
    Private_Image_LockLibraryMutex()
    Private_Image_Constructor()
    Private_Image_UnLockLibraryMutex()
  EndIf
  
  ;/ Declare variables
  Static ReturnString.s
  Protected Integer
  Protected *CurrentElement.ImageList
  
  If Not *Match
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidMemoryAddress)
  EndIf
  
  If *ImageListResult
    *CurrentElement=PeekI(*ImageListResult)
  Else
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidPath)
  EndIf
  
  ;/ Set the default match value to false (no match)
  PokeI(*Match,#False)
  
  ;/ Reset the list to the first element
  List_FirstElement(@*CurrentElement)

  ;/ Loop through each element in the list and handle the current search type appropriately
  If List_Count(@*CurrentElement)
    Repeat
      If SearchType=#Image_Search_Integer
        Integer=PeekI(*CurrentElement+OffsetOf)
        If Integer=ToFind
          PokeI(*Match,#True) ;/ Set the match flag to true
          Break
        EndIf
      ElseIf SearchType=#Image_Search_String
        If Not ToFind
          ProcedureReturn #False ;/ Return early if the string to find is a null pointer
        EndIf
        Integer=PeekI(*CurrentElement+OffsetOf)
        If Integer
          If PeekS(ToFind)=PeekS(Integer)
            PokeI(*Match,#True) ;/ Set the match flag to true
            Break
          EndIf
        EndIf
      Else
        ProcedureReturn Image_SetError(#Error_LibImage_UnknownSearchType)
      EndIf
    Until Not List_Next(@*CurrentElement)
  EndIf
  
  ;/ Set the current element as the match element
  PokeI(*ImageListResult,*CurrentElement)
  
  ;/ No error
  ProcedureReturn #False
EndProcedure

;/******************************************************************************
;/* This function will parse a directory for all images of types jpg, bmp, gif,
;/* png, tiff, or tga. The extension mask parameter will identify the extension
;/* types to add to the list. Each extension (without the preceding period) is
;/* separated by colon ':'. The linked list ImageListResult will return a list
;/* of all images loaded as the result.
;/* 
;/* @param ImageListResult - The linked list of structured type ImageList to
;/*        return the result of the directory to be parsed. The list will be
;/*        emptied before new elements are added to it and will also be reset
;/*        to the first element before the function returns.
;/* 
;/* @param Directory.s - The directory to be parsed.
;/* 
;/* @param ExtensionMask.s - The valid extensions to import. Each extension is
;/*        (excluding the preceding period) is separated by a colon ':'. An
;/*        empty string will accept all supported extensions.
;/* 
;/* @rparam If the function succeeds, the return value is the #False. Otherwise 
;/*         the result is true. Pass this value to ErrorLib_IntegerDeMuxResult
;/*         and resolve the error using ErrorLib_ResolveError for additional
;/*         information.
;/* 
;/* @rparam success=false
;/* @errorh errorlibrary=true
;/*****************************************************************************/
Procedure ImageListFromPath(*ImageListResult.ImageList, Directory.s, ExtensionMask.s="")
  ;/ Initialize library constructor when the first public function is called
  If Not Private_Image_ConstructorInitialized()
    Private_Image_LockLibraryMutex()
    Private_Image_Constructor()
    Private_Image_UnLockLibraryMutex()
  EndIf
  
  ;/ Declare variables
  Protected i
  Protected PatternCount
  Protected Match
  Protected PathID
  Protected EntryType
  Protected EntryName.s
  Protected Extension.s
  Protected ImageID
  Protected *CurrentElement.ImageList
  
  If Not Right(Directory.s,1)="\"
    Directory.s+"\"
  EndIf
  
  If Not FileSize(Directory.s)=-2
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidPath)
  EndIf
  
  If *ImageListResult
    *CurrentElement=PeekI(*ImageListResult)
  Else
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidPath)
  EndIf
  
  ;/ Empty linked list and free memory associated with its elements
  List_Empty(@*CurrentElement)
  
  If ExtensionMask.s=""
    ;/ A PatternCount of -1 means all patterns are accepted
    PatternCount=-1
  Else
    ;/ Trim any erroneous information from the pattern before parsing
    While Right(ExtensionMask.s,1)=":"
      ExtensionMask.s=Left(ExtensionMask.s,Len(ExtensionMask.s)-1)
    Wend
    
    ;/ Identify the number of extension masks in the list and allocate an array of that size
    PatternCount=CountString(ExtensionMask.s,":")
    Dim PatternList.s(PatternCount)
    
    ;/ Set each element of the array to one of the unique extension masks
    For i=0 To PatternCount
      PatternList.s(i)=StringField(ExtensionMask.s,i+1,":")
    Next i
  EndIf
  
  ;/ Loop through each entry in the directory
  PathID=ExamineDirectory(#PB_Any,Directory.s,"")
  If PathID
    While NextDirectoryEntry(PathID)
      EntryType=DirectoryEntryType(PathID)
      EntryName.s=DirectoryEntryName(PathID)
      Select EntryType
        ;/ If the entry type is a file
        Case #PB_DirectoryEntry_File
          Extension.s=LCase(GetExtensionPart(EntryName.s))
          ;/ Loop through each item in the pattern list. If the..
          For i=0 To PatternCount
            If PatternList.s(i)=Extension.s
              Match=1
              Break ;/ Exit the loop
            EndIf
          Next i
          If Match Or PatternCount=-1
            Match=0
            ImageID=LoadImage(#PB_Any,Directory.s+EntryName.s)
            If ImageID
              ;/ Add element to image list
              List_Add(@*CurrentElement,1)
              *CurrentElement\FileName.s=EntryName.s
              *CurrentElement\ImageID=ImageID
              *CurrentElement\Width.i=ImageWidth(ImageID)
              *CurrentElement\Height.i=ImageHeight(ImageID)
              *CurrentElement\FileSize.i=FileSize(Directory.s+EntryName.s)
            EndIf
          EndIf
      EndSelect
    Wend
    FinishDirectory(PathID)
  EndIf
  
  ;/ Reset the list to the first element
  List_FirstElement(@*CurrentElement)
  PokeI(*ImageListResult,*CurrentElement)
  
  ProcedureReturn #False ;/ Success
EndProcedure

; Procedure ImagePointByIndex(ImageID, Index)
;   
;   StartDrawing(Output)
;   Point(
;   StopDrawing()
;   
;   ProcedureReturn RGB
; EndProcedure

Procedure CopyImageToArray(ImageID, *Array._Array)
  ;/ Initialize library constructor when the first public function is called
  If Not Private_Image_ConstructorInitialized()
    Private_Image_LockLibraryMutex()
    Private_Image_Constructor()
    Private_Image_UnLockLibraryMutex()
  EndIf
  
  ;/ Declare variables
  Protected Width
  Protected Height
  Protected *SourceBlock
  Protected bmi.BITMAPINFO
  Protected Output
  Protected hDC
  Protected *SourcePixel.LONG
  Protected i
  Protected R, G, B
  
  If Not IsImage(ImageID)
    ProcedureReturn 0
  EndIf
  Width=ImageWidth(ImageID)
  Height=ImageHeight(ImageID)
  *SourceBlock=AllocateMemory(Width*Height*SizeOf(Long))
  bmi.BITMAPINFO
  bmi\bmiHeader\biSize=SizeOf(BITMAPINFOHEADER)
  bmi\bmiHeader\biWidth=Width
  bmi\bmiHeader\biHeight=Height
  bmi\bmiHeader\biPlanes=1
  bmi\bmiHeader\biBitCount=32
  bmi\bmiHeader\biCompression=#BI_RGB
  Output=ImageOutput(ImageID)
  If Not Output
    ProcedureReturn -1
  EndIf
  hDC=StartDrawing(Output)
  
  ; Copy source image to API bitmap structure
  GetDIBits_(hDC,ImageID(ImageID),0,Height,*SourceBlock,bmi,#DIB_RGB_COLORS)    
  
  *SourcePixel=*SourceBlock
  
  For i=0 To (Width*Height)-1
    R=*SourcePixel\l&$FF
    G=*SourcePixel\l>>8&$FF
    B=*SourcePixel\l>>16&$FF

  ;   *SourcePixel\l=R|G<<8|B<<16
    *Array\i[(Width*Height)-(((i/Width)*Width)+Width)+(i%Width)]=RGB(B,G,R)
    *SourcePixel+SizeOf(LONG)
  Next
  
  ; Copy API bitmap structure back to image ID
  SetDIBits_(hDC,ImageID(ImageID),0,Height,*SourceBlock,bmi,#DIB_RGB_COLORS)
  FreeMemory(*SourceBlock)
  StopDrawing()
  
  ProcedureReturn 1
EndProcedure

Procedure CopyImageFromArray(*ArrayResult._Array, ImageID)
  ;/ Initialize library constructor when the first public function is called
  If Not Private_Image_ConstructorInitialized()
    Private_Image_LockLibraryMutex()
    Private_Image_Constructor()
    Private_Image_UnLockLibraryMutex()
  EndIf
  
  ;/ Declare variables
  Protected Width
  Protected Height
  Protected SourceBlock
  Protected bmi.BITMAPINFO
  Protected Output
  Protected hDC
  Protected *SourcePixel.LONG
  Protected i
  Protected Color
  
  If Not IsImage(ImageID)
    ProcedureReturn 0
  EndIf
  
  Width=ImageWidth(ImageID)
  Height=ImageHeight(ImageID)
  SourceBlock=AllocateMemory(Width*Height*SizeOf(LONG))
  bmi\bmiHeader\biSize=SizeOf(BITMAPINFOHEADER)
  bmi\bmiHeader\biWidth=Width
  bmi\bmiHeader\biHeight=Height
  bmi\bmiHeader\biPlanes=1
  bmi\bmiHeader\biBitCount=32
  bmi\bmiHeader\biCompression=#BI_RGB
  Output=ImageOutput(ImageID)
  
  If Not Output
    ProcedureReturn -1
  EndIf
  
  hDC=StartDrawing(Output)
  
  ; Copy source image to API bitmap structure
  GetDIBits_(hDC,ImageID(ImageID),0,Height,SourceBlock,bmi,#DIB_RGB_COLORS)    
  
  *SourcePixel.LONG=SourceBlock
  
  For i=0 To (Width*Height)-1
    Color=*ArrayResult\i[(Width*Height)-(((i/Width)*Width)+Width)+(i%Width)]
    *SourcePixel\l=Blue(Color)|Green(Color)<<8|Red(Color)<<16
    *SourcePixel+SizeOf(LONG)
  Next
  
  ;/ Copy API bitmap structure back to image ID
  SetDIBits_(hDC,ImageID(ImageID),0,Height,SourceBlock,bmi,#DIB_RGB_COLORS)
  FreeMemory(SourceBlock)
  StopDrawing()
  
  ProcedureReturn 1
EndProcedure

; Procedure GetLocalArrayOffset(ArrayWidth, ArrayIndex, LocalWidth, LocalIndex)
;    ProcedureReturn ArrayIndex+((LocalIndex/LocalWidth)*ArrayWidth)+(LocalIndex%LocalWidth)
; EndProcedure

Procedure SearchImage(ImageToSearch, ImageToFind, x, y, Width, Height, *MatchCount, *__Out_List_Location.Point=0, MaxCount=0, Variation=0, ColorKey=16777216, *CacheImage.Integer=0, *CacheSearch.Integer=0)
  ;/ Initialize library constructor when the first public function is called
  If Not Private_Image_ConstructorInitialized()
    Private_Image_LockLibraryMutex()
    Private_Image_Constructor()
    Private_Image_UnLockLibraryMutex()
  EndIf
  
  ;/ Declare variables
  Protected ToSearchResolution
  Protected ToFindWidth
  Protected ToFindHeight
  Protected ToFindResolution
  Protected MaxLocalOffset
  Protected i, n
  Protected PixelMatch
  Protected Block
  Protected Match
  Protected MatchCount
  Protected RGBSearchBlock
  Protected RSearchBlock
  Protected GSearchBlock
  Protected BSearchBlock
  Protected *ToSearchBlock._Array
  Protected *ToFindBlock._Array
  Protected *OffsetMap._Array
  Protected *List_Location.Point
  
  ;/ Clear location list
  If *__Out_List_Location And List_Count(*__Out_List_Location)
    List_Empty(*__Out_List_Location)
  EndIf
  
  ;/ If either of the image IDs passed is not an image then return
;   If Not IsImage(ImageToSearch) And Not (*CacheImage And Not *CacheImage\i) ;/ Invalid ImageToSearch ID
;     ProcedureReturn Image_SetError(#Error_LibImage_InvalidImageToSearch)
;   EndIf
  If Not IsImage(ImageToFind) ;/ Invalid ImageToFind ID
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidImageToFind)
  EndIf
  
  ;/ If no value is passed for the width or height then return
  If Width<0 Or Height<0
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidSearchDimensions)
  EndIf
  
  If Not ImageToSearch And *CacheImage
    ImageToSearch=*CacheImage\i
  Else
    If *CacheImage
      *CacheImage\i=ImageToSearch
    EndIf
  EndIf
  
  ;/ If 0 is passed for the width or height then use the dimensions of the ImageToSearch by default
  If Width=0
    Width=ImageWidth(ImageToSearch)
  EndIf
  If Height=0
    Height=ImageHeight(ImageToSearch)
  EndIf
  
  ;/ If the search area is not within the bounds of the ToSearch image then return
  If x+Width>ImageWidth(ImageToSearch) Or x<0 Or y+Height>ImageHeight(ImageToSearch) Or y<0
    ProcedureReturn Image_SetError(#Error_LibImage_SearchOutOfBounds)
  EndIf
  
  ;/ Unless specified, MaxCount defaults to 1
  If Not MaxCount
    MaxCount=1
  EndIf
  
  If Not Width
    Width=ImageWidth(ImageToSearch)
  EndIf
  If Not Height
    Height=ImageHeight(ImageToSearch)
  EndIf
  ToSearchResolution=Width*Height
  ToFindWidth=ImageWidth(ImageToFind)
  ToFindHeight=ImageHeight(ImageToFind)
  ToFindResolution=ToFindWidth*ToFindHeight
  *ToFindBlock._Array=AllocateMemory(ToFindResolution*SizeOf(Long))
  *OffsetMap._Array=AllocateMemory(ToFindResolution*SizeOf(Long))
  
  ;/ Build offset map for calculating which pixel in the find array is located in the search array
  For i=0 To ToFindResolution-1
    *OffsetMap\i[i]=((i/ToFindWidth)*Width)+(i%ToFindWidth)
  Next i
  
  
  If Not *CacheSearch Or (*CacheSearch And Not *CacheSearch\i)
    *ToSearchBlock._Array=AllocateMemory(ToSearchResolution*SizeOf(Long))
    CopyImageToArray(ImageToSearch,*ToSearchBlock)
    
    If *CacheSearch
      *CacheSearch\i=*ToSearchBlock
    EndIf
  Else
    *ToSearchBlock=*CacheSearch\i
  EndIf
  
  CopyImageToArray(ImageToFind,*ToFindBlock)
   
  For i=0 To ToSearchResolution-1
    ;/ Make sure the array doesn't go out of bounds
    If i+*OffsetMap\i[ToFindResolution-1]>ToSearchResolution
      Break
    EndIf
    For n=0 To ToFindResolution-1
      If *ToSearchBlock\i[i+*OffsetMap\i[n]]=*ToFindBlock\i[n]
        PixelMatch=1
      Else
        If Variation
          RGBSearchBlock=*ToSearchBlock\i[i+*OffsetMap\i[n]]
          RSearchBlock=Abs(Red(RGBSearchBlock)-Red(*ToFindBlock\i[n]))
          GSearchBlock=Abs(Green(RGBSearchBlock)-Green(*ToFindBlock\i[n]))
          BSearchBlock=Abs(Blue(RGBSearchBlock)-Blue(*ToFindBlock\i[n]))
          If RSearchBlock<=Variation And GSearchBlock<=Variation And BSearchBlock<=Variation
            PixelMatch=1
            RGBSearchBlock=*ToSearchBlock\i[i+*OffsetMap\i[n]]
            Continue
          EndIf
        EndIf
        If Not *ToFindBlock\i[n]=ColorKey
          PixelMatch=0
          Break
        EndIf
      EndIf
    Next n
    ;/ There is no match if the iteration through the image to find was cut short
    If Not n=ToFindResolution
      PixelMatch=0
    EndIf
    If PixelMatch
      MatchCount+1
      
      If *__Out_List_Location
        *List_Location=List_Add(*__Out_List_Location)
        *List_Location\x=i%Width
        *List_Location\y=i/Width
      EndIf
      
      ;/ Break if the maximum number of allowed matches has been met
      If MaxCount And MaxCount=MatchCount
        Break
      EndIf
    EndIf
  Next i
  
  ;/ Return match count result
  PokeI(*MatchCount,MatchCount)
  
  If Not *CacheSearch
    FreeMemory(*ToSearchBlock)
  EndIf
  
  FreeMemory(*ToFindBlock)
  FreeMemory(*OffsetMap)
  
  ProcedureReturn #Null ;/ Success
EndProcedure

#PW_RENDERFULLCONTENT=$00000002

Procedure CaptureImageFromWindow(hWnd, *__OutImageID.Integer=0, Flags.i=#Image_Capture_Type_BitBlit_B, StretchWidth=0, StretchHeight=0, StretchType=#STRETCH_DELETESCANS, *Rect.Rect=0)
  Protected hWndDC
  Protected hDC
  Protected ImageID
  Protected Rect.Rect
  Protected Top
  Protected Left
  Protected Right
  Protected Bottom
  Protected Width
  Protected Height
  Protected ProcessID
  
  Static *PrintWindow
  
  If Not *PrintWindow
    *PrintWindow=GetProcAddress_(GetModuleHandle_("User32.dll"),"PrintWindow")
  EndIf
  
  If Not *__OutImageID
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidMemoryAddress)
  EndIf
  
  If Not IsWindow_(hWnd)
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidWindowHandle)
  EndIf
  
  If *Rect
    Top=*Rect\top
    Left=*Rect\left
    Right=*Rect\right
    Bottom=*Rect\bottom
    
    Width=*Rect\right-*Rect\left
    Height=*Rect\bottom-*Rect\top
  Else
    If Flags&#Image_Capture_Client
      GetClientRect_(hWnd,@Rect)
      Top=Rect\top
      Left=Rect\left
      Right=Rect\right
      Bottom=Rect\bottom
      
      Width=Right-Left
      Height=Bottom-Top
    Else
      GetWindowRect_(hWnd,@Rect)
      Width=Rect\Right-Rect\Left
      Height=Rect\Bottom-Rect\Top
    EndIf
  EndIf
  
  If StretchWidth
    Width=StretchWidth
  EndIf
  
  If StretchHeight
    Height=StretchHeight
  EndIf
  
  If Width<=0 Or Height<=0
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidRect)
  EndIf
  
  If *__OutImageID\i=-1
    *__OutImageID\i=CreateImage(#PB_Any,Width,Height,24)
  Else
    If Not IsImage(*__OutImageID\i) Or (IsImage(*__OutImageID\i) And ImageWidth(*__OutImageID\i)<>Width) Or (IsImage(*__OutImageID\i) And ImageHeight(*__OutImageID\i)<>Height)
      CreateImage(*__OutImageID\i,Width,Height,24)
    EndIf
  EndIf
  ImageID=*__OutImageID\i
  
  If Not IsImage(ImageID)
    ProcedureReturn Image_SetError(#Error_LibImage_InvalidImageID)
  EndIf
  
  If Flags&#Image_Capture_Type_BitBlit_A
    If Flags&#Image_Capture_Client
      hWndDC=GetDCEx_(hWnd,0,#DCX_CACHE)
    Else
      hWndDC=GetDCEx_(hWnd,0,#DCX_CACHE|#DCX_WINDOW)
    EndIf
    
    hDC=StartDrawing(ImageOutput(ImageID))
    
    ;#STRETCH_HALFTONE
    If StretchWidth Or StretchHeight
      SetStretchBltMode_(hDC,StretchType)
      StretchBlt_(hDC,0,0,Width,Height,hWndDC,Left,Top,Right,Bottom,#SRCCOPY)
    Else
      BitBlt_(hDC,0,0,Width,Height,hWndDC,Left,Top,#SRCCOPY)
    EndIf
    
    ReleaseDC_(hWnd,hWndDC)
    
    StopDrawing()
  EndIf
  
  ;|#DCX_CLIPSIBLINGS|#DCX_LOCKWINDOWUPDATE|#DCX_PARENTCLIP|#DCX_CLIPCHILDREN
  
  If Flags&#Image_Capture_Type_BitBlit_B
    hWndDC=GetDCEx_(GetDesktopWindow_(),0,#DCX_CACHE)
    
    If Flags&#Image_Capture_Client
      ClientToScreen_(hWnd,@Rect)
    EndIf
    
    hDC=StartDrawing(ImageOutput(ImageID))
    
    If StretchWidth Or StretchHeight
      SetStretchBltMode_(hDC,StretchType)
      StretchBlt_(hDC,0,0,Width,Height,hWndDC,Rect\left+Left,Rect\top+Top,Rect\left+Right,Rect\top+Bottom,#SRCCOPY)
    Else
      BitBlt_(hDC,0,0,Width,Height,hWndDC,Rect\left+Left,Rect\top+Top,#SRCCOPY)
    EndIf
    
    ReleaseDC_(GetDesktopWindow_(),hWndDC)
    
    StopDrawing()
  EndIf
  
  If Flags&#Image_Capture_Type_PrintWindow And *PrintWindow
    Protected WindowImageId
    Protected hWindowDC
    
    If Flags&#Image_Capture_Client
      Protected ClientRect.RECT
      
      GetClientRect_(hWnd,@ClientRect)
      WindowImageId=CreateImage(#PB_Any,ClientRect\right,ClientRect\bottom,24)
    Else
      Protected WindowRect.RECT
      
      GetWindowRect_(hWnd,@WindowRect)
      WindowImageId=CreateImage(#PB_Any,WindowRect\right,WindowRect\bottom,24)
    EndIf
    
    hWindowDC=StartDrawing(ImageOutput(WindowImageId))
    
    If Flags&#Image_Capture_Client
      GetWindowThreadProcessId_(hWnd,@ProcessID)
      CallFunctionFast(*PrintWindow,hWnd,hWindowDC,#PW_CLIENTONLY)
    Else
      CallFunctionFast(*PrintWindow,hWnd,hWindowDC,0)
    EndIf
    
    StopDrawing()
    
    GrabImage(WindowImageId,ImageID,Rect\left+Left,Rect\top+Top,Width,Height)
    FreeImage(WindowImageId)
    
    If StretchWidth Or StretchHeight
      ResizeImage(ImageID,StretchWidth,StretchHeight,#PB_Image_Raw)
    EndIf
  EndIf
  
  ProcedureReturn #False
EndProcedure

;/ Disable variable protected mode
DisableExplicit
