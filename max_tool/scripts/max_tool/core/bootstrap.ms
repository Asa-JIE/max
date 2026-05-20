try
(
    fileIn (MAX_TOOL_ROOT + @"\menu_system\main_menu.ms")
    fileIn (MAX_TOOL_ROOT + @"\menu_system\menu_register.ms")
    fileIn (MAX_TOOL_ROOT + @"\menu_system\menu_loader.ms")

    MaxTool_CreateMainMenu()
    MaxTool_LoadMenus()

    menuMan.updateMenuBar()

    format "[MaxTool] bootstrap success\n"
)
catch e
(
    format "[MaxTool][ERROR] bootstrap failed: %\n" e
)
