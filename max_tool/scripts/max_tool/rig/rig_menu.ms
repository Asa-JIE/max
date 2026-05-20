macroScript MaxTool_Rig_Action
category:"MaxTool"
toolTip:"Rig"
buttonText:"Rig"
(
    messageBox "rig menu loaded"
)

local rigAction = menuMan.createActionItem "MaxTool_Rig_Action" "MaxTool"

MaxTool_RegisterAction "rig" rigAction
