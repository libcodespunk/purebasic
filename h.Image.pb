;/ Enable variable protected mode
EnableExplicit

;/ Library function constants
#Image_Search_String=0
#Image_Search_Integer=1

#Image_Capture_Client=2
#Image_Capture_Type_PrintWindow=4
#Image_Capture_Type_BitBlit_A=8
#Image_Capture_Type_BitBlit_B=16

;/ Library error constants
Enumeration -1 Step -1
  #Error_LibImage_InvalidPath
  #Error_LibImage_UnknownSearchType
  #Error_LibImage_InvalidMemoryAddress
  #Error_LibImage_InvalidImageToSearch
  #Error_LibImage_InvalidImageToFind
  #Error_LibImage_InvalidSearchDimensions
  #Error_LibImage_SearchOutOfBounds
  ;#Error_LibImage_InvalidImageID
  #Error_LibImage_CaptureWindowFailed
  #Error_LibImage_InvalidRect
  #Error_LibImage_InvalidWindowHandle
  #Error_LibImage_InvalidImageID
EndEnumeration

;/ Missing library API constants
CompilerIf Defined(CAPTUREBLT, #PB_Constant)
CompilerElse
  #CAPTUREBLT=$40000000
CompilerEndIf

;/ Initialize library image decoders for LoadImage()
UseJPEGImageDecoder()
UseJPEG2000ImageDecoder()
UsePNGImageDecoder()
UseTIFFImageDecoder()
UseTGAImageDecoder()

Structure _Array
  i.l[0]
EndStructure

;/ Public image list structure 
Structure ImageList
  ImageID.i
  FileName.s
  Width.i
  Height.i
  FileSize.i
EndStructure

;/ Library global structure
Structure Glob_LibImage
  ErrorLibID.i ;/ Library error library ID
  Constructor.i ;/ Constructor flag that identifies whether important library data has been initialized
  ThreadSafeMutex.i ;/ ThreadSafe mutex
EndStructure

Module LibImage
  UseModule _DXDirectInput8
  
  UseModule Assertion
  UseModule SAL
  UseModule Type
  
  #ENUM_ERROR_OK=0
  
  Enumeration -1 Step -1
    #ENUM_ERROR_INVALID_PATH
    #ENUM_ERROR_UNKNOWN_SEARCH_TYPE
    #ENUM_ERROR_INVALID_MEMORY_ADDRESS
    #ENUM_ERROR_INVALIDI_MAGE_TO_SEARCH
    #ENUM_ERROR_INVALID_IMAGE_TO_FIND
    #ENUM_ERROR_INVALID_SEARCH_DIMENSIONS
    #ENUM_ERROR_SEARCH_OUTOF_BOUNDS
    #ENUM_ERROR_INVALID_IMAGE_ID
    #ENUM_ERROR_CAPTURE_WINDOW_FAILED
    #ENUM_ERROR_INVALID_RECT
    #ENUM_ERROR_INVALID_WINDOW_HANDLE
    #ENUM_ERROR_INVALID_IMAGE_ID
  EndEnumeration
EndModule

; #Error_LibImage_InvalidPath,@"The path specified is invalid")
; #Error_LibImage_UnknownSearchType,@"Unknown search type specified")
; #Error_LibImage_InvalidMemoryAddress,@"Invalid memory address")
; #Error_LibImage_InvalidImageToSearch,@"Invalid ImageToSearch")
; #Error_LibImage_InvalidImageToFind,@"Invalid ImageToFind")
; #Error_LibImage_InvalidSearchDimensions,@"The search dimensions are invalid")
; #Error_LibImage_SearchOutOfBounds,@"Search out of bounds")
; #Error_LibImage_InvalidImageID,"Invalid ImageID")
; #Error_LibImage_CaptureWindowFailed,@"Failed to capture window image")
; #Error_LibImage_InvalidRect,@"Invalid or unsupported dimensions in rect structure.")
; #Error_LibImage_InvalidWindowHandle,@"Invalid window handle.")
; #Error_LibImage_InvalidImageID,@"Invalid image ID.")

;/ Library global structure defined
Global Glob_LibImage.Glob_LibImage

;/ Disable variable protected mode
DisableExplicit

;/ ImageListFromPath example
; Define *ImageList.ImageList
; Result=List_Create(@*ImageList,SizeOf(ImageList))
; If Result
;   Debug "Error!"
;   ErrorLib_ResolveError($434241,@LastError.LastError,Result)
;   Debug LastError\ErrorString.s
;   End
; EndIf
; 
; ImageListFromPath(@*ImageList,"\\hp\d\~\AHK Scripts\EVE Online\Glyphs","bmp:gif:png")
; Debug "Items in list: "+Str(List_Count(@*ImageList))
; List_FirstElement(@*ImageList)
; If List_Count(@*ImageList)
;   Repeat
;     Debug *ImageList\FileName.s
;   Until Not List_Next(@*ImageList)
; Else
;   Debug "The list is empty."
; EndIf

;/ SearchImageList example
; Define *ImageList.ImageList
; Result=List_Create(@*ImageList,SizeOf(ImageList))
; If Result
;   Debug "Error!"
;   ErrorLib_ResolveError($434241,@LastError.LastError,Result)
;   Debug LastError\ErrorString.s
;   End
; EndIf
; 
; For i=1 To 20
;   List_Add(@*ImageList,1)
;   *ImageList\ImageID=i
;   *ImageList\FileName.s=Str(i)
; Next i
; 
; List_FirstElement(@*ImageList)
; For i=1 To 20
;   List_FirstElement(@*ImageList)
;   If SearchImageList(@*ImageList,i,OffsetOf(ImageList\ImageID),#Image_Search_Integer,@Match)=0
;     If Match
;       Debug *ImageList\ImageID
;     EndIf
;   Else
;     Debug "Error!"
;   EndIf
;   
;   String.s=Str(i)
;   If SearchImageList(@*ImageList,@String.s,OffsetOf(ImageList\FileName.s),#Image_Search_String,@Match)=0
;     If Match
;       Debug *ImageList\FileName.s
;     EndIf
;   Else
;     Debug "Error!"
;   EndIf
; Next i

;/ CaptureImageFromWindow example
; XIncludeFile("inc.SplashImage.pb")
; Define Rect.RECT
; GetWindowRect_(FindWindow_(0,"Untitled - Notepad"),@Rect)
; Result=CaptureImageFromWindow(FindWindow_(0,"Untitled - Notepad"),@ImageID,#Image_Capture_Window,0,0,Rect\Right-Rect\Left,Rect\Bottom-Rect\Top)
; If ImageID
;   DisplaySplash(ImageID)
;   Delay(1000)
; Else
;   Debug "Couldn't find the window"
;   If Result
;     ErrorLib_ResolveError($434241,@LastError.LastError,Result)
;     Debug LastError\ErrorString.s
;   EndIf
; EndIf
; End


;/ SearchImage example
; XIncludeFile("inc.SplashImage.pb")
; NewList Location.POINT()
; 
; SplashImage=LoadImage(#PB_Any,"examples\ImageToSearch.bmp")
; If Not SplashImage
;   Debug "Couldn't find the example ImageToSearch"
;   End
; EndIf
; ImageToFind=LoadImage(#PB_Any,"examples\ImageToFind.bmp")
; If Not ImageToFind
;   Debug "Couldn't find the example ImageToFind"
;   End
; EndIf
; 
; DisplaySplash(SplashImage,40,50)
; CaptureImageFromWindow(GetDesktopWindow_(),@ImageToSearch,#Image_Capture_Client)
; 
; Start=ElapsedMilliseconds()
; SearchImage(ImageToSearch,ImageToFind,0,0,0,0,@Match,Location.POINT(),1,20,RGB(0,0,128))
; If Match
;   MatchString.s="Match!"
; Else
;   MatchString.s="No match!"
; EndIf
; Debug Str(ElapsedMilliseconds()-Start)+" ("+MatchString.s+")"
; If Match
;   Debug "x/y "+Str(Location()\x)+" "+Str(Location()\y)
; EndIf
; End

; XIncludeFile("inc.SplashImage.pb")
; NewList Location.POINT()
; 
; SplashImage=LoadImage(#PB_Any,"examples\ImageToSearch_black.bmp")
; If Not SplashImage
;   Debug "Couldn't find the example ImageToSearch"
;   End
; EndIf
; ImageToFind=LoadImage(#PB_Any,"examples\ImageToFind_black.bmp")
; If Not ImageToFind
;   Debug "Couldn't find the example ImageToFind"
;   End
; EndIf
; 
; DisplaySplash(SplashImage,0,0)
; CaptureImageFromWindow(GetDesktopWindow_(),@ImageToSearch,#Image_Capture_Client,0,0,ImageWidth(SplashImage)+20,ImageHeight(SplashImage)+20)
; 
; Start=ElapsedMilliseconds()
; SearchImage(ImageToSearch,ImageToFind,0,0,0,0,@Match,Location.POINT(),1,60,RGB(60,140,35))
; If Match
;   SetCursorPos_(Location()\x,Location()\y)
;   MatchString.s="Match!"
; Else
;   MatchString.s="No match!"
; EndIf
; Debug Str(ElapsedMilliseconds()-Start)+" ("+MatchString.s+")"
; If Match
;   Debug "x/y "+Str(Location()\x)+" "+Str(Location()\y)
; EndIf
; Delay(4000)
; End
