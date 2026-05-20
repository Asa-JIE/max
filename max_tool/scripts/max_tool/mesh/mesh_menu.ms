macroScript MaxTool_Mesh_Action
category:"MaxTool"
toolTip:"Mesh"
buttonText:"Mesh"
(
    messageBox "mesh menu loaded"
)

local meshAction = menuMan.createActionItem "MaxTool_Mesh_Action" "MaxTool"

MaxTool_RegisterAction "mesh" meshAction
