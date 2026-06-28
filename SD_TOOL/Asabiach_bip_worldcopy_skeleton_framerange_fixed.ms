try(destroyDialog rolBatchBipFbxMerge)catch()

rollout rolBatchBipFbxMerge "Batch BIP + FBX Extra Anim Merge - Max2020" width:620 height:585
(
    editText edtRigMax "bip_rig.max:" text:@"" width:455 across:2
    button btnPickRig "选择" width:70

    editText edtBipDir "BIP目录:" text:@"D:\testbip\" width:455 across:2
    button btnPickBip "选择" width:70

    editText edtFbxDir "FBX目录:" text:@"D:\testfbx\" width:455 across:2
    button btnPickFbx "选择" width:70

    editText edtOutDir "输出目录:" text:@"D:\test\output\" width:455 across:2
    button btnPickOut "选择" width:70

    checkbox chkSaveMax "输出 MAX" checked:true across:3
    checkbox chkExportFbx "输出 FBX" checked:true
    checkbox chkSkipExist "跳过已存在" checked:false

    checkbox chkCopyExtraAnim "拷贝其他组件动画（披风/布料/挂件/Dummy）" checked:true width:300

    label lblMode "勾选：主体BIP + 额外FBX骨骼动画；不勾选：只处理主体BIP，FBX仅用于同名匹配" width:585

    button btnRefresh "刷新匹配列表" width:580 height:28
    listBox lbFiles "匹配到的动画:" width:580 height:16

    button btnRun "开始批量生成" width:580 height:36
    listBox lbLog "日志:" width:580 height:12

    local arrPairs = #()
    local srcPrefix = "SRC_"
    local dstTempPrefix = "__DST_KEEP__"

    fn logMsg msg =
    (
        local a = lbLog.items
        append a msg
        lbLog.items = a
        lbLog.selection = a.count
        format "%\n" msg
    )

    fn ensureSlash p =
    (
        if p == "" then p
        else
        (
            local lastChar = substring p p.count 1
            if lastChar != "\\" then p + "\\" else p
        )
    )

    fn ensureDir p =
    (
        if not doesDirectoryExist p do makeDir p
    )

    fn getBipedRootNode =
    (
        for n in objects where classof n == Biped_Object do
        (
            return n.controller.rootnode
        )
        undefined
    )


    fn bsUpdateRangeByTime tm rangeArr =
    (
        if tm != undefined do
        (
            if (rangeArr[1] == undefined or tm < rangeArr[1]) do rangeArr[1] = tm
            if (rangeArr[2] == undefined or tm > rangeArr[2]) do rangeArr[2] = tm
        )
    )

    fn bsScanControllerKeys ctrl rangeArr =
    (
        if ctrl == undefined then return false

        try
        (
            local nk = numKeys ctrl
            if nk > 0 do
            (
                for k = 1 to nk do
                (
                    try
                    (
                        local kk = getKey ctrl k
                        bsUpdateRangeByTime kk.time rangeArr
                    )catch()
                )
            )
        )catch()

        try
        (
            local ns = numSubs ctrl
            if ns > 0 do
            (
                for s = 1 to ns do
                (
                    try(bsScanControllerKeys (getSubAnim ctrl s) rangeArr)catch()
                )
            )
        )catch()

        true
    )

    fn getBipLoadedFrameRange fallbackStart fallbackEnd =
    (
        -- BIP 加载后 Max 的 animationRange 有时仍停在默认 0-100。
        -- 这里直接扫描 Biped 节点控制器 key 的最小/最大时间，作为真实导出帧范围。
        local rangeArr = #(undefined, undefined)

        for n in objects where classof n == Biped_Object do
        (
            try(bsScanControllerKeys n.controller rangeArr)catch()
            try(bsScanControllerKeys n.transform.controller rangeArr)catch()
        )

        if (rangeArr[1] != undefined and rangeArr[2] != undefined) then
            #(rangeArr[1], rangeArr[2])
        else
            #(fallbackStart, fallbackEnd)
    )

    fn isBipedObj n =
    (
        try(classof n == Biped_Object)catch(false)
    )

    fn isExtraBoneClass n =
    (
        if n == undefined then return false

        if classof n == BoneGeometry then return true
        if classof n == Dummy then return true
        if classof n == Point then return true

        false
    )

    fn isExtraBoneNode n =
    (
        if n == undefined then return false
        if isBipedObj n then return false
        if matchPattern n.name pattern:(srcPrefix + "*") then return false
        if matchPattern n.name pattern:(dstTempPrefix + "*") then return false

        isExtraBoneClass n
    )

    fn collectRigExtraNodes =
    (
        local arr = #()

        for n in objects do
        (
            if isValidNode n and isExtraBoneNode n do
            (
                append arr n
            )
        )

        arr
    )

    fn protectDstExtraNames extraNodes =
    (
        -- 导入源FBX前，先临时改名目标披风/布料骨骼，避免FBX导入时同名被Max自动改成 xxx001
        local records = #()

        for n in extraNodes do
        (
            if isValidNode n do
            (
                local oldName = n.name
                append records #(n, oldName)
                try(n.name = dstTempPrefix + oldName)catch()
            )
        )

        records
    )

    fn restoreDstExtraNames records =
    (
        for r in records do
        (
            local n = r[1]
            local oldName = r[2]

            if isValidNode n do
            (
                try(n.name = oldName)catch()
            )
        )
    )

    fn markImportedNodes beforeNodes prefix =
    (
        local imported = #()

        for n in objects do
        (
            if (findItem beforeNodes n) == 0 do
            (
                append imported n
            )
        )

        for n in imported do
        (
            try(n.name = prefix + n.name)catch()
        )

        imported
    )

    fn copySameNameExtraAnimWorld importedNodes prefix startF endF =
    (
        local copied = 0
        local skipped = 0

        -- World Transform 直拷：
        -- 目标：披风/布料骨骼在最终动画里的世界位置/旋转与源FBX一致。
        for srcNode in importedNodes do
        (
            if isValidNode srcNode do
            (
                if matchPattern srcNode.name pattern:(prefix + "*") do
                (
                    local dstName = substituteString srcNode.name prefix ""
                    local dstNode = getNodeByName dstName

                    if dstNode != undefined and isExtraBoneNode dstNode then
                    (
                        for t = startF to endF do
                        (
                            sliderTime = t
                            at time t with animate on
                            (
                                dstNode.transform = srcNode.transform
                            )
                        )

                        copied += 1
                        logMsg ("[COPY WORLD] " + srcNode.name + " -> " + dstNode.name)
                    )
                    else
                    (
                        skipped += 1
                        logMsg ("[SKIP] 找不到同名目标Extra骨骼: " + srcNode.name)
                    )
                )
            )
        )

        #(copied, skipped)
    )

    fn selectExportNodes =
    (
        clearSelection()

        -- 只导出骨骼动画：Biped 主体骨骼 + 披风/布料等 Extra 骨骼。
        -- 不再选择 GeometryClass，避免把 Skin Mesh / 模型导出到 FBX。
        for n in objects do
        (
            if isValidNode n do
            (
                if classof n == Biped_Object or classof n == BoneGeometry or classof n == Dummy or classof n == Point do
                (
                    if not matchPattern n.name pattern:(srcPrefix + "*") do
                    (
                        selectMore n
                    )
                )
            )
        )
    )

    fn refreshPairs =
    (
        arrPairs = #()

        local bipDir = ensureSlash edtBipDir.text
        local fbxDir = ensureSlash edtFbxDir.text

        local bipFiles = getFiles (bipDir + "*.bip")
        local listItems = #()

        for bip in bipFiles do
        (
            local base = getFilenameFile bip
            local fbx = fbxDir + base + ".fbx"

            if not doesFileExist fbx do
            (
                fbx = fbxDir + base + ".FBX"
            )

            if doesFileExist fbx then
            (
                append arrPairs #(base, bip, fbx)
                append listItems (base + "    [OK]")
            )
            else
            (
                append listItems (base + "    [缺少FBX]")
            )
        )

        lbFiles.items = listItems
        logMsg ("刷新完成，匹配成功: " + arrPairs.count as string + " 个")
    )

    fn processOne pair =
    (
        local base = pair[1]
        local bipFile = pair[2]
        local srcFbxFile = pair[3]
        local rigMaxFile = edtRigMax.text

        local outRoot = ensureSlash edtOutDir.text
        local outMaxDir = outRoot + "MAX\\"
        local outFbxDir = outRoot + "FBX\\"

        ensureDir outRoot
        ensureDir outMaxDir
        ensureDir outFbxDir

        local outMaxFile = outMaxDir + base + ".max"
        local outFbxFile = outFbxDir + base + ".fbx"

        if chkSkipExist.checked do
        (
            if ((not chkSaveMax.checked or doesFileExist outMaxFile) and (not chkExportFbx.checked or doesFileExist outFbxFile)) then
            (
                logMsg ("跳过已存在: " + base)
                return true
            )
        )

        logMsg ("开始处理: " + base)

        resetMaxFile #noPrompt
        loadMaxFile rigMaxFile useFileUnits:true quiet:true

        local bipRoot = getBipedRootNode()
        if bipRoot == undefined then
        (
            logMsg ("ERROR: 未找到 Biped Root: " + base)
            return false
        )

        -- 1. 主体动画来自 BIP
        biped.loadBipFile bipRoot.controller bipFile #noRedraw

        -- 帧范围必须以 BIP Motion File 为准。
        -- 有些 Max/Biped 场景加载 BIP 后 animationRange 不会自动变更，仍然保持 0-100，
        -- 所以这里扫描 Biped key 的真实范围，再强制写回 animationRange。
        local rangePair = getBipLoadedFrameRange animationRange.start animationRange.end
        local startF = rangePair[1]
        local endF = rangePair[2]
        animationRange = interval startF endF

        logMsg ("BIP真实帧范围: " + startF as string + " - " + endF as string)

        -- 2. 额外组件动画开关
        -- 勾选：导入源FBX，把披风/布料/挂件/Dummy等同名骨骼动画按World Transform逐帧拷贝到rig。
        -- 不勾选：不导入源FBX，只保留BIP主体动画；源FBX只在刷新列表时用于同名匹配。
        if chkCopyExtraAnim.checked then
        (
            logMsg "[模式] 主体BIP + 额外FBX骨骼动画"

            -- 导入源FBX前保护目标Extra骨骼名称，避免同名导入被Max自动改名
            local dstExtras = collectRigExtraNodes()
            local dstNameRecords = protectDstExtraNames dstExtras

            local beforeNodes = objects as array

            FbxImporterSetParam "Mode" #merge
            FbxImporterSetParam "Animation" true
            FbxImporterSetParam "FillTimeline" false
            FbxImporterSetParam "BakeAnimationLayers" false
            FbxImporterSetParam "PointCache" false

            importFile srcFbxFile #noPrompt using:FBXIMP

            -- 帧数始终由BIP决定
            animationRange = interval startF endF

            -- 导入源节点加SRC_前缀
            local srcNodes = markImportedNodes beforeNodes srcPrefix

            -- 恢复目标Extra骨骼原名，这样 SRC_xxx 可以找到目标 xxx
            restoreDstExtraNames dstNameRecords

            -- Extra骨骼动画：World Transform 逐帧直拷
            local result = copySameNameExtraAnimWorld srcNodes srcPrefix startF endF

            -- 删除源FBX临时节点
            delete srcNodes

            logMsg ("Extra复制(World): copied=" + result[1] as string + " skipped=" + result[2] as string)
        )
        else
        (
            logMsg "[模式] 仅主体BIP动画；跳过源FBX导入与额外组件动画拷贝"
            animationRange = interval startF endF
        )

        if chkSaveMax.checked do
        (
            saveMaxFile outMaxFile quiet:true
            logMsg ("保存MAX: " + outMaxFile)
        )

        if chkExportFbx.checked do
        (
            FBXExporterSetParam "Animation" true
            FBXExporterSetParam "BakeAnimation" true
            FBXExporterSetParam "BakeResampleAnimation" false
            FBXExporterSetParam "BakeFrameStart" startF
            FBXExporterSetParam "BakeFrameEnd" endF
            FBXExporterSetParam "Cameras" false
            FBXExporterSetParam "Lights" false
            FBXExporterSetParam "EmbedTextures" false
            FBXExporterSetParam "AxisConversionMethod" "None"
            FBXExporterSetParam "UpAxis" "Y"
            FBXExporterSetParam "ShowWarnings" true
            FBXExporterSetParam "GenerateLog" false
            FBXExporterSetParam "ASCII" false

            selectExportNodes()
            exportFile outFbxFile #noPrompt selectedOnly:true using:FBXEXP
            logMsg ("导出FBX: " + outFbxFile)
        )

        logMsg ("完成: " + base)
        true
    )

    on btnPickRig pressed do
    (
        local f = getOpenFileName caption:"选择 bip_rig.max" types:"MAX (*.max)|*.max|"
        if f != undefined do edtRigMax.text = f
    )

    on btnPickBip pressed do
    (
        local d = getSavePath caption:"选择 BIP 目录"
        if d != undefined do edtBipDir.text = ensureSlash d
    )

    on btnPickFbx pressed do
    (
        local d = getSavePath caption:"选择 FBX 目录"
        if d != undefined do edtFbxDir.text = ensureSlash d
    )

    on btnPickOut pressed do
    (
        local d = getSavePath caption:"选择输出目录"
        if d != undefined do edtOutDir.text = ensureSlash d
    )

    on btnRefresh pressed do
    (
        refreshPairs()
    )

    on btnRun pressed do
    (
        if edtRigMax.text == "" or not doesFileExist edtRigMax.text then
        (
            messageBox "请先选择有效的 bip_rig.max" title:"ERROR"
            return false
        )

        refreshPairs()

        if arrPairs.count == 0 then
        (
            messageBox "没有匹配到 bip + fbx 文件" title:"ERROR"
            return false
        )

        for i = 1 to arrPairs.count do
        (
            processOne arrPairs[i]
        )

        messageBox "批量处理完成" title:"DONE"
    )
)

createDialog rolBatchBipFbxMerge
