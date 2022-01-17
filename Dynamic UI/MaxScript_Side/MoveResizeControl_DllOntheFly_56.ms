UiRun = True
(--BEGIN
gc()
clearlistener()
/*PEROPERTIES-------------------------------------------------------------------------*/
	--CurrentSelections
	Global IMirrorLineX,IMirrorLineY
	global _PrefixSuffixTextBoxA
	global _Prefix = ""
	global _Suffix = ""
	global _FormKeyboardLock = false
	global _Tooltipstr = ""
	global _StatusBarLabel,StatusBar
	Global AddButton()
	Global _CreditLabel
	CharacterName=""
	CurrentSelection = #()
	SelectedButtons=#()
	ButtonWrapperArray = #()

	CurrentSelectionTemp = #()
	ButtonWrapperArrayTemp = #()
	SelectedButtonsTemp = #()
	--Declare Ibutton Array For Store Every button creates at runtime
		ButtonArray = #()
	--Ibutton Array Index
		BtnArrayIndex =1
	--Ibutton Text Counter
		ICount = 1
	--Current Selected Button
		Current_Control
	--X Location Diff & Y Location Diff
	XDiff = #()
	YDiff = #()
	-- WorkType MoveResize / Move / Locked
	Worktype
 	--FormValues Fetch From Xml
		Panel_Char_BackImagePath=""
		FormX=800
		FormY=600
	--Move Or Resize Class Dll Path
-- 	/*HOME   */  DllPath = @"D:\Projects\009_CompanyFiles\Dynamic UI\DotNet_Side\UiFramworkLibrary\UiFramworkLibrary\bin\Debug\UiFramworkLibrary.dll"
	/*OFFICE */  DllPath = @"D:\Dynamic UI\2017_Dynamic UI_WindowsForm\DotNet_Side\UiFramworkLibrary\UiFramworkLibrary\bin\Debug\UiFramworkLibrary.dll"
-- 	/*Laptop */  DllPath = @"D:\Maxscript+Dotnet\Dynamic UI\DotNet_Side\UiFramworkLibrary\UiFramworkLibrary\bin\Debug\UiFramworkLibrary.dll"
	fn existFlie Fname = (getfiles Fname).count!=0
	MaxRoot = getDir #MaxRoot
	if existFlie (Maxroot + "\UiFramworkLibrary.dll") then 
	(
-- 		DllPath = Maxroot + "\UiFramworkLibrary.dll"
	)
	else
	 (
-- 		CurrentPath = sysinfo.currentdir
-- 		print CurrentPath 
-- 		if existFlie ("S:\Setup\Work\3dsmax_plugins\_scripts\Hamed\UIFramework" + "\UiFramworkLibrary.dll") then
-- 			(
-- 				copyfile "S:\Setup\Work\3dsmax_plugins\_scripts\Hamed\UIFramework\UiFramworkLibrary.dll" (Maxroot + "\UiFramworkLibrary.dll")
-- 				DllPath = Maxroot + "\UiFramworkLibrary.dll"
-- 			)
-- 			else if existFlie (CurrentPath + "\UiFramworkLibrary.dll") then
-- 			(
-- 				copyfile (CurrentPath + "\UiFramworkLibrary.dll") (Maxroot + "\UiFramworkLibrary.dll")
-- 				DllPath = Maxroot + "\UiFramworkLibrary.dll"
-- 			)
-- 			else if existFlie ("\UiFramworkLibrary.dll") then
-- 			(
-- 				copyfile ("\UiFramworkLibrary.dll") (Maxroot + "\UiFramworkLibrary.dll")
-- 				DllPath = Maxroot + "\UiFramworkLibrary.dll"
-- 			)
--  		 else
-- 			(
-- 				Messagebox "Please Copy The UiFramworkLibrary.dll To Your 3dsmax Root Folder"
-- 				exit
-- 			)
	 )
	/*-- Main Dotnet Form ----------------------------------------------------------------------------------------------------------*/
		--Form = (dotNetObject "System.Windows.Forms.Form") 
		--dn = dotnet.loadAssembly @"C:\Program Files\Autodesk\3ds Max 2014\MaxCustomControls.dll"
		Global Form = dotNetObject "MaxCustomControls.MaxForm"
		thePtr = DotNetObject "System.IntPtr" (windows.getMAXHWND())
	-- 	MaxV = maxVersion() 
		try (theHwnd = DotNetObject "MaxCustomControls.Win32HandleWrapper" thePtr)catch()
		
		--Keyboard Key Pressed Detection Con
		con = dotnetclass "system.windows.forms.control"

	/*-- Split Form -- Ribbons Contols FlowLayoutPanel --------------------------------------------*/
		SplitContainer = (dotNetObject "System.Windows.Forms.SplitContainer")
			SplitContainer.SplitterWidth = 3
			SplitContainer.SplitterDistance = 110
	/*-- Tools Buttons Container -- Ribbons Contols FlowLayoutPanel --------------------------------------------*/
		RibbonPanel = (dotNetObject "System.Windows.Forms.FlowLayoutPanel") --FlowLayoutPanel
		RibbonPanelBtnSizeX = 60
		RibbonPanelBtnSizeY = 60
		
		StatusBar = (dotNetObject "System.Windows.Forms.FlowLayoutPanel") --FlowLayoutPanel
	/*-- Buttons Property Panel Container -- FlowLayoutPanel --------------------------------------------*/
		--PropertiesPanel = (dotNetObject "System.Windows.Forms.Panel")
		--PropertyGrid = (dotnetobject "System.Windows.Forms.PropertyGrid" ---------------$$$
			
--formatProps PropertyGrid
/*METHODS----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------ Dotnet Wrappers ------------------------------------------------------------------------------------------------------------------------------------*/
	fn formatProps sender option:#All= 
	(
		clearlistener()
		if classof sender == dotnetobject or classof sender == dotnetclass then 
		(
			if option==#All or option==#constructor do
			(
				format "\nConstructors =================================================================== : \n"
				dotnet.showConstructors sender
			)
			if option==#All or option==#properties do
			(
				format "\nPeroperties =====================================================================: \n"
				showproperties sender
			)
			if option==#All or option==#methods do
			(
				format "\nMethods =====================================================================: \n"
				showmethods sender
			)
			if option==#All or option==#events do
			(
				format "\nEvents =====================================================================: \n"
				showevents sender
			)
		)else (format "Not a DotnetObject or DotnetClass!:%\n" sender)
	)
	fn DnRect p:[0,0] s:[10,10] = ((dotnetobject "system.drawing.rectangle" p.x p.y s.x s.y))
	fn DnSize s:[10,10]=(return (dotNetObject "system.drawing.size" s.x s.y))
	fn DnPoint p:[0,0]=(dotNetObject "system.drawing.Point" p.x p.y)
	fn DnColorARGB a:255 r:255 g:255 b:255  = ((dotnetclass "system.drawing.color").fromArgb a r g b)
	fn DnColor C:[255,255,255] a:255 		= ((Dotnetclass "system.drawing.color").fromArgb a c.x c.y c.z)
	fn DnLoadBitmap FilePath Filename= (return((DotNetClass "system.drawing.bitmap").fromFile(FilePath+Filename)))
/*==============================================================================================================================*/
--Value Convertors-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
/*==============================================================================================================================*/
	--Convert The Dotnet Color Class ARGB To String Formated Value 
	--DnColorToCString / CStringToDnColor / DnLocationToString / StringToDnLocation /DnSizeToString /StringToDnSize
	
	fn DnColorToCString DnColor= 
	(
			CString =""
			CString+= (DnColor.a as string) + ","
			CString+= (DnColor.r as string) + ","
			CString+= (DnColor.g as string) + ","
			CString+= (DnColor.b as string)
			return CString
	)
	--Parse The String Formated Value To Dotnet Color Class ARGB Object 
	fn CStringToDnColor CString= 
	(
			ColorArray = filterString CString ","
			A = ColorArray[1] as integer
			R = ColorArray[2] as integer
			G = ColorArray[3] as integer
			B = ColorArray[4] as integer
			TempColor = DnColor C:[R,G,B] a:A
			return TempColor
	)
	--Location To String Ibutton.size.Width as string +","+Ibutton.size.Height as string
	fn DnLocationToString Location= 
	(
		LString = (Location.x as string ) + "," + (Location.y as string )
		return LString
	)
	--Parse The String Formated Value To Dotnet Point [x,y] Object 
	fn StringToDnLocation LString= 
	(
		if LString != undefined and LString!="" then
		(
			LArray = filterString LString ","
			x = LArray[1] as integer
			y = LArray[2] as integer
			Location = DnPoint p:[x,y]
			return Location
		)else
		(
			Location = DnPoint p:[50,50]
			return Location
		)
	)
	--Dn Size to String
	fn DnSizeToString DnSize= 
	(
		LString = (DnSize.Width as string ) + "," + (DnSize.Height as string )
		return LString
	)
	--Parse The String Formated Value To Dotnet Point [x,y] Object 
	fn StringToDnSize LString= 
	(
		LArray = filterString LString ","
 		x = LArray[1] as integer
 		y = LArray[2] as integer
		MySize = DnSize s:[x,y]
 		return MySize
	)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Form Control COLORS---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	RibbonPanel_BackColor = DnColor C:[70,70,70]
	 StatusBar_BackColor = DnColor C:[20,20,20]
	PropertiesPanel_BackColor = DnColor C:[40,40,40]
	PropertiesPanel_ForeColor = DnColor C:[185,185,185]
	 RibbonButtons_BackColor = DnColor C:[60,60,60]
	 RibbonButtons_ForeColor = DnColor C:[250,250,250]--DnColor C:[200,200,200]
	PanelChar_BackColor = DnColor C:[50,50,50]
--Buttons Initialize Function----------------------------------------------------------------------------------------
	fn ButtonInit RButton RBtnName BackColor ForeColor SizeX:90 Sizey:60 = 
		(
			--RButton = dotNetObject "System.Windows.Forms.Button"
			RButton.size = dotNetObject "System.Drawing.Size" SizeX Sizey
			RButton.text = RBtnName
			RButton.location = dotNetObject "System.Drawing.Point" 0 0
			RButton.BackColor = BackColor
			RButton.ForeColor = ForeColor
			RButton.Anchor = RButton.Anchor.top.left.right.bottom
			RButton.FlatStyle = RButton.FlatStyle.Flat
			RButton.Margin.all = 0
			--formatProps RButton
			--TempBtn = dotNetObject "System.Windows.Forms.Button"
			--formatProps TempBtn			
		)
--Screen Capture Methods----------------------------------------------------------------------------------------		

---------------------------- Load Dll Assembly On The Fly ------------------- We Can Change the Dll Without Need To Restart 3dsmax :) :) -----------------------
	fn LoadDllOntheFly DllPath ClassType= 
		(
			assemblypath = DllPath
			UIAssembly = (dotnetclass "System.Reflection.assembly").load ((dotnetclass "System.IO.File").ReadAllBytes assemblypath)
			DotNetType = UIAssembly.GetType (ClassType)
			ClassInstance = (dotnetclass "System.Activator").CreateInstance DotNetType
			gc() -- Deactivate Garbage Collector
			--clearlistener()
			Return ClassInstance
		)
	--Create an Instance Of Partial And Internal Classes
	Local ControlMoveAndResizeClass = LoadDllOntheFly DllPath "UiFramworkLibrary.ControlMoverOrResizer"
		Worktype = ControlMoveAndResizeClass.WorkType.MoveAndResize
		
-- 	Local MultipleMover = LoadDllOntheFly DllPath "UiFramworkLibrary.ControlMover"
-- 		formatProps ControlMoveAndResizeClass
	Local GraphicButton = LoadDllOntheFly DllPath "UiFramworkLibrary.GraphicButton"
	
	Local PropertyGrid = LoadDllOntheFly DllPath "UiFramworkLibrary.CustomPropertyGrid"
	-- 	formatProps ControlMoveAndResizeClass
		--formatProps GraphicButton
/*--Character Selection Panel -Ibuttons Container-------------------------------------------------------------------*/
		--Panel_Char = (dotNetObject "System.Windows.Forms.Panel")
		
		Local Panel_Char = LoadDllOntheFly DllPath "UiFramworkLibrary.CustomPanel"
				
		--Local Panel_Char_ImageBox = LoadDllOntheFly DllPath "UiFramworkLibrary.CustomImageBox"
		ControlMoveAndResizeClass.IContainer = Panel_Char
		
		Panel_Char_BackImagePath=""
-- 		formatProps Panel_Char_ImageBox
/*----------------------------------------*//*----------------------------------------------------------------------------------------------------------------*/---------------------------------------------------------------
/*----------------------------------------*//* COLORING Selected Controller in a container / Iselected is a array of Controls /*------------------------------------------------------------
/*-----------------------------------------*//*---------------------------------------------------------------------------------------------------------------*/---------------------------------------------------------------
		fn Selected_Controls_Color IContainer ISelected = 
		(
			for i = 0 to IContainer.controls.Count-1 do
			(	
				try 
					(
						IButton = Panel_Char.controls.item[i]
						Ibutton.IsSelected = False
					)
				catch()
			)
			for x in ISelected do
			(
				x.IsSelected = True
			)
		)

/*----------------------------------------------------------------------------*//*----------------------------------------------------------------------------*/
/*-----------------------------------------------------------Suffix Seperator Function------------------------------------------------------------*/
/*----------------------------------------------------------------------------*//*----------------------------------------------------------------------------*/
fn Suffix_Sepertor Str = 
	(
		if Str != "" then 
						(
							Temp = filterString Str "-" splitEmptyTokens:true
							if Temp.count == 2 do
							(
								IPrefix = Temp[1]
								ISuffix = Temp[2]
							)
							if Temp.count == 0 do
							(
								IPrefix = ""
								ISuffix = ""
							)
						)else
						(
							IPrefix = ""
							ISuffix = ""
						)
		return ISuffix
	)
/*----------------------------------------------------------------------------*//*----------------------------------------------------------------------------*/
/*-----------------------------------------------------------Prefix Seperator Function------------------------------------------------------------*/
/*----------------------------------------------------------------------------*//*----------------------------------------------------------------------------*/
fn Prefix_Sepertor Str = 
	(
		if Str != "" then 
						(
							Temp = filterString Str "-" splitEmptyTokens:true
							if Temp.count == 2 do
							(
								IPrefix = Temp[1]
								ISuffix = Temp[2]
							)
							if Temp.count == 0 do
							(
								IPrefix = ""
								ISuffix = ""
							)
						)else
						(
							IPrefix = ""
							ISuffix = ""
						)
		return IPrefix
	)
/* "IButtons" are the Buttons we going toadd at runtime*/ 
	fn IButton_MouseDown Sender arg= 
	(
		/* Seperate LeftClick /Right Click /MiddleClick ----------------------------------------------------------------------*/
		case arg.Button of
		(
			(arg.Button.Left):
			(
				/*Prefix Suffix Seperation */
-- 				try (
						_Prefix = Prefix_Sepertor CharacterName
						_Suffix = Suffix_Sepertor CharacterName

-- 					)catch()
					
				--formatprops sender
				--print (sender.Itag as string)
				sender.BringToFront()
				--PropertyGrid.SelectedObject = Sender.GetWrapper
				--format "\nX:% Y:%\nSX:% SY:%\n-----------" sender.location.x sender.location.y sender.size.Width (sender.size).Height 
				
				try (obj = (Sender.tag.value as array) )catch()

					--************ KeyBoard Check ************ ----------------
					--Check Keyboard CTRL Key is Pressed Or Not
					-- Keyboard Active Ctrl or Alt
					con = dotnetclass "system.windows.forms.control"
					--formatprops con.modifierKeys
					
					case (con.modifierKeys) of 
						(
							(con.modifierKeys.Control):
							(
								--Check If There is Group Selection In The Button 
								appendifunique SelectedButtons sender
								appendifunique ButtonWrapperArray sender.GetWrapper
								PropertyGrid.SelectedObjects = ButtonWrapperArray
								if obj != undefined do 
								(
									for x in obj do
										appendifunique CurrentSelection (getnodebyname (_Prefix + x + _Suffix))
										
								)
								try 
									(
										undo on (select CurrentSelection )
									)
								catch()
								_StatusBarLabel.text = (SelectedButtons.count as string) + "  Buttons Selected"
								break;
							)
							--------------------------------------------------------------------------------
							(con.modifierKeys.Shift) :
							(
								--Check If There is Group Selection In The Button 
								appendifunique SelectedButtons sender
								appendifunique ButtonWrapperArray sender.GetWrapper
								if obj != undefined do 
								(
									for x in obj do
										appendifunique CurrentSelection (getnodebyname (_Prefix + x + _Suffix))
								)
								print ButtonWrapperArray
								PropertyGrid.SelectedObjects = ButtonWrapperArray
								try (undo on (select CurrentSelection)) catch()
								_StatusBarLabel.text = (SelectedButtons.count as string) + "  Buttons Selected"									
								break;
							)
							--------------------------------------------------------------------------------
							(con.modifierKeys.Alt):
							(
								removeBtnIndex = finditem SelectedButtons sender
								if removeBtnIndex!=0 do
									(
										deleteItem SelectedButtons removeBtnIndex
										deleteItem ButtonWrapperArray removeBtnIndex
									)
								if obj!=undefined then
								(
									for x in obj do
									(
										removeObjIndex = finditem CurrentSelection (getnodebyname(_Prefix + x + _Suffix))
										if removeObjIndex!=0 do
										(
											undo on (deselect CurrentSelection)
											deleteItem CurrentSelection removeObjIndex 
										)
									)
								)else
								(
									if removeBtnIndex!=0 do
									(
										undo on (deselect CurrentSelection)
										try(deleteItem CurrentSelection removeBtnIndex) catch()
										try( deleteItem SelectedButtons removeBtnIndex) catch()
										try( deleteItem ButtonWrapperArray removeBtnIndex) catch()
									)
								)
								--removeWrapperIndex = finditem ButtonWrapperArray sender.GetWrapper
								--Finds the Button We Click In The Buttons Array
								--if removeObjIndex == 0 then Couldn't Find The Button / If !=0 its a Index Of Current Button Inside ButtonArray
								
								if CurrentSelection != undefined do 
									(
										undo on ( select CurrentSelection )
									)
								if ButtonWrapperArray[1] != Undefined do
									PropertyGrid.SelectedObjects = ButtonWrapperArray
								
								_StatusBarLabel.text = (SelectedButtons.count as string) + "  Buttons Selected"
								break;
							)
							--------------------------------------------------------------------------------
							(con.modifierKeys.None):
							(
								CurrentSelection=#()
								try (
										for x in obj do appendifunique CurrentSelection (getnodebyname (_Prefix + x + _Suffix))
											(
												undo on (select CurrentSelection)
											)
									)catch(/*print (getcurrentexception())*/)
								SelectedButtonsTemp = SelectedButtons
								SelectedButtons = #()
								ButtonWrapperArray = #()
								appendifunique SelectedButtons sender
								appendifunique ButtonWrapperArray sender.GetWrapper
								PropertyGrid.SelectedObject = Sender.GetWrapper
								_StatusBarLabel.text = (SelectedButtons.count as string) + "  Objects Selected"
								break;
							)
						)
				--- COLORING Selected Buttons Border
				Selected_Controls_Color Panel_Char SelectedButtons
				 --PropertyGrid.Hide()
-- 					SplitContainer.Panel2.hide()
-- 					SplitterDistance = 0	
				try (
						execute Sender.IMaxScript
						--print Sender.Itag
					)catch ()
			)
			------------- RightClick Event----------------
			(arg.Button.Right):
				(	--Set The Current_Control = Selected Button Witch User Right_Clicked On That Right Now -- I Used The Current_Control For RightClick Remove/Rename Event
					Sender.invalidate()
					Sender.Refresh()
					Current_Control = Sender
				
					--print Sender.tag
					--if Sender.tag !=undefined do Format "ButtonTag :%\n Tag.Value :%\n" Sender.tag Sender.tag.value
					--formatprops Current_Control
					--print "Right Click"
				)
			(arg.Button.Middle):
				(
					print "MiddleClick"
-- 					formatprops Panel_Char
				)--;SplitContainer.Panel2.show();SplitterDistance = 50)--;formatProps arg.Button
			(arg.Button.XButton1):print "XButton1"
			(arg.Button.XButton2):print "XButton2"
		)
	)--End Fn
	
/* "IButtons" Mouse Up Event */ ------------------------------------------------------------------------------------------------------------
	fn IButton_MouseUp Sender arg= 
	(
		/* Seperate LeftClick /Right Click /MiddleClick ----------------------------------------------------------------------*/
		case arg.Button of
		(
			(arg.Button.Left):
			(
				--Check The Button Is Out Of Container or Not X axis
				if sender.location.x < (1-(Sender.size.width/2)) do sender.location.x = 1-(Sender.size.width/2)
				if 	sender.location.x > (Panel_Char.size.width - (Sender.size.width/2)) do sender.location.x = (Panel_Char.size.width - (Sender.size.width/2))
				
				--Check The Button Is Out Of Container or Not Y axis
				if sender.location.y < (-(Sender.size.height/2)) do sender.location.y = -(Sender.size.height/2)
				if 	sender.location.y > (Panel_Char.size.height - (Sender.size.height/2)) do sender.location.y = (Panel_Char.size.height - (Sender.size.height/2))
			)
		)
	)
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------Create Context Menu For Right Click----------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/		
	/*RightClick Event Handlers -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
		fn Null = ()
		fn PickObj Sender Arg = 
			(
				--Sender is the Menu Item "Pick Object"-------------------------
				--Sender.Tag Is the Button we RightClicked at-----------------
				--pickObject count:#multiple forceListenerFocus:false
				--print "------------------------------------ Sender ------------------"
				--formatProps Sender
				--print Sender.tag.text
				--fn ObjFilter o = (superclassof o == Geometryclass)
				x = pickObject Prompt:"Pick Object" --filter:ObjFilter
				Obj = #()
				if x!=undefined do 
					(
						Appendifunique Obj x.name
						Ibutton = Sender.tag
						-- Convert Obj defenition To DotnetObject And Store It On Ibutton.Tag 
						Ibutton.tag = DotNetMxsValue Obj
						--formatProps Ibutton.tag
						print Ibutton.tag.value
						gc()
					)
			)
		fn PickMultiObj Sender Arg = 
			(
				--Sender is the Menu Item "Pick Object"-------------------------
				--Sender.Tag Is the Button we RightClicked at-----------------
				--pickObject count:#multiple forceListenerFocus:false
				--print "------------------------------------ Sender ------------------"
				--formatProps Sender
				--print Sender.tag.text
				Objs = #()
				Obj = pickObject Prompt:"Pick Multiple Objects" count:#multiple
				if (classof Obj)==array do 
					(
						for x in Obj do Appendifunique Objs x.name
						Ibutton = Sender.tag
						-- Convert Obj defenition To DotnetObject And Store It On Ibutton.Tag 
						Ibutton.tag = DotNetMxsValue Objs
						print Ibutton.tag.value
						--formatProps Ibutton.tag
						gc()
					)
			)
											-- STORE Button Data As A Struct To Copy And Past The Buttons Attributes
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Struct CopyTo |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||						
			Struct CopyTo
			(
				ILocation = DnPoint p:[150,150],
				ISize = DnSize s:[30,30],
				IThickness = 5,
				
				IButtonTypeSrting = "Circle",
				IBorderColor = DnColor c:[255,255,255] a:255,
				IInsideColor= DnColor c:[0,0,0] a:255,
				ISelectColor= DnColor c:[0,255,0] a:255,
				ITextColor = DnColor c:[255,255,255] a:255,
				IGradAngle= 180,
				IRadius= 30,
				fn CopyToClipboard MButtonTypeSrting MLocation Msize MThickness MBorderColor MInsideColor MSelectColor MTextColor MGradAngle MRadius= 
					(
						this.ILocation = MLocation
						this.ISize = Msize
						this.IThickness = MThickness
						
						this.IBorderColor = MBorderColor
						this.IInsideColor = MInsideColor
						this.ISelectColor = MSelectColor
						this.ITextColor = MTextColor
						
						this.IGradAngle = MGradAngle
						this.IRadius = MRadius
						this.IButtonTypeSrting = MButtonTypeSrting
					),
				fn IPrint =
					(
						Format "LocationX :%    LocationY: % \n" this.ILocation.x this.ILocation.y
						Format "SizeX :%    SizeY: % \n" this.ISize.Width this.ISize.Height
						Format "Color R:% G:% B:% \n" this.IBorderColor.r this.IBorderColor.g this.IBorderColor.b
						Format "Thickness :% \n" this.IThickness
					)
			)--End Struct 
			MyCopyPaste = CopyTo()
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| CopyToClipboard Event Handler |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||			
		fn CopyToClipboard Sender Arg= 
			(
				Ibutton = Current_Control
				MyCopyPaste.CopyToClipboard IButton.ButtonTypeSrting IButton.Location IButton.Size IButton.Borderthick IButton.IBorderColors IButton.IInsideColors \
											IButton.ISelectedColor IButton.ITextColor IButton.GradientAngle IButton.Radius
				--MyCopyPaste.IPrint()
			)
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Paste ToClipboard Event Handler |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		fn Paste Sender Arg= 
			(
				appendifunique SelectedButtons Current_Control
				for IButton in SelectedButtons do
				(
-- 					IButton = Current_Control
					--IButton.ButtonType = MyCopyPaste.IButtonType
					IButton.Size = MyCopyPaste.ISize
					IButton.Borderthick = MyCopyPaste.IThickness
					IButton.IBorderColors = MyCopyPaste.IBorderColor
						IButton.BackColor = MyCopyPaste.IBorderColor
					IButton.IInsideColors = MyCopyPaste.IInsideColor
						IButton.ForeColor = MyCopyPaste.IInsideColor
					IButton.ISelectedColor = MyCopyPaste.ISelectColor
					IButton.ITextColor = MyCopyPaste.ITextColor 
					
					IButton.GradientAngle = MyCopyPaste.IGradAngle
					IButton.Radius = MyCopyPaste.IRadius
					case MyCopyPaste.IButtonTypeSrting of
						(
							"Circle":(IButton.ButtonType = IButton.ButtonType.CircleButton;break)
							"Curve":(IButton.ButtonType = IButton.ButtonType.CurveButton;break)
							"HalfCircle":
							(
								IButton.ButtonType = IButton.ButtonType.HalfCircleButton;break
-- 								try
-- 									(
-- 										IButton.HCStartAngle =  HCStartAngle
-- 										IButton.HCSweepAngle = HCSweepAngle
-- 										IButton.HCThick = HCThick
-- 									)catch()
							)
							"Rectanlge":(IButton.ButtonType = IButton.ButtonType.RectanlgeButton;break)
							"RoundRectanlge":(IButton.ButtonType = IButton.ButtonType.RoundRectanlgeButton;break)
							default:(IButton.ButtonType = IButton.ButtonType.CircleButton;break)
						)
-- 					formatprops IButton
					IButton.Invalidate
					Current_Control.Invalidate
				)
			)
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Copy To Mirror Position X |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		fn CopyToMirroX Sender Arg= 
		(
-- 				appendifunique SelectedButtons Current_Control
			for IButton in SelectedButtons do
			(
				if (IButton.Text != "IMirrorLineX") and (IButton.Text != "IMirrorLineY") do
				(
					NewButton = AddButton ""
						NewButton.Size = IButton.Size
						NewButton.Borderthick = IButton.Borderthick
						NewButton.IBorderColors = IButton.IBorderColors
						NewButton.BackColor = IButton.BackColor
						NewButton.IInsideColors = IButton.IInsideColors
						NewButton.ForeColor = IButton.ForeColor
						NewButton.ISelectedColor = IButton.ISelectedColor
						NewButton.ITextColor = IButton.ITextColor 
						NewButton.GradientAngle = IButton.GradientAngle
						NewButton.Radius = IButton.Radius
						NewButton.Location = IButton.Location
-- 						formatprops NewButton
					Panel_Char.controls.add(NewButton)
					case (IButton.ButtonTypeSrting) of
						(
							"Circle":(NewButton.ButtonType = NewButton.ButtonType.CircleButton;break)
							"Curve":(NewButton.ButtonType = NewButton.ButtonType.CurveButton;break)
							"HalfCircle":	
							(
								NewButton.ButtonType = NewButton.ButtonType.HalfCircleButton;break
								try
								(
									NewButton.HCStartAngle =  -(IButton.HCStartAngle)
									NewButton.HCSweepAngle = IButton.HCSweepAngle
									NewButton.HCThick = IButton.HCThick
								)catch()
							)
							"Rectanlge":(NewButton.ButtonType = NewButton.ButtonType.RectanlgeButton;break)
							"RoundRectanlge":(NewButton.ButtonType = NewButton.ButtonType.RoundRectanlgeButton;break)
-- 							default:(NewButton.ButtonType = IButton.ButtonType.CircleButton;break)
						)
					dotNet.addEventHandler NewButton "MouseDown" IButton_MouseDown
					dotNet.addEventHandler NewButton "MouseUp" IButton_MouseUp
					ISize = IButton.Size.Width - (IButton.Size.Width * 0.14)
					IDistance = (IMirrorLineX.location.x) - (IButton.Location.x) - ISize
					NewButton.Location.x = (IMirrorLineX.location.x) + IDistance 
				)
			)
		)
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Copy To Mirror Position Y |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		fn CopyToMirroY Sender Arg= 
		(
-- 				appendifunique SelectedButtons Current_Control
			for IButton in SelectedButtons do
			( 
				if (IButton.Text != "IMirrorLineX") and (IButton.Text != "IMirrorLineY") do
				(
					NewButton = AddButton ""
						NewButton.Size = IButton.Size
						NewButton.Borderthick = IButton.Borderthick
						NewButton.IBorderColors = IButton.IBorderColors
						NewButton.BackColor = IButton.BackColor
						NewButton.IInsideColors = IButton.IInsideColors
						NewButton.ForeColor = IButton.ForeColor
						NewButton.ISelectedColor = IButton.ISelectedColor
						NewButton.ITextColor = IButton.ITextColor 
						NewButton.GradientAngle = IButton.GradientAngle
						NewButton.Radius = IButton.Radius
						NewButton.Location = IButton.Location
					case (IButton.ButtonTypeSrting) of
						(
							"Circle":(NewButton.ButtonType = NewButton.ButtonType.CircleButton;break)
							"Curve":(NewButton.ButtonType = NewButton.ButtonType.CurveButton;break)
							"HalfCircle":
							(
								NewButton.ButtonType = NewButton.ButtonType.HalfCircleButton;break
								try
								(
									NewButton.HCStartAngle =  IButton.HCStartAngle + 180
									NewButton.HCSweepAngle = IButton.HCSweepAngle
									NewButton.HCThick = IButton.HCThick
								)catch()								
							)
							"Rectanlge":(NewButton.ButtonType = NewButton.ButtonType.RectanlgeButton;break)
							"RoundRectanlge":(NewButton.ButtonType = NewButton.ButtonType.RoundRectanlgeButton;break)
-- 							default:(NewButton.ButtonType = IButton.ButtonType.CircleButton;break)
						)					
					Panel_Char.controls.add(NewButton)
					dotNet.addEventHandler NewButton "MouseDown" IButton_MouseDown
					dotNet.addEventHandler NewButton "MouseUp" IButton_MouseUp
						ISize = IButton.Size.Height - (IButton.Size.Height * 0.14)
						IDistance = (IMirrorLineY.location.y) - (IButton.Location.y) - ISize
						NewButton.Location.y = (IMirrorLineY.location.y) + IDistance 
				)
			)
		)
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Mirror Position X ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		fn MirrorLocationX Sender Arg= 
			(
-- 				appendifunique SelectedButtons Current_Control
				for IButton in SelectedButtons do
				(
					ISize = IButton.Size.Width - (IButton.Size.Width * 0.14)
					IDistance = (IMirrorLineX.location.x) - (IButton.Location.x) - ISize
					IButton.Location.x = (IMirrorLineX.location.x) + IDistance 
				)
				--Form.Invalidate()
			)
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Mirror Position Y ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		fn MirrorLocationY Sender Arg= 
			(
-- 				appendifunique SelectedButtons Current_Control
				for IButton in SelectedButtons do
				(
					ISize = IButton.Size.Height - (IButton.Size.Height * 0.14)
					IDistance = (IMirrorLineY.location.y) - (IButton.Location.y) - ISize
					IButton.Location.y = (IMirrorLineY.location.y) + IDistance 
				)
			)
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Align X |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||			
		fn AlignX Sender Arg= 
			(
					appendifunique SelectedButtons Current_Control
					for IButton in SelectedButtons do
					(
						IButton.Location.x = MyCopyPaste.ILocation.x + (MyCopyPaste.ISize.Width/2) - (IButton.Size.Width/2)
					)
			)
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Align Y |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||						
		fn AlignY Sender Arg= 
			(
				appendifunique SelectedButtons Current_Control
				for IButton in SelectedButtons do
				(
					IButton.Location.y = MyCopyPaste.ILocation.y + (MyCopyPaste.ISize.Height/2) - (IButton.Size.Height/2)
				)
			)
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Even Distance X |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		fn EvenDistanceX Sender Arg= 
			(
					NumberOfBtns = SelectedButtons.Count
					MinX = 100000;		MinY = 100000
					MaxX = 0  ; 		MaxY = 0 
					FirstXBtn; LastXBtn; FirstYBtn; LastYBtn
					--Counting Minimum and Maximum X & Y of All Selected Buttons
					for IButton in SelectedButtons do
					(
						if IButton.PositionX < MinX do MinX = IButton.PositionX --Min X
						if IButton.PositionX > MaxX do MaxX = IButton.PositionX --Max X
						if IButton.PositionY < MinY do MinY = IButton.PositionY --Min Y
						if IButton.PositionY > MaxY do MaxY = IButton.PositionY --Max Y
					)
					--Define First Button And Last Button on X Axis &&&& --Define First Button And Last Button on Y Axis
					for IButton in SelectedButtons do
					(
						if IButton.PositionX == MinX do FirstXBtn = IButton
						if IButton.PositionX == MaxX do LastXBtn = IButton
						if IButton.PositionY == MinY do FirstYBtn = IButton
						if IButton.PositionY == MaxY do LastYBtn = IButton
					)
					DifX = MaxX-MinX -- - FirstXBtn.ISizeWidth
					DifY = MaxY-MinY -- - FirstYBtn.ISizeHeight
	-- 				format "MinX = % \nMaxX = % \nDifX = % \nMinY = % \nMaxY = % \nDifY = % \n" MinX MaxX DifX MinY MaxY DifY
					-- Positioning in X axis
					k = 1
					for IButton in SelectedButtons do
					(
						if (IButton != FirstXBtn) and (IButton != LastXBtn) do 
						(
							IButton.PositionX = MinX + ((DifX/(NumberOfBtns-1))*k) 
	-- 						format "Ibutton.position = %\n" IButton.PositionX
							k=k+1
						)
					)
			)
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Even Distance Y |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||			
			fn EvenDistanceY Sender Arg= 
			(
				NumberOfBtns = SelectedButtons.Count
				MinX = 100000;		MinY = 100000
				MaxX = 0  ; 		MaxY = 0 
				FirstXBtn; LastXBtn; FirstYBtn; LastYBtn
				
				--Counting Minimum and Maximum X & Y of All Selected Buttons
				for IButton in SelectedButtons do
				(
					if IButton.PositionX < MinX do MinX = IButton.PositionX --Min X
					if IButton.PositionX > MaxX do MaxX = IButton.PositionX --Max X
					
					if IButton.PositionY < MinY do MinY = IButton.PositionY --Min Y
					if IButton.PositionY > MaxY do MaxY = IButton.PositionY --Max Y
				)
				--Define First Button And Last Button on X Axis &&&& --Define First Button And Last Button on Y Axis
				for IButton in SelectedButtons do
				(
					if IButton.PositionX == MinX do FirstXBtn = IButton
					if IButton.PositionX == MaxX do LastXBtn = IButton
					
					if IButton.PositionY == MinY do FirstYBtn = IButton
					if IButton.PositionY == MaxY do LastYBtn = IButton
				)
				DifX = MaxX-MinX -- - FirstXBtn.ISizeWidth
				DifY = MaxY-MinY -- - FirstYBtn.ISizeHeight
				-- Positioning in X axis
				k = 1
				for IButton in SelectedButtons do
				(
					if (IButton != FirstYBtn) and (IButton != LastYBtn) do 
					(
						IButton.PositionY = MinY + ((DifY/(NumberOfBtns-1))*k)--+(IButton.ISizeHeight/2)
						k=k+1
					)
				)
			)
			fn MaxToMinScale Sender Arg= 
			(
				NumberOfBtns = SelectedButtons.Count
				MinX = 100000;		MinY = 100000
				MaxX = 0  ; 		MaxY = 0 
				FirstXBtn; LastXBtn; FirstYBtn; LastYBtn
				
				--Counting Minimum and Maximum X & Y of All Selected Buttons
				for IButton in SelectedButtons do
				(
					if IButton.ISizeWidth < MinX do MinX = IButton.ISizeWidth --Min Width
					if IButton.ISizeWidth > MaxX do MaxX = IButton.ISizeWidth --Max Width
					
					if IButton.ISizeHeight < MinY do MinY = IButton.ISizeHeight --Min Height
					if IButton.ISizeHeight > MaxY do MaxY = IButton.ISizeHeight --Max Height
				)
				--Define First Button And Last Button on X Axis &&&& --Define First Button And Last Button on Y Axis
				for IButton in SelectedButtons do
				(
					if IButton.ISizeWidth == MinX do FirstXBtn = IButton
					if IButton.ISizeWidth == MaxX do LastXBtn = IButton
					
					if IButton.ISizeHeight == MinY do FirstYBtn = IButton
					if IButton.ISizeHeight == MaxY do LastYBtn = IButton
				)
				DifX = MaxX-MinX -- - FirstXBtn.ISizeWidth
				DifY = MaxY-MinY -- - FirstYBtn.ISizeHeight
				-- Positioning in X axis
				k = 1
				for IButton in SelectedButtons do
				(
					if (IButton != FirstYBtn) and (IButton != LastYBtn) do 
					(
						IButton.ISizeWidth = MinX + ((DifX/(NumberOfBtns-1))*k) 
						IButton.ISizeHeight = MinY + ((DifY/(NumberOfBtns-1))*k) 
						k=k+1
					)
				)
			)
	/*Delete Control Event Handler---------------------------------------------------------------------------------------------------------------------------------------------------*/			
		fn DeleteMe Sender Arg= 
			(
				--yesNoCancelBox "Are You Sure !?"
				--queryBox  "queryBox"
				--messagebox "messagebox"
				if SelectedButtons.count < 1 then 
				(
					RemoveBox = queryBox "Are you Sure You want to Remove ?" beep:false 
					if RemoveBox == true then
					(
						if IButton != undefined do
							(
							if (IButton.Text != "IMirrorLineX") and (IButton.Text != "IMirrorLineY") do
							(
								Panel_Char.Controls.Remove(Current_Control)
								PropertyGrid.SelectedObject = Panel_Char.GetWrapper
								ICount-=1
							)
						)
					)
					else 
					(
						print "Cancle Remove"
					)
				)else
				(
					RemoveBox = queryBox "Are you Sure You want to Remove All Selected Buttons ?" beep:false 
					if RemoveBox == true then
					(
						for IButton in SelectedButtons do
						(
							if IButton!=undefined do 
							(
								if (IButton.Text != "IMirrorLineX") and (IButton.Text != "IMirrorLineY") do
								(
									Panel_Char.Controls.Remove(IButton)
									PropertyGrid.SelectedObject = Panel_Char.GetWrapper
									ICount-=1
								)
							)
						)
					)
					else
					(
						print "Cancle Remove"
					)
				)
			)
	/*Here I Create RightClick Menu  (ContextMenu)  -------------------------------------------------------*/	
		fn GetMenu IButton= 
		(
			Names = #("&Pick Object","&Pick Multiple Object","-","&Copy","Paste","-","&Mirror X","&Mirror Y","Align X","Align Y","EvenDistanceX","EvenDistanceY","MaxToMinScale","Delete Me","CopyToMirroX","CopyToMirroY")
			EventHandlers = #(PickObj,PickMultiObj,Null,CopyToClipboard,Paste,Null,MirrorLocationX,MirrorLocationY,AlignX,AlignY,EvenDistanceX,EvenDistanceY,MaxToMinScale,DeleteMe,CopyToMirroX,CopyToMirroY)
			Events = #("Click","Click","Click","Click","Click","Click","Click","Click","Click","Click","Click","Click","Click","Click","Click","Click")
			cm = (dotnetobject "System.Windows.Forms.ContextMenu")

			for i= 1 to Names.count do
				(
					--Add menu items
					MI = cm.MenuItems.add names[i]
					-- i Store The Button Name On The Menu Items Tag 
					Mi.tag = IButton
					dotnet.addeventhandler mi events[i] EventHandlers[i]
					dotnet.setlifetimecontrol mi #dotnet
				)
			return cm
		)
/*----------------------------------------------------------------------------------------------------------------------------*/
/*------------------Add a Graphic Button To Form And Keep it To Button Array-------------------*/
/*---------------------------------------------------------------------------------------------------------------------*/
	fn AddButton IName ButtonType:"Circle" PosX:100 PosY:100 SizeX:50 SizeY:50 BorderThick:5  TextColor:undefined alphas:255 GradAngle:180 Tag:Undefined Radius:20 \
				       BorderColor:(dncolor c:[148,148,255] a:255) InsideColor:(dncolor c:[128,128,255] a:255) SelectColor:(dncolor c:[0,255,0] a:255) HCThick:15 HCSweepAngle:180 HCStartAngle:0 \
					   ItagScr:""=
		(
		--Declare One IButton /*---------------------------------------------------------------------------------------------------------------------------------------------------------*/
			IButton = LoadDllOntheFly DllPath "UiFramworkLibrary.GraphicButton" --IButton = dotnetobject "UiFramworkLibrary.GraphicButton"
			if IName!=undefined then IButton.text = (IName as String) else IButton.text = "B"
			IButton.IMaxScript = ItagScr as String
			IButton.size = dotNetObject "System.Drawing.Size" SizeX SizeY
			IButton.location = dotNetObject "System.Drawing.Point" PosX PosY
			IButton.MinimumSize = DnSize s:[10,10]
			IButton.IBorderColors = BorderColor--DnColor C:BorderColor a:alphas BackColor
			IButton.IInsideColors = InsideColor--DnColor C:InsideColor a:alphas ForeColor
			IButton.ISelectedColor = SelectColor--DnColor C:SelectColor a:alphas Appreience BorderColor
			IButton.ITextColor = TextColor --DnColor C:TextColor a:alphas
			IButton.BorderThick = BorderThick
			IButton.GradientAngle = GradAngle
			IButton.Radius = Radius
			case ButtonType of
			(
				"Circle":(IButton.ButtonType = IButton.ButtonType.CircleButton;break)
				"Curve":(IButton.ButtonType = IButton.ButtonType.CurveButton;break)
				"HalfCircle":
				(
					IButton.ButtonType = IButton.ButtonType.HalfCircleButton;break
					try
						(
							IButton.HCStartAngle =  HCStartAngle
							IButton.HCSweepAngle = HCSweepAngle
							IButton.HCThick = HCThick
						)catch()
				)
				"Rectanlge":(IButton.ButtonType = IButton.ButtonType.RectanlgeButton;break)
				"RoundRectanlge":(IButton.ButtonType = IButton.ButtonType.RoundRectanlgeButton;break)
				default:(IButton.ButtonType = IButton.ButtonType.CircleButton;break)
			)
			
			IButton.Tag = Tag
			
		--Set RightClick Menu/*----------------------------------------------------------------------------------------------------------------------------------------------------------*/
			IButton.Contextmenu = GetMenu IButton
		-- Initialize Move And Resize For IButton/*--------------------------------------------------------------------------------------------------------------------------------*/
			ControlMoveAndResizeClass.Init IButton
			ControlMoveAndResizeClass.Worktype = Worktype
			append ButtonArray IButton
			BtnArrayIndex +=1
			return IButton
		)
-------------***********************************************************************************************		Form   		-------------***********************************************************************************************
-------------***********************************************************************************************     Keyboard Down 	-------------***********************************************************************************************
-------------***********************************************************************************************		Event     		-------------***********************************************************************************************
	fn Form_KeyDown Sender arg= 
	(
-- 		 formatprops arg.Modifiers
		case (arg.KeyCode) of
		(
			((dotnetclass "System.Windows.Forms.Keys").Tab):
			(
				_FormKeyboardLock = not _FormKeyboardLock
				if _FormKeyboardLock then _StatusBarLabel.text = "Keyboard Locked" else _StatusBarLabel.text = "Keyboard UnLocked / Use Arrow Keys To Move Selected Buttons "
			)
		)
		if _FormKeyboardLock == False do
		(	
		case (arg.KeyCode) of
		(
			((dotnetclass "System.Windows.Forms.Keys").UP):
			(
-- 				print "Up Arrow"
				case (arg.Modifiers) of 
				(
					---------------Scale -------------------
					((dotnetclass "System.Windows.Forms.Keys").Shift):
					(
						_StatusBarLabel.text = _StatusBarLabel.text + "Shift Pressed"
						for IButton in SelectedButtons do
							IButton.Size = DnSize s:[IButton.Size.Width,IButton.Size.Height - 1]
					)
					--------------------------------------------
					((dotnetclass "System.Windows.Forms.Keys").None):
					(
						for IButton in SelectedButtons do
							try (IButton.Location.y = IButton.Location.y - 5) catch()
					)
					((dotnetclass "System.Windows.Forms.Keys").Control):
					(
						for IButton in SelectedButtons do
							try (IButton.Location.y = IButton.Location.y - 1) catch()
						_StatusBarLabel.text = _StatusBarLabel.text + "Control Pressed"
					)
				)
			)
			((dotnetclass "System.Windows.Forms.Keys").Down):
			(
-- 				print "Down Arrow"

				case (arg.Modifiers) of 
				(
					---------------Scale -------------------
					((dotnetclass "System.Windows.Forms.Keys").Shift):
					(
						_StatusBarLabel.text = _StatusBarLabel.text + "Shift Pressed"
						for IButton in SelectedButtons do
							IButton.Size = DnSize s:[IButton.Size.Width,IButton.Size.Height + 1]
					)
					--------------------------------------------					
					((dotnetclass "System.Windows.Forms.Keys").Control):
					(
						for IButton in SelectedButtons do
							try (IButton.Location.y = IButton.Location.y + 1) catch()
					)
					((dotnetclass "System.Windows.Forms.Keys").None):
					(
						for IButton in SelectedButtons do
							try (IButton.Location.y = IButton.Location.y + 5) catch()
					)
				)
			)
			((dotnetclass "System.Windows.Forms.Keys").Left):
			(
-- 				print "Left Arrow"
				case (arg.Modifiers) of 
				(
					---------------Scale -------------------
					((dotnetclass "System.Windows.Forms.Keys").Shift):
					(
						_StatusBarLabel.text = _StatusBarLabel.text + "Shift Pressed"
						for IButton in SelectedButtons do
							IButton.Size = DnSize s:[IButton.Size.Width-1,IButton.Size.Height]
					)
					--------------------------------------------					
					((dotnetclass "System.Windows.Forms.Keys").Control):
					(
						for IButton in SelectedButtons do
							try (IButton.Location.x = IButton.Location.x - 1) catch()
					)
					((dotnetclass "System.Windows.Forms.Keys").None):
					(
						for IButton in SelectedButtons do
							try (IButton.Location.x = IButton.Location.x - 5) catch()
					)
				)
			)
			((dotnetclass "System.Windows.Forms.Keys").Right):
			(
-- 				print "Right Arrow"
				case (arg.Modifiers) of 
				(
					---------------Scale -------------------
					((dotnetclass "System.Windows.Forms.Keys").Shift):
					(
						_StatusBarLabel.text = _StatusBarLabel.text + "Shift Pressed"
						for IButton in SelectedButtons do
							IButton.Size = DnSize s:[IButton.Size.Width+1,IButton.Size.Height]
					)
					--------------------------------------------					
					((dotnetclass "System.Windows.Forms.Keys").Control):
					(
						for IButton in SelectedButtons do
							try (IButton.Location.x = IButton.Location.x + 1) catch()
					)
					((dotnetclass "System.Windows.Forms.Keys").None):
					(
						for IButton in SelectedButtons do
							try (IButton.Location.x = IButton.Location.x + 5) catch()
					)
				)
			)
			((dotnetclass "System.Windows.Forms.Keys").M):
			(
				_StatusBarLabel.text = "Press M Key to Toggle Mirror Lines Show/Hide / Select Theme and use arrow Keys to move the mirror lines"
				try(
					IMirrorLineX.Visible = not IMirrorLineX.Visible
					IMirrorLineY.Visible = not IMirrorLineY.Visible
				)catch()
			)
			((dotnetclass "System.Windows.Forms.Keys").C):
			(
				_StatusBarLabel.text = "Press C Key to Center Mirror Lines"
				try(
					IMirrorLineX.Location = DnPoint p:[((Form.Size.Width)/2),-1500]
					IMirrorLineY.Location = DnPoint p:[-1500,((Form.Size.Height)/2)]
				)catch()
			)
			
		)
	)
-- 	formatprops (dotnetclass "System.Windows.Forms.Keys")
	)
	/* "Panel_Char_MouseDown" are the Panel_Char Container Of All Conrols*/ 
	fn Panel_Char_MouseDown Sender arg= 
	(
		/* Seperate LeftClick /Right Click /MiddleClick ----------------------------------------------------------------------*/
		case arg.Button of
		(
			(arg.Button.Left):
			(
				try
				(
					CurrentSelectionTemp = CurrentSelection 
					SelectedButtonsTemp = SelectedButtons
					ButtonWrapperArrayTemp = ButtonWrapperArray
					
-- 					deselect CurrentSelection
-- 					CurrentSelection = #()
-- 					SelectedButtons = #()
-- 					ButtonWrapperArray = #()
					PropertyGrid.SelectedObjects = undefined
					PropertyGrid.SelectedObject = undefined
					Selected_Controls_Color Panel_Char SelectedButtons
					_StatusBarLabel.text = (CurrentSelection.count as string) + "  Objects Selected"
				)catch()
			)
			------------- RightClick Event----------------------------
			(arg.Button.Right):
			(
				PropertyGrid.SelectedObject = Panel_Char.GetWrapper -- ;print "Right Click"
				--PropertyGrid.SelectedObject = Panel_Char_ImageBox.GetWrapper
				_StatusBarLabel.text = "Change Background Image Properties"
				
			)
			------------- MiddleClick HidePanels-----------------
			(arg.Button.Middle):
					(
						con = dotnetclass "system.windows.forms.control"
						--formatprops con.modifierKeys
									
						case (con.modifierKeys) of 
						(
							(con.modifierKeys.Control):
							(
									-- Hide Left And Right Panel With Middle Mouse Click On the Panel_Char.Panel1 
-- 									print "Hide Panels"
									PropertyGrid.Visible = not PropertyGrid.Visible
									SplitContainer.Panel2.Visible = not SplitContainer.Panel2.Visible
									StatusBar.Visible = not StatusBar.Visible
								if StatusBar.Visible then
									_StatusBarLabel.text = "Middle Mouse Click / Show Panels"
								else
									_StatusBarLabel.text = "Middle Mouse Click / Hide Panels"
								if SplitContainer.Panel2.Visible then 
									(
										SplitContainer.Panel2Collapsed = false
										SplitContainer.Panel2.show()
-- 											SplitContainer.SplitterDistance = ((SplitContainer.width/3)*2)
										
										RibbonPanel.Visible=true
									)
								else
									(
										SplitContainer.Panel2Collapsed = true
										SplitContainer.Panel2.Hide()
-- 											SplitContainer.SplitterDistance = SplitContainer.width
										
										RibbonPanel.Visible=false
									)
							)
						)
						)--;formatProps arg.Button ; formatprops PropertyGrid
			(arg.Button.XButton1):print "XButton1"
			(arg.Button.XButton2):print "XButton2"
		)
	)--End Fn
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	/*============================================  Rectangle Selection OnMouseUp  ================================================/*\
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	/* "Panel_Char_MouseUp" When Rectangle Selection is Finished */
	--Sender is  UiFramworkLibrary.CustomPanel()
	fn Panel_Char_MouseUp Sender arg= 
	(
 		--Format "SelectedButtons : % \n" Panel_Char.SelectedButtons
		--formatprops Sender
		case arg.Button of
		(
			(arg.Button.Left):
			(
			con = dotnetclass "system.windows.forms.control"
			--formatprops con.modifierKeys
			case con.modifierKeys of 
			(
				(con.modifierKeys.Control):
				(
					CurrentSelection = CurrentSelectionTemp 
					SelectedButtons = SelectedButtonsTemp
					ButtonWrapperArray = ButtonWrapperArrayTemp
					try
					(
						RectSelectBtns = (Panel_Char.SelectedButtons as array)
						for btn in RectSelectBtns do 
							appendifunique SelectedButtons btn
						--Join SelectedButtons RectSelectBtns
						for x in SelectedButtons do
						(
							appendifunique ButtonWrapperArray x.GetWrapper
							Objs = x.tag.value
							for obj in Objs do
								appendifunique CurrentSelection (getnodebyname (_Prefix + obj + _Suffix))
						)
						PropertyGrid.SelectedObject = undefined
						PropertyGrid.SelectedObjects = ButtonWrapperArray				
						undo on ( select CurrentSelection )
					)catch()
					_StatusBarLabel.text = (SelectedButtons.count as string) + "  Objects Selected"
					break;
				)
				--------------------------------------------------------------------------------
				(con.modifierKeys.Shift) :
				(
					CurrentSelection = CurrentSelectionTemp 
					SelectedButtons = SelectedButtonsTemp
					ButtonWrapperArray = ButtonWrapperArrayTemp
					try
					(
						RectSelectBtns = (Panel_Char.SelectedButtons as array)
						Join SelectedButtons RectSelectBtns
						for x in SelectedButtons do
						(
							appendifunique ButtonWrapperArray x.GetWrapper
							Objs = x.tag.value
							for obj in Objs do
								appendifunique CurrentSelection (getnodebyname (_Prefix + obj + _Suffix))
						)
						PropertyGrid.SelectedObject = undefined
						PropertyGrid.SelectedObjects = ButtonWrapperArray
						undo on (select CurrentSelection)
						_StatusBarLabel.text = (SelectedButtons.count as string) + "  Objects Selected"
					)catch()
					break;
				)
				--------------------------------------------------------------------------------
				(con.modifierKeys.Alt):
					(
						RectSelectBtns = (Panel_Char.SelectedButtons as array)
						if RectSelectBtns.count < 1 do break;
							
						CurrentSelection = CurrentSelectionTemp 
						SelectedButtons = SelectedButtonsTemp
						ButtonWrapperArray = ButtonWrapperArrayTemp

						if RectSelectBtns.count > 0 do
						(
							for btn in RectSelectBtns do
							(
								BtnIndex = finditem SelectedButtons btn
								if BtnIndex!=0 do
									(
										try (Objs = btn.tag.value)Catch()
										if Objs!=undefined do
										(
											for obj in Objs do
												(
													ObjIndex = finditem CurrentSelection (getnodebyname (_Prefix + obj + _Suffix))
													if ObjIndex!=0 do
														(
															try(
															undo on (deselect (getnodebyname (_Prefix + obj + _Suffix)))
															deleteItem CurrentSelection ObjIndex
															)catch()
														)
												)
										)
										deleteItem SelectedButtons BtnIndex
										deleteItem ButtonWrapperArray BtnIndex
									)
							)
						)
						try (
								undo on (select CurrentSelection)
								PropertyGrid.SelectedObject = undefined
								PropertyGrid.SelectedObjects = ButtonWrapperArray
								_StatusBarLabel.text = (SelectedButtonsTemp.count as string) + "  Objects Selected"
							)catch()
						break;
					)
				--------------------------------------------------------------------------------
				(con.modifierKeys.None):
				(
					undo on (try (deselect CurrentSelection)catch())
					CurrentSelection = #()
					SelectedButtons = #()
					ButtonWrapperArray = #()

					RectSelectBtns = (Panel_Char.SelectedButtons as array)
					SelectedButtons =  RectSelectBtns
					for x in SelectedButtons do
						(
							append ButtonWrapperArray x.GetWrapper
							try (Objs = x.tag.value)Catch()
							if Objs != undefined do
								for obj in Objs do
									append CurrentSelection (getnodebyname (_Prefix + obj + _Suffix))
						)
					undo on (
						try 
						(
							select CurrentSelection
							_StatusBarLabel.text = (SelectedButtons.count as string) + "  Objects Selected"
						)catch())
					PropertyGrid.SelectedObjects = ButtonWrapperArray
					break;
				)
			) --End Case Keyboard
			)
			(arg.Button.Right):break;
		)--End case arg.Button of
		Selected_Controls_Color Panel_Char SelectedButtons			
	)--End Fn
/* AddButton MouseDown Event Handler ----------------------------------------------------------------------*/
	fn BtnAdd_MouseDown sender arg = 
		(
			--print"Clicked"
			--IButton = AddButton (ICount as string) PosX:100 PosY:100 SizeX:50 SizeY:50 Color:[150,150,150]
-- 			IButton = AddButton IbuttonText PosX:IbuttonPos.X PosY:IbuttonPos.Y SizeX:IbuttonSize.X SizeY:IbuttonSize.Y tag:IbuttonTag BorderColor:IbuttonBackColor \
-- 												InsideColor:IbuttonForeColor SelectColor:IbuttonISelectedColor TextColor:IbuttonTextColor
			IButton = AddButton "" PosX:100 PosY:100 SizeX:50 SizeY:50 --BorderColor:[150,150,150]
			dotNet.addEventHandler IButton "MouseDown" IButton_MouseDown
			dotNet.addEventHandler IButton "MouseUp" IButton_MouseUp
-- 			dotNet.addEventHandler IButton "MouseMove" IButton_MouseMove
			Panel_Char.controls.add IButton
			IButton.BringToFront()
			dotnet.SetlifetimeControl IButton #dotNet 
			ICount+=1
		)
/* Save Button MouseDown Event Handler ----------------------------------------------------------------------*/
		-----------------------------------------	        -----------------------------------------------------------------------
		------------------------------------------ XML ---------------------------------------------------------------------------
		------------------------------------------         --------------------------------------------------------------------------------
		/* Save All the Controls Inside a Container------------------------------------------------------------------------------*/
		fn SaveControls_To_XmlFile IContainer filename: = 
		(
			if filename == unsupplied do filename = getSaveFilename caption:"Save Dummy List File" types:"Dummy List (.xml)|*.xml"
			(
				if filename != undefined do
				(
					if getfilenametype filename == "" do filename += ".xml"
					(
						--Create XmlDocument From Dotnet Xml Document Class 
						Doc = dotnetObject "system.xml.xmlDocument"	
						--formatProps Doc
						--Add Some Comments at Begging of The Xml File 
						Doc.AppendChild (Doc.CreateComment "Character Selector")
						Doc.AppendChild (Doc.CreateComment ("File: " + maxfilepath + maxfilename + " Creation Date: " + localtime)))
						Doc.AppendChild (Doc.CreateWhitespace "\n")
						--Create The First Element
						Doc.AppendChild (xnodes = doc.CreateElement "CharatcerInfoElement")
							xnodes.SetAttribute "CharacterName" (CharacterName as string)--(nodes.count as string)
							xnodes.SetAttribute "FormX" (Form.Width as string)--(FormSize X)
							xnodes.SetAttribute "FormY" (Form.Height as string)--(FormSize Y)
							-- CHANGE THIS TO A GLOBAL BACKGROUND PATH OR SOMETHING
							xnodes.SetAttribute "BackgroundFilePath" (Panel_Char_BackImagePath as string)
							xnodes.SetAttribute "SpliterDistance" (SplitContainer.SplitterDistance as string)
							xnodes.SetAttribute "ImagePositionX" (Panel_Char.PositionX as string)
							xnodes.SetAttribute "ImagePositionY" (Panel_Char.PositionY as string)
							xnodes.SetAttribute "IimageWidth" (Panel_Char.Iwidth as string)
							xnodes.SetAttribute "IimageHeight" (Panel_Char.Iheight as string)
					--Loop Throgh All The Controls Of IContainer
						for i = 0 to (IContainer.controls.count-1 as integer) do 
						(
							--I Convert all the values of Ibuttons to string to save it in the Xml file as string
							--Convertors Functions : DnColorToCString / CStringToDnColor / DnLocationToString / StringToDnLocation /DnSizeToString /StringToDnSize
							Ibutton = IContainer.controls.Item[i]
							--IbuttonName = Ibutton.name as string
							IbuttonText= Ibutton.text as string
							IbuttonITagScript =Ibutton.IMaxScript as string ----------------$$$
							IbuttonPos = (DnLocationToString Ibutton.location) as string
							IbuttonSize = (DnSizeToString Ibutton.size) as string
							IbuttonBackColor = (DnColorToCString Ibutton.IBorderColors) as string
							IbuttonForeColor = (DnColorToCString Ibutton.IInsideColors) as string
							IbuttonTextColor = (DnColorToCString Ibutton.ITextColor) as string
							IbuttonISelectedColor = (DnColorToCString IButton.ISelectedColor) as string
							IbuttonType = IButton.ButtonTypeSrting as string
							IbuttonBorderThick = IButton.BorderThick as string
							IbuttonGradientAngle = IButton.GradientAngle as string
							IbuttonRadius = IButton.Radius as string
							IbuttonTag = (undefined) as string

							try(
							if Ibutton.tag != undefined Do
							(
								ObjArray = #()
								-- Making The Array of names of Objects inside Button.Tag
								if (classof (Ibutton.tag.value) == array)  then
									for i= 1 to Ibutton.tag.value.count do
										append ObjArray (Ibutton.tag.value[i])
								else
									append ObjArray (Ibutton.tag.value)
								-- Convert the Object Array to String and Pars it 
								-- Making Array Of Object Names As String
								ObjStr = ""
								for obj in ObjArray do
								(
									if obj != undefined do
										ObjStr += (obj as string) + "||"
								)
								ObjStr = trimright ObjStr "||"
								IbuttonTag = ObjStr
							)
							)catch()
							--Store each IButton as a Element and Set the attributes and values for that
							xnodes.AppendChild (xnode = doc.CreateElement "IButton")		
							--Convertors Functions : DnColorToCString / CStringToDnColor / DnLocationToString / StringToDnLocation /DnSizeToString /StringToDnSize
								xnode.SetAttribute "Text" 	   		IbuttonText				--Button.Text
								xnode.SetAttribute "Location" 		IbuttonPos				--Button.Location as string
								xnode.SetAttribute "Size"	   		IbuttonSize				--Button.Size as string
								xnode.SetAttribute "BackColor" 	   	IbuttonBackColor		--Button.BackColor as string
								xnode.SetAttribute "ForeColor"   	IbuttonForeColor		--Button.ForeColor as string
								xnode.SetAttribute "TextColor"    	IbuttonTextColor		--Button.TextColor as string
								xnode.SetAttribute "ISelectedColor" IbuttonISelectedColor	--Button.IsSelectedColor as string
								xnode.SetAttribute "ButtonType" 	IbuttonType				--Button.ButtonType as string
								xnode.SetAttribute "BorderThick" 	IbuttonBorderThick		--Button.ButtonType as string
								xnode.SetAttribute "GradientAngle" 	IbuttonGradientAngle	--Button.ButtonType as string
								xnode.SetAttribute "Radius" 		IbuttonRadius			--Button.ButtonType as string
								xnode.SetAttribute "Tag"  	   		IbuttonTag				--Button.Target Object "Tag" as string	
								xnode.SetAttribute "ITagScript" 	IbuttonITagScript  		--Script To Execute  ----------------$$$
							if IbuttonType == "HalfCircle" do 
							(
								try
								(
								xnode.SetAttribute "HCStartAngle" 	(IButton.HCStartAngle as string)			
								xnode.SetAttribute "HCSweepAngle" 	(IButton.HCSweepAngle as string)			
								xnode.SetAttribute "HCThick" 		(IButton.HCThick as string)		
								)catch()
							)
					)
					doc.Save filename
				)
			)			
			return filename
		)
/* -- Load All The buttons from xml and create buttons inside the container */
	fn PopulateControls_FromXml_To_Container IContainer filename: = 
		(
			if filename == unsupplied do filename = getOpenFilename caption:"Save Dummy List File" types:"Dummy List (.xml)|*.xml"
			(
				if filename != undefined then
				(
				if getfilenametype filename == "" do print"Select A File Please"--filename += ".xml"
					(
						--Create XmlDocument From Dotnet Xml Document Class 
						Doc = dotnetObject "system.xml.xmlDocument"	
						Doc.load (filename)
						IElements = Doc.DocumentElement
						-- Load Form Setting + Background	
						FormElement = IElements.Attributes
						for i = 0 to FormElement.Count-1 do 
						(
							Names = FormElement.ItemOf[i].Name
							case Names of 
								(
									"CharacterName":(
										CharacterName = (FormElement.ItemOf[i].Value) as string
										try (_PrefixSuffixTextBoxA.text = CharacterName) catch()
-- 										Print CharacterName
										break
										)
									"BackgroundFilePath":(
										Panel_Char_BackImagePath = (FormElement.ItemOf[i].Value) as string
-- 										Print BackgroundFilePath
										break
										)
									"FormX":(
										FormX = (FormElement.ItemOf[i].Value) as integer
-- 										Print FormX
										break
										)
									"FormY":(
										FormY = (FormElement.ItemOf[i].Value) as integer
-- 										Print FormY
										break
										)
									"SpliterDistance":(
										SplitterDistance = (FormElement.ItemOf[i].Value) as integer
										break
										)
									"ImagePositionX":(
										Panel_Char.PositionX = (FormElement.ItemOf[i].Value) as integer
										break
										)
									"ImagePositionY":(
										Panel_Char.PositionY = (FormElement.ItemOf[i].Value) as integer
										break
										)
									"IimageWidth":(
										Panel_Char.Iwidth = (FormElement.ItemOf[i].Value) as integer
										break
										)
									"IimageHeight":(
										Panel_Char.IHeight = (FormElement.ItemOf[i].Value) as integer
										break
										)										
									Default:break
								)
							try ( 
									Form.Size = DnSize s:[FormX,FormY] 
									Form.Text = "HPK UI Layout" --CharacterName + " Framework UI "
									Bg = (dotnetclass "System.Drawing.Image").FromFile (Panel_Char_BackImagePath)
									Panel_Char.BackgroundImageLayout = Panel_Char.BackgroundImageLayout.None--.Center--Stretch
									Panel_Char.BackgroundImage = Bg
-- 									Panel_Char_ImageBox.Picture = Bg
									SplitContainer.SplitterDistance = SplitterDistance
								)catch()
							
							--Format "%: Name :%  Value:% \n" I IElements.Attributes.ItemOf[i].Name IElements.Attributes.ItemOf[i].value
						)
						IElements.Attributes.Count
						--Convertors Functions : DnColorToCString / CStringToDnColor / DnLocationToString / StringToDnLocation /DnSizeToString /StringToDnSize
						ChildNodes = IElements.ChildNodes
					--LOAD Buttons Data From XML And Add Theme To Container
						for i = 0 to ChildNodes.count-1 do
						(
							Ibutton = ChildNodes.ItemOf[i]
							IText = (Ibutton.GetAttribute "Text") as string
							ITagScript =(Ibutton.GetAttribute "ITagScript") as string
							IPos =  StringToDnLocation ((Ibutton.GetAttribute "Location")as string)
							ISize = StringToDnSize ((Ibutton.GetAttribute "Size") as string)
							IBackColor 	 = CStringToDnColor ((Ibutton.GetAttribute "BackColor")as string)
-- 							format "IBackColor R : % \n" ((CStringToDnColor ((Ibutton.GetAttribute "BackColor")as string)).r)							
							IForeColor 	 = CStringToDnColor ((Ibutton.GetAttribute "ForeColor")as string)
							ITextColor 	 = CStringToDnColor ((Ibutton.GetAttribute "TextColor")as string)
							ISelectedColor= CStringToDnColor ((Ibutton.GetAttribute "ISelectedColor")as string)
							
							IButtonType= Ibutton.GetAttribute "ButtonType" as string
							if IButtonType == "HalfCircle" do 
							(
								try
								(
									IHCStartAngle = Ibutton.GetAttribute "HCStartAngle" as integer			
									IHCSweepAngle = Ibutton.GetAttribute "HCSweepAngle"  as integer			
									IHCThick = Ibutton.GetAttribute "HCThick"  as integer
								)catch()
							)
							IGradientAngle= Ibutton.GetAttribute "GradientAngle" as integer
							IRadius= Ibutton.GetAttribute "Radius" as integer
							IBorderThick= Ibutton.GetAttribute "BorderThick" as integer
							
							ObjStr = Ibutton.GetAttribute "Tag" as string
							--Parsing Object Names Sring To An Names Array / filterString Makes an Array of string parts by " | | "
								NamesArray = filterString ObjStr "||"
							--Make Objects Array Get Objects By Name
								ObjArray =#()
							for x in NamesArray do
									appendifunique ObjArray x
							--Puting ObjectArray In Button Tag As Dotnet Maxscript Value		
							IbuttonTag =  dotnetmxsvalue (ObjArray)
						
							--format "I:% Text : % PosX:% PosY:% sizx:% sizey:% Tag:%\n" i IbuttonText IbuttonPosX IbuttonPosY IbuttonSizeX IbuttonSizeY IbuttonTag
							--AddButton IName ButtonType:"Circle" PosX:100 PosY:100 SizeX:50 SizeY:50 BorderColor:[0,0,255] InsideColor:[255,255,0] SelectColor:[0,255,0] TextColor:[0,0,0] alphas:255 GradAngle:180 Tag:Undefined =
							
							--REMOVE Mirror Line X axis If it Exsist ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
							if (IText == "IMirrorLineX") do 
							(
								For i = 0 to IContainer.controls.count-1 do 
								(
									try
									(
										if ((IContainer.controls.Item[i].Text)=="IMirrorLineX") do
										(
											CurrentControl = IContainer.controls.Item[i]
											IContainer.Controls.Remove(CurrentControl)
-- 											Print "X removed"
										)
									)catch(/*print (getCurrentException())*/)
								)
							)
							--REMOVE Mirror Line Y axis If it Exsist ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
							if (IText == "IMirrorLineY") do 
							(
								For i = 0 to IContainer.controls.count-1 do 
								(
									try
									(
										if ((IContainer.controls.Item[i].Text)=="IMirrorLineY") do
										(
											CurrentControl = IContainer.controls.Item[i]
											IContainer.Controls.Remove(CurrentControl)
-- 											Print "Y removed"
										)
									)catch(/*print (getCurrentException())*/)
								)
							)
							--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| ADD Buttons To Panel_Char ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
							
							IButton = AddButton IText ButtonType:IButtonType PosX:IPos.x PosY:IPos.y SizeX:ISize.width SizeY:ISize.height tag:IbuttonTag BorderThick:IBorderThick Radius:IRadius \
												BorderColor:IBackColor InsideColor:IForeColor SelectColor:ISelectedColor TextColor:ITextColor HCThick:IHCThick HCSweepAngle:IHCSweepAngle HCStartAngle:IHCStartAngle \
												ITagScr:ITagScript
							
							dotNet.addEventHandler IButton "MouseDown" IButton_MouseDown
							dotNet.addEventHandler IButton "MouseUp" IButton_MouseUp
							IContainer.controls.add IButton
							IButton.BringToFront()
							dotnet.SetlifetimeControl IButton #dotNet 
							ICount+=1
							
							if IText == "IMirrorLineX" do 
							(
								IMirrorLineX = IButton
								IMirrorLineX.MinimumSize = DnSize s:[5,3000]
								IMirrorLineX.Size = dnsize s:[6,3000]
								ControlMoveAndResizeClass.LockControl IMirrorLineX panel_Char
								IMirrorLineX.Visible = false
								IMirrorLineX.Contextmenu = undefined
							)
							if IText == "IMirrorLineY" do 
							(
								IMirrorLineY = IButton
								IMirrorLineY.MinimumSize = DnSize s:[3000,5]
								IMirrorLineY.Size = dnsize s:[3000,6]
								ControlMoveAndResizeClass.LockControl IMirrorLineY panel_Char
								IMirrorLineY.Visible = false
								IMirrorLineY.Contextmenu = undefined
							)
						)			
					)
					return True
				)
				return false
			)
		)
/*-Return List of Controllers in a Container	-----------------------------------------------------------------------------------------------------------------------------------------------------	*/
	fn ListOfControls IContainer = 
		(
			ControlsArray = #()
			for i = 0 to (IContainer.controls.count-1 as integer) do 
			(
				Ibutton = IContainer.controls.Item[i]
				append ControlsArray Ibutton 
			)
			return ControlsArray
		)
/*Save Layout Button MouseDown Event Handler--------------------------------------------------------------*/
	fn BtnSave_MouseDown sender arg = 
		(
			SaveControls_To_XmlFile Panel_Char --filename:(sysinfo.currentdir+"\\XmlLayout.Xml")
			--File = getOpenFilename caption:"Open Dummy List File"
		)	
	fn DeleteAllControls IContainer = 
	(
-- 		Format "Number of Controls: % \n" IContainer.controls.count 
		For i = 0 to IContainer.controls.count-1 do 
			(
				try
				(
					For j = 0 to IContainer.controls.count-1 do 
					(
						if ((IContainer.controls.Item[i].Text)!="IMirrorLineX") and ((IContainer.controls.Item[i].Text)!="IMirrorLineY") do
						(
								--CurrentControl = IContainer.controls.Item[i]
								--Format "% : Name:% Deleted\n" i ((CurrentControl.text))
			 					--IContainer.Controls.Remove(CurrentControl)
								IContainer.Controls.RemoveAt(i)
						)
					)
				)catch(/*print (getCurrentException())*/)
			)
			ICount = 0
	)	
/* Load Button MouseDown Event Handler ----------------------------------------------------------------------*/
	fn BtnLoad_MouseDown sender arg = 
	(
		--Set The PorpertyGrid To Panel Char Because We Are Goint To Remove All the Buttons
		if Panel_Char.Controls.Count > 2 then
		(
			RemoveBox = queryBox "Are you Sure You want to Remove All Controls ?" beep:false 
			if RemoveBox == true then
			(
				PropertyGrid.SelectedObject = Panel_Char.GetWrapper
				--Remove All The Current Controls And Background
				DeleteAllControls Panel_Char
				Panel_Char.BackgroundImage = undefined 
				--Panel_Char_ImageBox.Picture = undefined
				_PrefixSuffixTextBoxA.text = ""
				-- Load Controls From Xml
				Check = PopulateControls_FromXml_To_Container Panel_Char
			)else
			(
				Check = PopulateControls_FromXml_To_Container Panel_Char
			)
		)else
		(
				PropertyGrid.SelectedObject = Panel_Char.GetWrapper
				--Remove All The Current Controls And Background
				DeleteAllControls Panel_Char
				Panel_Char.BackgroundImage = undefined 
				--Panel_Char_ImageBox.Picture = undefined
				
				-- Load Controls From Xml
				Check = PopulateControls_FromXml_To_Container Panel_Char
		)
		
		If Check != undefined do 
		(
			StatusBar.Visible = false
			PropertyGrid.Visible = false
			SplitContainer.Panel2.Visible = false
				SplitContainer.Panel2Collapsed = true
				SplitContainer.Panel2.Hide()
				RibbonPanel.Visible=false
		)
	)	
/**Capture Screen area and save to a vaible or file*/		
	fn BtnCapture_MouseDown sender arg = 
		(
			Imagefilename = getOpenFilename caption:"Load Background" types:("Png (.Png)|*.Png|Bitmap (.Bmp)|*.bmp|Jpeg (.Jpg)|*.jpg")
			if Imagefilename!=undefined do 
			(
				Panel_Char_BackImagePath = Imagefilename
				Bg = (dotnetclass "System.Drawing.Image").FromFile (Imagefilename)
 				Panel_Char.BackgroundImageLayout = Panel_Char.BackgroundImageLayout.None--.Center--Stretch
				Panel_Char.BackgroundImage = Bg
				try
				(
					Panel_Char.Iwidth = Panel_Char.ImageWidth
					Panel_Char.Iheight = Panel_Char.ImageHeight
				)catch()
				--Panel_Char_ImageBox.Picture = Bg

			)
		)	

/*Lock/Unlock Button 3State Button --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	fn BtnLock_MouseDown sender arg = 
		(
			BtnLock = sender as dotNetObject "System.Windows.Forms.Button"
			if (BtnLock.tag+1) < 4 then BtnLock.tag += 1 else BtnLock.tag = 1
			if BtnLock.tag == 1 then
			(
				_FormKeyboardLock = False
				BtnLock.Text = "Move\nScale"
					ControlMoveAndResizeClass.WorkType = ControlMoveAndResizeClass.WorkType.MoveAndResize
					Worktype = ControlMoveAndResizeClass.WorkType
				BtnLock.backcolor = dncolor c:[60,60,60]
				Form.MaximumSize = dnsize s:[1920,1200]
				Form.MinimumSize = dnsize s:[300,300]
				_CreditLabel.text = @"Move/Scale"
				
			)
			else if BtnLock.tag == 2 then
			(
				_FormKeyboardLock = False
				BtnLock.Text = "Move"
				BtnLock.backcolor = RibbonButtons_BackColor
				BtnLock.backcolor = RibbonButtons_ForeColor
					ControlMoveAndResizeClass.WorkType = ControlMoveAndResizeClass.WorkType.Move
					Worktype = ControlMoveAndResizeClass.WorkType
				BtnLock.backcolor = dncolor c:[0,120,0]
				Form.MaximumSize = dnsize s:[1920,1200]
				Form.MinimumSize = dnsize s:[300,300]
				_CreditLabel.text = @"Move"
			)
			else if BtnLock.tag == 3 do
			(
				_FormKeyboardLock = True
				ControlMoveAndResizeClass.WorkType = ControlMoveAndResizeClass.WorkType.None
				Worktype = ControlMoveAndResizeClass.WorkType
				BtnLock.Text = "Locked"
				BtnLock.backcolor = dncolor c:[120,0,0]
				Form.MaximumSize = dnsize s:[Form.Size.width,Form.Size.height]
				Form.MinimumSize = dnsize s:[Form.Size.width,Form.Size.height]
				_CreditLabel.text = @"Locked"
			)
			--BtnLock.tag = not BtnLock.tag
		)
	
	fn _PrefixSuffixTextBoxA_TextChanged sender arg = 
	(
		CharacterName = (sender.text as string)
	)
	fn _PrefixSuffixTextBoxA_Leave sender arg = 
	(
		print ("Prefix =" +_Prefix)
		print ("Suffix =" +_Suffix)
	)
	/* Credit Button--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	fn BtnCredit_MouseDown sender arg = 
		(
			
			_Tooltipstr  = "\t\t\t"+ @"            Created By : Hamed Pourkerman             " + "\n"
			_Tooltipstr	+= "\t\t\t"+ @"                www.Vimeo.com\HamedAdv                " + "\n\n"
			_Tooltipstr += "\t\t\t"+ @"                Last Update: 2018/03/16               " + "\n"
			_Tooltipstr	+= "\t\t\t"+ @"                  HPK UI Layout V1.08                 " + "\n\n"
			_Tooltipstr	+= "1 ) Execute a maxScript line by Buttons [IMaxScript] Property \n"
			_Tooltipstr	+= "2 ) Prefix And Suffix (Seperate With [-])   \n"
			_Tooltipstr	+= @"    Example : [New-001]     --> Prefix = New " + "\n"
			_Tooltipstr	+= @"		                      Suffix = 001 " + "\n\n"
			_Tooltipstr	+= "3 ) Use Ctrl + Middle Mouse Click to Hide and Unhide Left/Right Panels"+"\n\n"
			_Tooltipstr	+= "4 ) Use Arrow keys(Up,Down,Left,Right) to Move Selected Buttons by 5 Pixels"+"\n\n"
			_Tooltipstr	+= "5 ) Use Arrow Keys(Up,Down,Left,Right) +ConrolKey to Move Selected Buttons by 1 Pixel"+"\n\n"
			_Tooltipstr	+= "6 ) Use Arrow Keys(Up,Down,Left,Right) +ShiftKey to Scale Selected Buttons by 1 Pixel"+"\n\n"
			_Tooltipstr	+= "7 ) Use [M Key] To Toggle Show/Hide The Mirror Axis and Use keyboard to Move them"+"\n\n"
			_Tooltipstr	+= "8 ) Use [C Key] To Position To Center the Mirror Axis"+"\n\n"
			_Tooltipstr	+= "9 ) Hold [SpaceBar Key] And Use Mouse Wheel To Pan and Zoom [Not Complete Yet]"+"\n"
			messagebox _Tooltipstr title:"3dsmax HPK Ui Layout V[1.08] HPK"  beep:false pos:[50,50]
-- 			formatprops Sender
		)		
	fn Form_SizeChanged sender arg = 
	(
		Form.Text = @"HPK UI Layout  1.07       X:"+ (Form.Size.Width as string)+@"   Y:" + (Form.Size.Height as string) 
	)
/*----------------------------------------------------------------------------*/
/*------------------Create and initialize UI -----------------------------------*/
/*-----------------------------------------------------------------------------------------------*/
	fn InitUI = 
		(
			--ControlMoveAndResizeClass = LoadDllOntheFly DllPath	
	/*DotNet Form   -----------------------------------------------------------------------------------------------------------------------------------------------------------*/
			Form.Size = DnSize s:[FormX,FormY]
				--Form.topmost = true
			Form.MaximumSize = dnsize s:[1920,1200]
			Form.MinimumSize = dnsize s:[500,500]
			Form.Text = @"HPK UI Layout  1.07       X:"+ (Form.Size.Width as string)+@"   Y:" + (Form.Size.Height as string)
	/*Split Form In 2 Panel   -----------------------------------------------------------------------------------------------------------------------------------------------------------*/			
			SplitContainer.Dock = RibbonPanel.Dock.Fill
			SplitContainer.BackColor = dnColor C:[75,75,75] a:255
			--formatProps SplitContainer
			Form.controls.add(SplitContainer)
			--formatprops SplitContainer.Panel1 
	/*Left Ribbon Panel  / FlowLayoutPanel  ----------------------------------------------------------------------------------------------------------------------------------*/
 			RibbonPanel.Anchor = RibbonPanel.Anchor.top.left 
 			RibbonPanel.Dock = RibbonPanel.Dock.left
			--formatProps RibbonPanel
			--RibbonPanel.AutoSize = true
			RibbonPanel.Size = DnSize s:[65,520] 
			RibbonPanel.BackColor = RibbonPanel_BackColor
			RibbonPanel.TabIndex = 0
--			Form.controls.add(RibbonPanel)
			SplitContainer.Panel1.Controls.add(RibbonPanel)
			dotnet.SetlifetimeControl RibbonPanel #dotNet
	/*Bottom Status Panel   ----------------------------------------------------------------------------------------------------------------------------------*/
 			StatusBar.Anchor = StatusBar.Anchor.top.Bottom 
 			StatusBar.Dock = StatusBar.Dock.Bottom
			StatusBar.Size = DnSize s:[Form.size.Width,15] 
			StatusBar.BackColor = StatusBar_BackColor
			StatusBar.TabIndex = 0
				/*Status Label Init*/
				_StatusBarLabel = dotNetObject "System.Windows.Forms.Label"
				_StatusBarLabel.text = "Status Bar"
				_StatusBarLabel.Anchor = _StatusBarLabel.Anchor.top.Bottom 
				_StatusBarLabel.Dock = _StatusBarLabel.Dock.Bottom
				_StatusBarLabel.Autosize = true
				_StatusBarLabel.Location = DnPoint p:[0,0]
				_StatusBarLabel.ForeColor = (dncolor c:[150,150,150] a:50)
				StatusBar.Controls.add(_StatusBarLabel)
-- 				formatprops _StatusBarLabel
				dotnet.SetlifetimeControl _StatusBarLabel #dotNet 

			Form.Controls.add(StatusBar)
			dotnet.SetlifetimeControl StatusBar #dotNet			
	/*PropertyGrid Control ---------------------------------------------------------------------------------------------------------------------*/
			PropertyGrid.Anchor = PropertyGrid.Anchor.Top.Bottom.Left.Right	
			PropertyGrid.Dock = PropertyGrid.Dock.fill
			PropertyGrid.Autosize = false
			PropertyGrid.size = dnsize s:[220,700]
			
			PropertyGrid.BackColor = PropertiesPanel_BackColor
			PropertyGrid.ForeColor = PropertiesPanel_BackColor
			PropertyGrid.CategoryForeColor = PropertiesPanel_ForeColor -- Brighter
			PropertyGrid.CategorySplitterColor = PropertiesPanel_BackColor
			
			PropertyGrid.CommandsActiveLinkColor = PropertiesPanel_BackColor
			PropertyGrid.CommandsBackColor = PropertiesPanel_BackColor
			PropertyGrid.CommandsBorderColor = PropertiesPanel_BackColor
			PropertyGrid.CommandsDisabledLinkColor = PropertiesPanel_BackColor
			PropertyGrid.CommandsForeColor = PropertiesPanel_BackColor
			PropertyGrid.CommandsLinkColor = PropertiesPanel_BackColor
			
			PropertyGrid.HelpBackColor = PropertiesPanel_BackColor
			PropertyGrid.HelpForeColor = PropertiesPanel_ForeColor
			PropertyGrid.HelpBorderColor = PropertiesPanel_BackColor
			
			PropertyGrid.ViewBackColor = PropertiesPanel_BackColor
			PropertyGrid.ViewBorderColor = PropertiesPanel_BackColor
			PropertyGrid.ViewForeColor = PropertiesPanel_ForeColor
			PropertyGrid.LineColor = dnColor C:[50,50,50] a:255
			
			SplitContainer.Panel2.Controls.add(PropertyGrid)
-- 			formatprops PropertyGrid
			dotnet.SetlifetimeControl PropertyGrid #dotNet
	/*Create Add Button To TopRibbon  ------------------------------------------------------------------------------------------------------------------------------------*/
-- 			BtnAdd = dotNetObject "System.Windows.Forms.Button"
-- 			ButtonInit BtnAdd "Add Rect" RibbonButtons_BackColor SizeX:60 Sizey:60
	/*Create Add Round Button To TopRibbon  ------------------------------------------------------------------------------------------------------------------------------------*/			
			BtnAdd = LoadDllOntheFly DllPath "UiFramworkLibrary.GraphicButton"
			BtnAdd.size = dotNetObject "System.Drawing.Size" RibbonPanelBtnSizeX RibbonPanelBtnSizeY
			BtnAdd.text = ""
			BtnAdd.location = dotNetObject "System.Drawing.Point" 0 0
			BtnAdd.Anchor = BtnAdd.Anchor.top.left.right.bottom
			BtnAdd.IBordercolors = dnColor C:[140,140,255] a:255
			BtnAdd.IInsidecolors = dnColor C:[130,130,255] a:255
-- 			formatprops BtnAdd
	/*Create Save Button To TopRibbon  -----------------------------------------------------------------------------------------------------------------------------------*/		
			BtnSave = dotNetObject "System.Windows.Forms.Button"
			ButtonInit BtnSave "Save Layout" RibbonButtons_BackColor RibbonButtons_ForeColor SizeX:RibbonPanelBtnSizeX Sizey:RibbonPanelBtnSizeX
	/*Create Load Button To TopRibbon  -----------------------------------------------------------------------------------------------------------------------------------*/					
			BtnLoad = dotNetObject "System.Windows.Forms.Button"
			ButtonInit BtnLoad "Load Layout" RibbonButtons_BackColor RibbonButtons_ForeColor SizeX:RibbonPanelBtnSizeX Sizey:RibbonPanelBtnSizeX
	/*Create Snipping Button To TopRibbon  ------------------------------------------------------------------------------------------------------------------------------*/					
			BtnCapture = dotNetObject "System.Windows.Forms.Button"
			ButtonInit BtnCapture "Select Image" RibbonButtons_BackColor RibbonButtons_ForeColor SizeX:RibbonPanelBtnSizeX Sizey:RibbonPanelBtnSizeX
	/*Create 3States LOCK Button To Ribbon  For Change the Move / FreeForm / Lock States------------------------------------------------------------------------------------------------------------------------------*/					
			BtnLock = dotNetObject "System.Windows.Forms.Button" tooltip:_Tooltipstr
			ButtonInit BtnLock "Move\nScale" RibbonButtons_BackColor RibbonButtons_ForeColor SizeX:RibbonPanelBtnSizeX Sizey:RibbonPanelBtnSizeX
			BtnLock.tag = 1
	/*Create Credit Button ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/					
			BtnCredit = dotNetObject "System.Windows.Forms.Button"
			ButtonInit BtnCredit "Updates" RibbonButtons_BackColor RibbonButtons_ForeColor SizeX:RibbonPanelBtnSizeX Sizey:RibbonPanelBtnSizeX
			BtnCredit.Dock = BtnCredit.Dock.Bottom
			--BtnCredit.Margin.Top = 100
			--(dotnetclass "System.Windows.Forms.Padding") 0 100 0 0
			--formatprops BtnCredit.Margin
			_PrefixSuffixTextBoxA = dotNetObject "System.Windows.Forms.TextBox"
			--formatprops _PrefixSuffixTextBoxA
			_PrefixSuffixTextBoxA.Dock = _PrefixSuffixTextBoxA.Dock.Bottom
			_PrefixSuffixTextBoxA.width = 58
			_PrefixSuffixTextBoxA.text = CharacterName
	/*Add Button Controls To  Container TopRibbon  FlowLayoutPanel ---------------------------------------------------------------------------------------------------------------------------------*/								
-- 			RibbonPanel.controls.add(BtnAdd)
			RibbonPanel.controls.add(BtnAdd)
			RibbonPanel.controls.add(BtnSave)
			RibbonPanel.controls.add(BtnLoad)
			RibbonPanel.controls.add(BtnCapture)
			RibbonPanel.controls.add(BtnLock)
			RibbonPanel.controls.add(BtnCredit)
			RibbonPanel.controls.add(_PrefixSuffixTextBoxA)
-- 			dotNet.addEventHandler BtnAdd "MouseDown" BtnAdd_MouseDown
			dotNet.addEventHandler BtnAdd "MouseDown" BtnAdd_MouseDown
			dotNet.addEventHandler BtnSave "MouseDown" BtnSave_MouseDown
			dotNet.addEventHandler BtnLoad "MouseDown" BtnLoad_MouseDown
			dotNet.addEventHandler BtnCapture "MouseDown" BtnCapture_MouseDown
			dotNet.addEventHandler BtnLock "MouseDown" BtnLock_MouseDown
			dotNet.addEventHandler BtnCredit "MouseDown" BtnCredit_MouseDown
			dotNet.addEventHandler _PrefixSuffixTextBoxA "TextChanged" _PrefixSuffixTextBoxA_TextChanged
			dotNet.addEventHandler _PrefixSuffixTextBoxA "Leave" _PrefixSuffixTextBoxA_Leave

-- 			dotnet.SetlifetimeControl BtnAdd #dotNet
			dotnet.SetlifetimeControl BtnAdd #dotNet
			dotnet.SetlifetimeControl BtnSave #dotNet 
			dotnet.SetlifetimeControl BtnLoad #dotNet 
			dotnet.SetlifetimeControl BtnCapture #dotNet 
			dotnet.SetlifetimeControl BtnLock #dotNet 
			dotnet.SetlifetimeControl BtnCredit #dotNet 
			dotnet.SetlifetimeControl _PrefixSuffixTextBoxA #dotNet 
	-- Credit Label------------------------
			_CreditLabel = dotNetObject "System.Windows.Forms.Label"
			_CreditLabel.text = "Move\nScale"
			_CreditLabel.Autosize = true
			_CreditLabel.Location = DnPoint p:[1,1]
			_CreditLabel.ForeColor = (dncolor c:[150,150,150] a:50)
			_CreditLabel.BackColor = PanelChar_BackColor
			SplitContainer.Panel1.Controls.add(_CreditLabel)
-- 		formatprops CreditLabel
-- 			_CreditLabel.BringToFront()
			dotnet.SetlifetimeControl _CreditLabel #dotNet 
	/*Character Container  / Selector Panel  --------------------------------------------------------------------------------------------------------*/
 			Panel_Char.Anchor = Panel_Char.Anchor.Top.Bottom.Left.Right	
 			--Panel_Char.autoSize =true
			Panel_Char.Dock = Panel_Char.Dock.Fill
			Panel_Char.Location = DnPoint p:[154,0]
 			Panel_Char.Size = DnSize s:[2000,2000]
 			Panel_Char.BackColor = PanelChar_BackColor
	/*  ------------------------------------------------------------------------------------------------------------- IMirrorLineX To panel_Char ----------------------------------------------------------------------------------------------------------*/
			IMirrorLineX  = AddButton "IMirrorLineX" ButtonType:"Rectanlge" PosX:0 PosY:0 BorderThick:5\  
										TextColor:undefined alphas:255 \
										GradAngle:180 Tag:Undefined Radius:10 BorderColor:(dncolor c:[255,255,255] a:255) \
										InsideColor:(dncolor c:[255,255,255] a:255) SelectColor:(dncolor c:[0,255,0] a:255)
			IMirrorLineX.MinimumSize = DnSize s:[5,500]
			IMirrorLineX.Location = DnPoint p:[((Form.Size.Width)/2),-1500]
			IMirrorLineX.Size = dnsize s:[6,3000]
			ControlMoveAndResizeClass.LockControl IMirrorLineX panel_Char		
-- 			formatProps ControlMoveAndResizeClass.LockControl
			Panel_Char.controls.add(IMirrorLineX)
			IMirrorLineX.Visible = false
			IMirrorLineX.Contextmenu = undefined
			dotnet.SetlifetimeControl IMirrorLineX #dotNet 
	/*  ------------------------------------------------------------------------------------------------------------IMirrorLineY To panel_Char------------------------------------------------------------------------------------------------------------*/
			IMirrorLineY  = AddButton "IMirrorLineY" ButtonType:"Rectanlge" PosX:0 PosY:0 BorderThick:5\  
										TextColor:undefined alphas:255 \
										GradAngle:180 Tag:Undefined Radius:10 BorderColor:(dncolor c:[255,255,255] a:255) \
										InsideColor:(dncolor c:[255,255,255] a:255) SelectColor:(dncolor c:[0,255,0] a:255)
			IMirrorLineY.MinimumSize = DnSize s:[5,5]
			IMirrorLineY.Size = dnsize s:[3000,6]
			IMirrorLineY.Location = DnPoint p:[-1500,(Form.Size.Height/2)]
			ControlMoveAndResizeClass.LockControl IMirrorLineY panel_Char		
-- 			formatProps ControlMoveAndResizeClass.LockControl
			Panel_Char.controls.add(IMirrorLineY)
			IMirrorLineY.Visible = false
			IMirrorLineY.Contextmenu = undefined
			dotnet.SetlifetimeControl IMirrorLineY #dotNet 
 			--Form.controls.add(Panel_Char)
			
			SplitContainer.Panel1.Controls.add(Panel_Char)
			
			--Panel_Char.Controls.Add(Panel_Char_ImageBox)
-- 			Panel_Char_ImageBox.Enabled = false
			--Panel_Char_ImageBox.SendToBack
-- 			Panel_Char_ImageBox
				--formatprops Panel_Char
				--Panel_Char.SendToBack()
				--PropertiesPanel.BringToFront()
			dotNet.addEventHandler Panel_Char "MouseDown" Panel_Char_MouseDown
			dotNet.addEventHandler Panel_Char "MouseUp" Panel_Char_MouseUp
			dotnet.SetlifetimeControl Panel_Char #dotNet
			dotNet.addEventHandler Form "KeyDown" Form_KeyDown
			dotNet.addEventHandler Form "SizeChanged" Form_SizeChanged
			
-- 			dotNet.addEventHandler Form "KeyPress" Form_KeyDown
-- 			dotNet.addEventHandler Form "KeyUp" Form_KeyDown
-- 			dotNet.addEventHandler Form "PreviewKeyDown" Form_KeyDown
			
			
			Form.KeyPreview = true
			Form.Show(theHwnd)
			
			dotnet.SetlifetimeControl Form #dotNet 
			
-- 			formatprops Form
-- 			
			
			--Form.show() --show the Form with the Button
		)
	/*----------------------------------------------------------------------------*/
	/*------------------Main Program Function-------------------------------------*/
	/*-----------------------------------------------------------------------------------------------*/
	MainProgram = InitUI()

)/*END Program-----------------------------------------------------------------------------------------------*/




