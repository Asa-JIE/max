/*
    delete_menu.ms
    SD_TOOL 菜单删除脚本

    使用方法：
    1. 把 SD_TOOL 文件夹放到 3ds Max 的 scripts 目录下
    2. 把 delete_menu.ms 拖进 3ds Max 视口
    3. 顶部菜单栏中的 SDTool 菜单会被删除
    4. 之后可以再次拖 addmenu.ms 重新添加菜单
*/

(
    local menuName = "SDTool"

    fn SDTool_DeleteMenu =
    (
        try
        (
            local mainMenu = menuMan.getMainMenuBar()
            local oldMenu = menuMan.findMenu menuName

            if oldMenu != undefined then
            (
                menuMan.unRegisterMenu oldMenu
                menuMan.updateMenuBar()
                format "[SDTool] 菜单已删除，可以重新运行 addmenu.ms 二次添加。\n"
                messageBox "SDTool 菜单已删除。\n可以重新拖入 addmenu.ms 再次创建菜单。" title:"SDTool"
            )
            else
            (
                menuMan.updateMenuBar()
                format "[SDTool] 没有找到 SDTool 菜单，无需删除。\n"
                messageBox "没有找到 SDTool 菜单，无需删除。" title:"SDTool"
            )
        )
        catch
        (
            format "[SDTool] 删除菜单失败：%\n" (getCurrentException())
            messageBox ("删除 SDTool 菜单失败：\n" + (getCurrentException())) title:"SDTool Error"
        )
    )

    SDTool_DeleteMenu()
)
