global MaxTool_MainMenu
global MaxTool_CreateMainMenu

fn MaxTool_CreateMainMenu =
(
    local menuBar = menuMan.getMainMenuBar()

    local oldMenu = menuMan.findMenu "max-tool"

    if oldMenu != undefined do
    (
        try(menuBar.removeItem oldMenu)catch()
    )

    MaxTool_MainMenu = menuMan.createMenu "max-tool"

    local mainSubMenu = menuMan.createSubMenuItem "max-tool" MaxTool_MainMenu

    menuBar.addItem mainSubMenu -1

    menuMan.updateMenuBar()

    format "[MaxTool] Main menu created\n"
)
