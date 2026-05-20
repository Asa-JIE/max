global MaxTool_MainMenu
global MaxTool_RegisterAction

fn MaxTool_RegisterAction menuName actionItem =
(
    if MaxTool_MainMenu == undefined then
    (
        format "[MaxTool][ERROR] Main menu not found\n"
        return false
    )

    local subMenu = menuMan.createMenu menuName

    subMenu.addItem actionItem -1

    local subMenuItem = menuMan.createSubMenuItem menuName subMenu

    MaxTool_MainMenu.addItem subMenuItem -1

    menuMan.updateMenuBar()

    format "[MaxTool] Registered submenu: %\n" menuName

    true
)
