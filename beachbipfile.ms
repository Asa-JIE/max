try(destroyDialog rolBatchBipToFBX)catch()

rollout rolBatchBipToFBX "Batch BIP To FBX - Max2020" width:560 height:560
(
    editText edtBipFolder "BIP Folder:" text:"" width:410 across:2
    button btnPickBip "Pick" width:80

    editText edtOutFolder "FBX Out:" text:"" width:410 across:2
    button btnPickOut "Pick" width:80

    editText edtBipRoot "Biped Root:" text:"Bip001" width:220

    checkbox chkRecursive "Recursive" checked:false

    spinner spnStart "Fallback Start:" range:[-99999,99999,0] type:#integer width:160
    spinner spnEnd "Fallback End:" range:[-99999,99999,100] type:#integer width:160

    button btnRun "Batch Export FBX" width:520 height:36

    listBox lbLog "Log" width:530 height:18

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
            for d in dirs do join result (getBipFiles d recursive:true)
        )

        result
    )

    fn getAllChildrenUnderRoot rootNode includeRoot:true =
    (
        local result = #()
        local stack = #()

        if not isValidNode rootNode do return result

        if includeRoot do appendIfUnique result rootNode

        for c in rootNode.children do append stack c

        while stack.count > 0 do
        (
            local n = stack[stack.count]
            deleteItem stack stack.count

            if isValidNode n do
            (
                appendIfUnique result n
                for c in n.children do append stack c
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

    fn collectKeyTimesFromController ctrl timeArr =
    (
        if ctrl == undefined do return timeArr

        try
        (
            local nk = numKeys ctrl
            if nk > 0 do
            (
                for i = 1 to nk do
                (
                    local t = getKeyTime ctrl i
                    appendIfUnique timeArr t
                )
            )
        )catch()

        try
        (
            for i = 1 to ctrl.numSubs do
            (
                collectKeyTimesFromController ctrl[i] timeArr
            )
        )catch()

        timeArr
    )

    fn getAnimRangeFromNodes nodes fallbackStart fallbackEnd =
    (
        local times = #()

        for n in nodes do
        (
            if isValidNode n do
            (
                try(collectKeyTimesFromController n.controller times)catch()
                try(collectKeyTimesFromController n.transform.controller times)catch()
                try(collectKeyTimesFromController n.position.controller times)catch()
                try(collectKeyTimesFromController n.rotation.controller times)catch()
                try(collectKeyTimesFromController n.scale.controller times)catch()
            )
        )

        if times.count == 0 then
        (
            interval fallbackStart fallbackEnd
        )
        else
        (
            local tMin = times[1]
            local tMax = times[1]

            for t in times do
            (
                if t < tMin do tMin = t
                if t > tMax do tMax = t
            )

            interval tMin tMax
        )
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
        local p = getSavePath caption:"Pick BIP Folder"
        if p != undefined do edtBipFolder.text = p
    )

    on btnPickOut pressed do
    (
        local p = getSavePath caption:"Pick FBX Output Folder"
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
            messageBox "Please pick BIP folder"
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
            messageBox ("Cannot find Biped Root: " + rootName)
            return false
        )

        local bipFiles = getBipFiles bipFolder recursive:chkRecursive.checked

        if bipFiles.count == 0 then
        (
            messageBox "No .bip files found"
            return false
        )

        local fallbackStart = spnStart.value as integer
        local fallbackEnd = spnEnd.value as integer

        logMsg ("BIP Count: " + bipFiles.count as string)

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

                    logMsg ("Export Nodes: " + exportNodes.count as string)

                    if exportNodes.count == 0 then
                    (
                        failed += 1
                        logMsg "[FAILED] No export nodes"
                    )
                    else
                    (
                        local bipRange = getAnimRangeFromNodes exportNodes fallbackStart fallbackEnd

                        local realStart = bipRange.start.frame as integer
                        local realEnd = bipRange.end.frame as integer

                        animationRange = interval realStart realEnd
                        sliderTime = realStart

                        logMsg ("BIP Real Frame: " + realStart as string + " - " + realEnd as string)

                        exportFBX outFile exportNodes realStart realEnd

                        success += 1
                        logMsg ("[OK] " + outFile)
                    )
                )
                else
                (
                    failed += 1
                    logMsg "[FAILED] Load BIP failed"
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

        messageBox ("Done\nSuccess: " + success as string + "\nFailed: " + failed as string)
    )
)

createDialog rolBatchBipToFBX
