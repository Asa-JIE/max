try(destroyDialog rolBatchBipToFBX)catch()

rollout rolBatchBipToFBX "Batch BIP To FBX - Max2020" width:560 height:560
(
    editText edtBipFolder "BIP???:" text:"" width:410 across:2
    button btnPickBip "??" width:80

    editText edtOutFolder "FBX??:" text:"" width:410 across:2
    button btnPickOut "??" width:80

    editText edtBipRoot "Biped Root?:" text:"Bip001" width:220

    checkbox chkRecursive "??????" checked:false

    spinner spnStart "Start:" range:[-99999,99999,0] type:#integer width:160
    spinner spnEnd "End:" range:[-99999,99999,100] type:#integer width:160

    button btnRun "?????? FBX" width:520 height:36

    listBox lbLog "??" width:530 height:18

    fn logMsg msg =
    (
        lbLog.items = append lbLog.items msg
        lbLog.selection = lbLog.items.count
        format "%\n" msg
    )

    fn getBipFiles folder recursive:false =
    (
        local result = #()

        if not doesDirectoryExist folder do return result

        join result (getFiles (folder + "\\*.bip"))

        if recursive do
        (
            local dirs = getDirectories (folder + "\\*")
            for d in dirs do
            (
                join result (getBipFiles d recursive:true)
            )
        )

        result
    )

    fn getAllChildrenUnderRoot rootNode includeRoot:true =
    (
        local result = #()
        local stack = #()

        if not isValidNode rootNode do return result

        if includeRoot do
        (
            appendIfUnique result rootNode
        )

        for c in rootNode.children do
        (
            append stack c
        )

        while stack.count > 0 do
        (
            local n = stack[stack.count]
            deleteItem stack stack.count

            if isValidNode n do
            (
                appendIfUnique result n

                for c in n.children do
                (
                    append stack c
                )
            )
        )

        result
    )

    fn loadBipAnim bipRoot bipFile =
    (
        local ok = false

        try
        (
            biped.loadBipFile bipRoot.controller bipFile
            ok = true
        )
        catch
        (
            format "[ERROR] Load BIP failed: %\n" (getCurrentException())
            ok = false
        )

        if ok do
        (
            sliderTime = animationRange.start
            completeRedraw()
        )

        ok
    )

    fn setupFBXExport startFrame endFrame =
    (
        try(FBXExporterSetParam "ResetExport")catch()

        try(FBXExporterSetParam "Animation" true)catch()
        try(FBXExporterSetParam "BakeAnimation" true)catch()
        try(FBXExporterSetParam "BakeFrameStart" startFrame)catch()
        try(FBXExporterSetParam "BakeFrameEnd" endFrame)catch()
        try(FBXExporterSetParam "BakeFrameStep" 1)catch()

        try(FBXExporterSetParam "Cameras" false)catch()
        try(FBXExporterSetParam "Lights" false)catch()
        try(FBXExporterSetParam "EmbedTextures" false)catch()

        try(FBXExporterSetParam "SmoothingGroups" true)catch()
        try(FBXExporterSetParam "SmoothMeshExport" true)catch()
        try(FBXExporterSetParam "TangentsandBinormals" true)catch()
        try(FBXExporterSetParam "Preserveinstances" false)catch()

        try(FBXExporterSetParam "SelectionSetExport" false)catch()
    )

    fn exportFBX outFile exportNodes startFrame endFrame =
    (
        clearSelection()
        select exportNodes

        setupFBXExport startFrame endFrame

        exportFile outFile #noPrompt selectedOnly:true using:FBXEXP
    )

    on rolBatchBipToFBX open do
    (
        spnStart.value = animationRange.start.frame as integer
        spnEnd.value = animationRange.end.frame as integer
    )

    on btnPickBip pressed do
    (
        local p = getSavePath caption:"?? BIP ???"
        if p != undefined do edtBipFolder.text = p
    )

    on btnPickOut pressed do
    (
        local p = getSavePath caption:"?? FBX ?????"
        if p != undefined do edtOutFolder.text = p
    )

    on btnRun pressed do
    (
        lbLog.items = #()

        local bipFolder = edtBipFolder.text
        local outFolder = edtOutFolder.text
        local rootName = edtBipRoot.text

        if bipFolder == "" or not doesDirectoryExist bipFolder then
        (
            messageBox "?????? BIP ???"
            return false
        )

        if outFolder == "" then
        (
            outFolder = bipFolder + "\\fbx"
            edtOutFolder.text = outFolder
        )

        if not doesDirectoryExist outFolder do makeDir outFolder

        local bipRoot = getNodeByName rootName

        if not isValidNode bipRoot then
        (
            messageBox ("??? Biped Root: " + rootName)
            return false
        )

        local bipFiles = getBipFiles bipFolder recursive:chkRecursive.checked

        if bipFiles.count == 0 then
        (
            messageBox "???? .bip ??"
            return false
        )

        local startFrame = spnStart.value as integer
        local endFrame = spnEnd.value as integer

        animationRange = interval startFrame endFrame

        logMsg ("BIP??: " + bipFiles.count as string)
        logMsg ("Frame: " + startFrame as string + " - " + endFrame as string)

        local success = 0
        local failed = 0

        disableSceneRedraw()

        for bipFile in bipFiles do
        (
            try
            (
                local name = getFilenameFile bipFile
                local outFile = outFolder + "\\" + name + ".fbx"

                logMsg "--------------------------------"
                logMsg ("Load BIP: " + bipFile)

                if loadBipAnim bipRoot bipFile then
                (
                    local exportNodes = getAllChildrenUnderRoot bipRoot includeRoot:true

                    logMsg ("Export????: " + exportNodes.count as string)

                    if exportNodes.count == 0 then
                    (
                        failed += 1
                        logMsg "[FAILED] Bip001??????"
                    )
                    else
                    (
                        exportFBX outFile exportNodes startFrame endFrame

                        success += 1
                        logMsg ("[OK] " + outFile)
                    )
                )
                else
                (
                    failed += 1
                )
            )
            catch
            (
                failed += 1
                logMsg ("[ERROR] " + bipFile)
                logMsg (getCurrentException())
            )
        )

        enableSceneRedraw()

        logMsg "================================"
        logMsg ("Success: " + success as string)
        logMsg ("Failed : " + failed as string)

        messageBox ("??\nSuccess: " + success as string + "\nFailed: " + failed as string)
    )
)

createDialog rolBatchBipToFBX