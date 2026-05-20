global MaxTool_LoadMenus

fn MaxTool_LoadMenus =
(
    fileIn (MAX_TOOL_ROOT + @"\help\help_menu.ms")
    fileIn (MAX_TOOL_ROOT + @"\rig\rig_menu.ms")
    fileIn (MAX_TOOL_ROOT + @"\mesh\mesh_menu.ms")

    format "[MaxTool] Module menus loaded\n"
)
