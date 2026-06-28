/*
    SD_TOOL / addmenu.ms
    3ds Max 2020+

    安装方式：
    1. 把整个 SD_TOOL 文件夹复制到 3ds Max 的 scripts 目录下
       例如：C:\Program Files\Autodesk\3ds Max 2020\scripts\SD_TOOL\
    2. SD_TOOL 文件夹内放：
       - addmenu.ms
       - AsaSkinBipedBuilder_v8_ValidateFix.ms
       - Asabiach_bip_worldcopy_skeleton_framerange_fixed.ms
       - Asabonechain_bake.ms
    3. 把 addmenu.ms 拖进 3ds Max 视口运行
    4. 顶部菜单栏会出现：SDTool
*/

(
    global SDTool_RootDir
    global SDTool_FindScriptFile
    global SDTool_RunScript

    SDTool_RootDir = (getDir #scripts) + "\\SD_TOOL\\"

    fn SDTool_TrimRightSpaces s =
    (
        while (s.count > 0 and (substring s s.count 1) == " ") do
        (
            s = substring s 1 (s.count - 1)
        )
        s
    )

    fn SDTool_FindScriptFile baseName =
    (
        local folder = SDTool_RootDir

        -- 1. 优先精确匹配
        local exactFile = folder + baseName + ".ms"
        if doesFileExist exactFile do return exactFile

        -- 2. 兼容文件名末尾有空格的情况，例如：AsaSkinBipedBuilder_v8_ValidateFix .ms
        local looseFiles = getFiles (folder + baseName + "*.ms")
        if looseFiles.count > 0 do return looseFiles[1]

        -- 3. 兼容用户手动改名后可能残留空格
        local trimFile = folder + (SDTool_TrimRightSpaces baseName) + ".ms"
        if doesFileExist trimFile do return trimFile

        undefined
    )

    fn SDTool_RunScript baseName toolName =
    (
        local msFile = SDTool_FindScriptFile baseName

        if msFile == undefined then
        (
            messageBox ("没有找到脚本文件：\n\n" + SDTool_RootDir + baseName + ".ms\n\n请确认 SD_TOOL 文件夹是否放在 3ds Max scripts 目录下，并确认文件名是否正确。") title:("SDTool - " + toolName)
            return false
        )

        try
        (
            fileIn msFile
            true
        )
        catch
        (
            messageBox ("脚本运行失败：\n\n" + msFile + "\n\n错误信息：\n" + (getCurrentException())) title:("SDTool - " + toolName)
            false
        )
    )

    macroScript SDTool_01_SkinMigration
        category:"SDTool"
        buttonText:"蒙皮迁移"
        tooltip:"蒙皮迁移"
    (
        on execute do
        (
            SDTool_RunScript "AsaSkinBipedBuilder_v8_ValidateFix" "蒙皮迁移"
        )
    )

    macroScript SDTool_02_DataCopy
        category:"SDTool"
        buttonText:"数据拷贝"
        tooltip:"数据拷贝"
    (
        on execute do
        (
            SDTool_RunScript "Asabiach_bip_worldcopy_skeleton_framerange_fixed" "数据拷贝"
        )
    )

    macroScript SDTool_03_BoneBake
        category:"SDTool"
        buttonText:"骨骼结算"
        tooltip:"骨骼结算"
    (
        on execute do
        (
            SDTool_RunScript "Asabonechain_bake" "骨骼结算"
        )
    )

    -- 删除旧菜单，避免重复创建
    local oldMenu = menuMan.findMenu "SDTool"
    if oldMenu != undefined do
    (
        menuMan.unRegisterMenu oldMenu
        menuMan.updateMenuBar()
    )

    -- 创建顶部菜单 SDTool
    local mainMenu = menuMan.getMainMenuBar()
    local sdMenu = menuMan.createMenu "SDTool"
    local sdSubMenu = menuMan.createSubMenuItem "SDTool" sdMenu

    mainMenu.addItem sdSubMenu (mainMenu.numItems() + 1)

    -- 添加三个按钮
    local actSkin = menuMan.createActionItem "SDTool_01_SkinMigration" "SDTool"
    local actCopy = menuMan.createActionItem "SDTool_02_DataCopy" "SDTool"
    local actBake = menuMan.createActionItem "SDTool_03_BoneBake" "SDTool"

    sdMenu.addItem actSkin (sdMenu.numItems() + 1)
    sdMenu.addItem actCopy (sdMenu.numItems() + 1)
    sdMenu.addItem actBake (sdMenu.numItems() + 1)

    menuMan.updateMenuBar()

    format "[SDTool] 菜单创建完成。路径：%\n" SDTool_RootDir
)
