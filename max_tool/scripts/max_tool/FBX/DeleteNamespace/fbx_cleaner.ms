try(destroyDialog Asa_FBXCleaner_Rollout)catch()

rollout Asa_FBXCleaner_Rollout "Asa FBX Cleaner" width:420 height:260
(
    local fbxPath = ""
    local scriptRoot = getFilenamePath (getSourceFileName())

    button btnPick "选择 FBX" width:380 height:30 pos:[20,20]
    editText edtFbx "" width:380 height:22 pos:[20,60] readonly:true

    checkbox chkNamespace "移除 Namespace" checked:true pos:[20,95]
    checkbox chkUdp3dsmax "删除 UDP3DSMAX 属性" checked:true pos:[20,120]
    checkbox chkNoExport "删除 no_export / no_anim_export 属性" checked:true pos:[20,145]

    editText edtRemoveNodes "删除节点名，逗号分隔" width:380 height:22 pos:[20,175]

    button btnRun "执行清理并另存" width:380 height:35 pos:[20,210]

    fn pyPath p =
    (
        substituteString p "\\" "/"
    )

    on btnPick pressed do
    (
        local p = getOpenFileName caption:"选择 FBX 文件" types:"FBX (*.fbx)|*.fbx|"
        if p != undefined do
        (
            fbxPath = p
            edtFbx.text = p
        )
    )

    on btnRun pressed do
    (
        if fbxPath == "" then
        (
            messageBox "请先选择 FBX 文件"
            return()
        )

        local outPath = getSaveFileName caption:"另存清理后的 FBX" types:"FBX (*.fbx)|*.fbx|"
        if outPath == undefined then return()

        local removeNodes = edtRemoveNodes.text

        local pyCode = ""
        pyCode += "import sys\n"
        pyCode += "script_root = r'" + (pyPath scriptRoot) + "'\n"
        pyCode += "if script_root not in sys.path:\n"
        pyCode += "    sys.path.append(script_root)\n"

        pyCode += "import fbx_namespace_cleaner\n"
        pyCode += "reload(fbx_namespace_cleaner)\n"

        pyCode += "fbx_namespace_cleaner.clean_fbx(\n"
        pyCode += "    input_path=r'" + (pyPath fbxPath) + "',\n"
        pyCode += "    output_path=r'" + (pyPath outPath) + "',\n"
        pyCode += "    remove_namespace=" + (if chkNamespace.checked then "True" else "False") + ",\n"

        pyCode += "    remove_udp3dsmax=" + (if chkUdp3dsmax.checked then "True" else "False") + ",\n"

        pyCode += "    remove_no_export=" + (if chkNoExport.checked then "True" else "False") + ",\n"

        if removeNodes != "" then
        (
            pyCode += "    remove_node_names=r'" + removeNodes + "'.split(','),\n"
        )
        else
        (
            pyCode += "    remove_node_names=[] ,\n"
        )

        pyCode += ")\n"

        print pyCode

        python.Execute pyCode

        messageBox "处理完成"
    )
)

createDialog Asa_FBXCleaner_Rollout