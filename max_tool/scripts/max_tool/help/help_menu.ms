macroScript MaxTool_Help_Action
category:"MaxTool"
toolTip:"Help"
buttonText:"Help"
(
    messageBox "max_tool 加载成功"
)

local helpAction = menuMan.createActionItem "MaxTool_Help_Action" "MaxTool"

MaxTool_RegisterAction "help" helpAction
