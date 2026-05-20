python.Init()
(
	if ((menuMan.findMenu "BipedAnimTool") != undefined) then
	(
		menuMan.unRegisterMenu (menuMan.findMenu "BipedAnimTool")
		menuMan.updateMenuBar()
	)


	macroScript BipedAnimTool_01 category:"BipedAnimTool_01" buttonText: "动画重定向"
	(
		--filein ((getDir #scripts) + @"\MaxSendUnreal\FbxExporter_struat.ms")
		python.ExecuteFile((getDir #scripts) + "\\Joe_Anim_Picker\\BipedAinmPicker_FBXmap_OpenUI.py")
	)


	Main = menuMan.getMainMenuBar()
	Menu = menuMan.createMenu "BipedAnimTool"
	theSubMenu = menuMan.createSubMenuItem "BipedAnimTool" Menu
	Main.addItem theSubMenu (Main.numItems()+1)

	Action = menuMan.createActionItem "BipedAnimTool_01" "BipedAnimTool_01"
	Menu.addItem Action (Menu.numItems() + 1 )


	menuMan.updateMenuBar()
)
