
(
    if ((menuMan.findMenu "BipedAnimTool") != undefined) then
    (
        menuMan.unRegisterMenu (menuMan.findMenu "BipedAnimTool")
        menuMan.updateMenuBar()
    )

)