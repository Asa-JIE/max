--父电捞 : 捞惑盔
--荤侩 券版 : Max 2014 捞惑
-- 捞 胶农赋飘甫 荤侩窍芭唱 荐沥窍绰 巴篮 磊蜡涝聪促. 窍瘤父 犁 硅器绰 倾侩窍瘤 臼嚼聪促.
-- You can : Use, Edit
-- You cannot : ReDistribute

/*
皋葛
numKeys $.rotation.controller
numKeys $.position.controller
(getKey $.rotation.controller[1].controller 2).time
(getKey $.position.controller[1].controller 2).time
-- time, selected, value 殿殿
-- TCB, XYZ 牧飘费矾 沥档父 茄沥秦辑 瘤盔秦具且淀
*/

global SoxFbxToBiped		-- SoxFbxToBiped 费酒眶疙阑 臂肺国 函荐肺 牢侥窍扁 困秦 檬扁俊 茄 锅 荤侩

try (destroydialog SoxFbxToBiped) catch()		-- 趣矫 凯妨乐绰 SoxFbxToBiped 乐栏搁 碍力 辆丰

rollout SoxFbxToBiped "Sox Fbx to Biped v0.34" width:280
(
	button uiBtnScanRoot "Scan Root" width:60 across:5
	button uiBtnLoad "Load" width:50 offset:[10, 0]
	button uiBtnSaveAs "SaveAs" width:50 offset:[12, 0]
	button uiBtnReset "Reset" width:50 offset:[12, 0]
	button uiBtnAbout "?" width:30 offset:[16, 0]
	
	group "Options" (
		radiobuttons uiRBtnLoadingType "Loading type" labels:#("Name", "Handle") default:2
		checkbox uiCBoxAutoHide "Auto hide after Set" across:2
		checkbox uiCBoxNonBipedMode "Non Biped Mode"
-- 		checkbox uiCBoxExistingKey "Use existing keys"
-- 		spinner uiSpnThickHor "Thick. Hor." across:2
-- 		spinner uiSpnThickVer "Thick. Ver."
	)
	
	button uiBtnSetRootFbx "Set Fbx Root" across:2
	button uiBtnSetRootBip "Set Biped Root"
	
	label uiLabelRootFbx across:2
	label uiLabelRootBip
	
	button uiBtnSetFbx "Set FBX" offset:[-4, 0] across:4
	button uiBtnClearFbx "Clear FBX" offset:[-8, 0]
	button uiBtnSetBip "Set Bip" offset:[10, 0]
	button uiBtnClearBip "Clear Bip" offset:[6, 0]
	
	listbox uiLBoxFbxBip height:8
	
	button uiBtnListAdd "   +   " tooltip:"Add List" offset:[-6,0] across:4
	button uiBtnListDel "    -   " tooltip:"Remove List" offset:[-16,0]
    button uiBtnListHide "Hide List." offset:[-8,0]
    button uiBtnListUnHide "UnHide List."
	
	/*
	-- Select 弊缝篮 肋 救静绰淀窍咯 豪牢
	group "Select" (
	button uiBtnSelectFbxRoot "FBX Root" across:2
	button uiBtnSelectBipRoot "Bip Root"
	button uiBtnSelectFbx "1 FBX" across:4
	button uiBtnSelectFbxAll "All FBX"
	button uiBtnSelectBip "1 Bip"
	button uiBtnSelectBipAll "All Bip"
	)
	*/
	
	group "Figure" (
 		button uiBtnFigureSync "Figure Sync"  width:100 across:2
		spinner uiSpnFootHeight "Foot Height" range:[0, 999999, 10] tooltip:"官捞菩靛 惯狼 臭捞. 官捞菩靛 惯狼 漂己惑 惯格俊辑 惯官蹿鳖瘤 臭捞 蔼阑 瘤沥秦具茄促."
	)
	
	group "Keyframe" (
		radiobuttons uiRBtnKeyOption labels:#("Animation Range", "1 Frame") default:1 across:2
		checkbox uiChkDeleteExistingKeys "Delete existing keys" checked:true tooltip:"葛电 官捞菩靛 虐甫 昏力 饶 官捞菩靛 局聪皋捞记 虐甫 积己"
		button uiBtnKeyAll "Key All" width:100 across:2
		button uiBtnKeySelectedOne "Key Selected One" width:100
	)
	
	progressBar uiPBar height:8 color:red
	
	label uiLabelBipInfo "Biped : " align:#left across:2
	label uiLabelStatus "Status : " align:#left
	
	button uiBtnSetAnimRangeBySelectedObj "Set animation range by Selected Obj." tooltip:"急琶茄 坷宏璃飘甫 扁霖栏肺局聪皋捞记 饭牢瘤甫 函版"
	
	group "Replace name in selection" (
		edittext uiETxtReplaceFrom across:3
		edittext uiETxtReplaceTo
		button uiBtnDoReplace "Replace!"
	)

    group "Auto append name" (
		edittext uiETxtAppend "Append name" width:180 offset:[0,0] across:2
        spinner uiSpnPointSize range:[0.1,9999,10]
		button uiBtnDoAppend "Append!" offset:[0,0] tooltip:"Renames the second object based on the name of the tempFirst selected object." across:3
        button uiBtnDoAppendAlign "Apnnd Align!" offset:[0,0] tooltip:"It automatically sorts them, links them as children, and renames them. Two objects must be selected for it to work."
        button uiBtnDoAppendAlignedPoint "Apnend Point!" offset:[0,0] tooltip:"Creates point helpers that are auto-aligned and childed to the selected objects."
	)
	
	group "Add Controllers" (
		button uiBtnAddPositionConstraint "PositionConst." across:3
		button uiBtnAddLookatConstraint "LookAt."
        button uiBtnAddOrientationConstraint "Orientation"
	)

	--button uiBtnDeletePosKeys "Delete Position Keys" align:#left tooltip:"Delete the Position keys after the current frame."
-- 	button uiBtnTest "Test"
	
	-- Fbx客 Biped 茄 街阑 沥狼窍绰 备炼眉. 官捞菩靛绰 Xtra 扼带啊 Prop 捞扼带啊 窍绰 捞繁 历繁 眠啊 沥焊啊 乐阑 荐 乐澜
	struct pairDef (
		fbxObj,
		bipObj
		--bipType		-- "Root" / "Body" / "Tail" / "PonyTail" / "Prop" / "Xtra" 殿捞 啊瓷
	)
	local pairs = #()
	local rootObjFbx
	local rootObjBip
		
	struct bipType (
		limbName,
		linkIndex
	)
	
	-- trParent 肺何磐 trChild 狼 肺拿 困摹客 肺抛捞记苞 胶纳老 蔼阑 甫 府畔茄促.
	function GetLocalTransform trParent trChild = -- 涝仿 蔼篮 matrix3, 府畔 蔼篮 matrix3,
	(
		trChild*(inverse trParent)
	)
	
	-- 府胶飘俊 官捞菩靛啊 酒囱 坷宏璃飘啊 乐绰瘤 八荤. 官捞菩靛啊 酒囱 坷宏璃飘啊 乐栏搁 true 府畔
	function NonBipedCheck = (
		returnBool = false
		if ( classof rootObjBip ) != Biped_Object and rootObjBip != undefined do ( returnBool = true )

		if pairs.count == 0 do ( return returnBool )
		for o in pairs do (
			if ( classof o.bipObj ) != Biped_Object and o.bipObj != undefined do ( returnBool = true )
		)
		
		return returnBool
	)
	
	-- pairs 函荐 救俊 概莫捞 代 等 版快啊 乐绰瘤 八荤 巩力 绝栏搁 true, 巩力 乐栏搁 false 府畔
	function CheckMatch = (
		if pairs.count == 0 do return true
		for o in pairs do (
			if ( o.fbxObj == undefined and o.bipObj != undefined ) do return false
			if ( o.fbxObj != undefined and o.bipObj == undefined ) do return false
		)
		return true
	)
	
	-- 官捞菩靛 坷宏璃飘狼 X绵 胶纳老蔼 父怒狼 岿靛 器瘤记阑 舅酒晨 (Xtra 殿狼 坷宏璃飘俊辑 磊侥捞 咯返 乐阑 锭 角力 胶纳老俊 荤侩且 磊侥阑 舅酒郴扁 困窃)
	function GetLocalScaleXWorldPos bipObj = (
		tScale = biped.getTransform bipObj #scale
		tMatrix = matrix3 1
		tMatrix.pos = [tScale.x, 0, 0]
		tMatrix = tMatrix * bipObj.transform
		return tMatrix.pos
	)
	
	-- 官捞菩靛 坷宏璃飘狼 磊侥捞 咯返 乐阑 锭 X绵 胶纳老 困摹甫 扁霖栏肺 窍唱狼 磊侥阑 府畔茄促. 磊侥捞 绝芭唱 巩力啊 乐栏搁 undefined 府畔
	function GetChildByScalePos bipObj = (
		if ( (classof bipObj) != Biped_Object ) do return undefined
		if ( bipObj.children.count == 1 ) do return bipObj.children[1]
		if ( bipObj.children.count == 0 ) do return undefined
		
		tDestPos = GetLocalScaleXWorldPos bipObj		-- 捞 困摹俊 啊鳖款 磊侥捞 胶纳老狼 扁霖捞 登绰 磊侥
		
		childDistArr = #()
		tIndex = 0
		for i = 1 to bipObj.children.count do (
			append childDistArr ( distance bipObj.children[i].transform.position tDestPos )
			tMinDist = amin childDistArr
			tIndex = finditem childDistArr tMinDist
		)
		return bipObj.children[tIndex]
	)
	
	-- 府畔 胶飘钒媚狼 糕滚 : limbName, linkIndex
	function GetBipedType obj = (
		if ( obj == undefined ) do return undefined
		if ( (classof obj) != Biped_Object ) do return (bipType limbName:#nonBiped linkIndex:0)
		
		-- biped.maxNumLinks $ 捞 规过栏肺 官捞菩靛狼 弥措 傅农 荐甫 舅酒尘 荐 乐促. 焊烹 25捞瘤父 乘乘窍霸 30
		loopCount = 30
		types = #(
			#larm,
			#rarm,
			#lfingers,
			#rfingers,
			#lleg,
			#rleg,
			#ltoes,
			#rtoes,
			#spine,
			#tail,
			#head,
			#pelvis,
			#vertical,
			#horizontal,
			#turn,
			#footprints,
			#neck,
			#pony1,
			#pony2,
			#prop1,
			#prop2,
			#prop3,
			#lfArmTwist,
			#rfArmTwist,
			#lUparmTwist,
			#rUparmTwist,
			#lThighTwist,
			#rThighTwist,
			#lCalfTwist,
			#rCalfTwist,
			#lHorseTwist,
			#rHorseTwist			
		)
		
		for o in types do (
			for p = 1 to loopCount do (
				if ( try ( obj == biped.getNode obj o link:p ) catch false ) do (
					returnType = (bipType limbName:o linkIndex:p)
					return returnType
				)
			)
		)
		
		-- 官捞菩靛 努贰胶牢单 沥眉甫 舅酒郴瘤 给茄扒 葛滴 Xtra肺 沥狼
		-- https://forums.cgsociety.org/t/biped-xtra-maxscript-commands/1570351/5 见败柳 官捞菩靛 Xtra 窃荐甸阑 粱 混旗毫具且淀.
        -- biped.getXtraName $ 捞吧 窍搁 竣胶飘扼 风飘绰 捞抚阑 府畔窍绊 竣胶飘扼 风飘啊 酒聪搁 false 府畔.
        -- 弊矾唱 巩力绰 竣胶飘扼 傅农 1 捞惑何磐绰 俊矾 惯积窃. 俊矾 惯积窍绰吧 捞侩秦辑 try肺 0苞 1 捞惑 牢郸胶甫 茫绰 规过档 啊瓷且 淀. 酒公瓢 焊幅
		return (bipType limbName:#xtra linkIndex:0)
	)
		
	-- arr 硅凯俊辑 id1苞 id2 狼 郴侩阑 辑肺 第官槽促. 府畔等 硅凯篮 盔贰 硅凯阑 函版矫虐瘤 臼绰促.
	function SwapArray arr id1 id2 = (
		if arr.count < id1 or arr.count < id2 do return arr -- 肋给等 酒捞叼啊 涝仿登搁 弊成 盔贰 硅凯阑 府畔
		if id1 == id2 do return arr -- 鞍篮 锅龋狼 酒捞叼啊 涝仿登绢档 弊成 盔贰 硅凯阑 府畔茄促.
	
		if id1 > id2 do -- 硅凯 牢郸胶绰 馆靛矫 id1捞 歹 累促绰 荤角阑 扁霖栏肺 累悼秦具 茄促.
		(
			tempID = id1
			id1 = id2
			id2 = tempID
		)
	  
	-- 硅凯 汗力绰 deepcopy肺 秦具窃. 救弊矾搁 盔贰 盔夯苞 instance 包拌啊 瞪 啊瓷己捞 乐绰单
	-- 救傈窍霸 窍妨搁 deepcopy肺 汗力窍绰霸 亮澜.
		tempArr = deepcopy arr   
		tempVar = tempArr[id1]
		tempArr[id1] = tempArr[id2]
		tempArr[id2] = tempVar
	  
		return tempArr
	)
		
	function SetStatus = (
		if ( pairs.count == 0 ) do return ()
		countFbx = 0
		countBip = 0
		
		for o in pairs do (
			if ( o.fbxObj != undefined ) do ( countFbx += 1 )
			if ( o.bipObj != undefined ) do ( countBip += 1 )
		)
		
		if ( rootObjFbx != undefined ) do ( countFbx += 1 )
		if ( rootObjBip != undefined ) do ( countBip += 1 )
		
		tStr = stringstream ""
		format "Status : % FBX, % Bip" countFbx countBip to:tStr
		uiLabelStatus.text = tStr as string
	)
	
	function SetBipInfo = (
		if ( pairs.count == 0 ) do return ()
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		
		local bipType = GetBipedType pairs[uiLBoxFbxBip.selection].bipObj
		
		if ( bipType == undefined ) do ( uiLabelBipInfo.text  = "Biped : " ;return () )
		
		tStr = stringstream ""
		format "Biped : %, Link = %" bipType.limbName bipType.linkIndex to:tStr
		uiLabelBipInfo.text = tStr as string
	)
	
	-- children 阑 硅凯俊 append 秦霖促. 涝仿等 arr 磊眉啊 函版登骨肺 府畔 绝澜
	function AppendChildren arr children = (
		if ( children.count ) == 0 do return ()
		for o in children do (
			append arr o
		)
	)
	
	-- obj 狼 葛电 磊侥甸阑 硅凯肺 府畔. 硅凯 鉴辑绰 拌摸备炼 鉴辑措肺
	function GetAllChildren obj = (
		if ( obj == undefined ) do return undefined
		
		local tAllChildren = #()
		if ( obj.children.count != 0 ) do (
			for o in obj.children do (
				append tAllChildren o
				if ( o.children.count != 0 ) do (
					tAllChildren = tAllChildren +  (GetAllChildren o)		-- recursive
				)
			)
		)
		return tAllChildren
	)
	
	-- pairs 硅凯阑 措惑栏肺 拌摸备炼 鉴辑措肺 家泼 茄促. pairs 硅凯篮 葛滴 rootObjBip 狼 磊侥捞扼绰 傈力
	function SortByHierarchy = (
		if ( pairs.count == 0 ) do return ()
		
		-- 老窜 rootObjBip 狼 葛电 磊侥甸阑 掘绢柯促. 拌摸备炼 鉴辑措肺 掘绢咙. 捞饶 pairs 俊 荤侩等 巴甸父 巢扁绊 朝妨具窃
		tAllChildren = GetAllChildren rootObjBip
		
		-- pairs俊 荤侩等 官捞菩靛 坷宏璃飘 硅凯阑 烙矫肺 父电促. 拌摸备炼 鉴辑措肺啊 酒聪促.
		tBips = #()
		for i = 1 to pairs.count do (
			append tBips pairs[i].bipObj
		)
		
		for i = tAllChildren.count to 1 by -1 do (
			-- tBips 俊 粮犁窍瘤 臼绰 children 篮 tAllChildren 俊辑 力芭茄促.
			if ( (finditem tBips tAllChildren[i]) == 0 ) do (
				tAllChildren = ( deleteitem tAllChildren i )
			)
		)

		-- tBips 			pairs客 鉴辑绰 鞍栏唱 官捞菩靛父栏肺 等 硅凯
		-- tAllChildren	拌摸备炼啊 沥纺等. 弊府绊 官捞菩靛父 甸绢乐绰 硅凯
		retArr = #()
		tProps = #()		-- 橇而甸阑 漂喊贸府窍扁 困茄 烙矫 硅凯
		for i = 1 to tAllChildren.count do (
			local bipType = ( GetBipedType tAllChildren[i] ).limbName
			if ( bipType != #prop1 and bipType != #prop2 and bipType != #prop3 ) then (
				-- 橇而捞 酒囱 版快
				append retArr pairs[(finditem tBips tAllChildren[i])]
			)
			else (
				-- 橇而牢 版快
				append tProps pairs[(finditem tBips tAllChildren[i])]
			)
		)
		
		retArr = retArr + tProps		-- 橇而阑 啊厘 饶鉴困肺 教农秦具窃
		
		-- pairs 狼 官捞菩靛啊 瘤沥登瘤 臼篮 undefined 亲格甸阑 混妨滴绢具窍骨肺 retArr俊 歹秦霖促.
		for o in pairs do (
			if ( o.bipObj == undefined ) do ( append retArr o )
		)
		
		pairs = deepcopy retArr
	)
	
	function SetList = (
		-- 0.29滚傈鳖瘤绰 府胶飘 盎脚矫付促 府胶飘甫 拌摸备炼 鉴辑措肺 家泼阑 沁菌栏唱
		-- 钙胶 弥脚滚傈何磐 概快 蠢府霸 累悼窍咯 府胶飘 盎脚俊辑绰 力寇窃
		
		local items = #()
		for o = 1 to pairs.count do (
			tString = ""
			if ( pairs[o].fbxObj != undefined ) then (
				tString += pairs[o].fbxObj.name
			)
			else (
				tString += "( ... )"
			)
			tString += " --> "
			if ( pairs[o].bipObj != undefined ) then (
				tString += pairs[o].bipObj.name
			)
			else (
				tString += "( ... )"
			)
			append items tString
		)
		uiLBoxFbxBip.items = items
		
		--if ( uiLBoxFbxBip.items.count > 1 and uiLBoxFbxBip.selection == 1 ) do uiLBoxFbxBip.selection = 2
		if ( uiLBoxFbxBip.items.count > 0 and uiLBoxFbxBip.selection == 0 ) do uiLBoxFbxBip.selection = uiLBoxFbxBip.items.count
		
		tSel = uiLBoxFbxBip.selection
		uiLBoxFbxBip.selection = amin uiLBoxFbxBip.items.count (tSel + 5)
		uiLBoxFbxBip.selection = tSel
		
		SetStatus ()
		SetBipInfo ()
		if ( rootObjFbx != undefined ) then ( uiLabelRootFbx.text = rootObjFbx.name ) else ( uiLabelRootFbx.text = "" )
		if ( rootObjBip != undefined ) then ( uiLabelRootBip.text = rootObjBip.name ) else ( uiLabelRootBip.text = "" )
	)
	
	-- pairs 硅凯狼 FBX俊辑 obj 狼 困摹 锅龋甫 府畔
	function FindInPairsFbx obj = (
		local pos = 0
		for o  = 1 to pairs.count do (
			try ( if ( pairs[o].fbxObj == obj ) do pos = o ) catch ()
		)
		return pos
	)
	
	-- pairs 硅凯狼 官捞菩靛俊辑 obj 狼 困摹 锅龋甫 府畔
	function FindInPairsBip obj = (
		local pos = 0
		for o  = 1 to pairs.count do (
			try ( if ( pairs[o].bipObj == obj ) do pos = o ) catch ()
		)
		return pos
	)
	
	function SetFileStream = -- pairs 硅凯 备炼眉 函荐甸阑 葛滴 秒钦秦辑 沥秦柳 器杆栏肺 沥纺茄 第 StringStream 函荐 窍唱肺 府畔
	(
		if pairs.count == 0 do return undefined
			
		tempStr = stringStream ""
		ifStr = ""

		-- uiSpnFootHeight 狼 Foot Height 刚历 贸府
		format "FootHeight = %\n" (uiSpnFootHeight.value as string) to:tempStr
		
		for k = 1 to pairs.count do
		(
			if ( pairs[k].fbxObj != undefined ) then ( ifStr = pairs[k].fbxObj.inode.handle as string ) else ( ifStr = "undefined" )
			format "FbxObjHandle = %\n" ifStr to:tempStr
			
			if ( pairs[k].fbxObj != undefined ) then ( ifStr = pairs[k].fbxObj.name as string ) else ( ifStr = "" )
			format "FbxObjName = %\n" ifStr to:tempStr
			
			if ( pairs[k].bipObj != undefined ) then ( ifStr = pairs[k].bipObj.inode.handle as string ) else ( ifStr = "undefined" )
			format "BipObjHandle = %\n" ifStr to:tempStr
			
			if ( pairs[k].bipObj != undefined ) then ( ifStr = pairs[k].bipObj.name as string ) else ( ifStr = "" )
			format "BipObjName = %\n" ifStr to:tempStr
		)
		return tempStr
	)
	
	function CheckFileExt str = -- 胶飘傅狼 犬厘磊甫 八荤
	(
		keyword = "sftb"
		if str.count <= (keyword.count + 1) do return false
		
		tempStr = ""
		tempIndex = str.count - keyword.count + 1
		for o = tempIndex to str.count do tempStr += str[o]
		
		if (stricmp keyword tempStr) == 0 do return true
		-- if (toUpper keyword) == (toUpper tempStr) do return true -- for max 2008 or higher
		return false
	)
	
	-- obj啊 parent 狼 窍困 磊侥俊 家加登绢乐绰瘤 八荤
	function IfChild parent obj = (
		
		found = false
		checkObj = obj
		while checkObj != undefined do (
			if ( parent == checkObj ) do ( found = true )
			checkObj = checkObj.parent
		)
		return found
	)
	
	-- 纠 郴俊 鞍篮 捞抚阑 啊柳 坷宏璃飘啊 咯返 乐阑 锭 硅凯肺 葛滴 府畔
	function GetObjsByName str = (
		objs = #()
		for o in objects do (
			if ( o.name == str ) do ( append objs o )
		)
		return objs
	)
	
	-- 傈眉 纠阑 炼荤秦辑 扁粮俊 FbxRoot 瘤沥等 蜡历 橇肺欺萍甫 力芭窍绊 obj 俊 风飘扼绰 钎矫甫 茄促.
	function SetUserPropFbxRoot obj = (
		if ( objects.count == 0 ) do return ()
		if ( obj == undefined ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_FbxRoot") != undefined  ) do ( setUserProp o "SoxFbxToBiped_FbxRoot" false )
		)
		
		setUserProp obj "SoxFbxToBiped_FbxRoot" true
	)
	
	function SetUserPropBipRoot obj = (
		if ( objects.count == 0 ) do return ()
		if ( obj == undefined ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_BipRoot") != undefined  ) do ( setUserProp o "SoxFbxToBiped_BipRoot" false )
		)
		
		setUserProp obj "SoxFbxToBiped_BipRoot" true
	)

	function GetParentObj obj = (
		return (maxOps.getNodeByHandle (getUserProp obj "FBXtoBiped_FixedDistHelperParent"))
	)

	function GetTargetObj obj = (
		maxOps.getNodeByHandle (getUserProp obj "FBXtoBiped_FixedDistHelperTarget")
	)

	function GetHelperType obj = (
		return (getUserProp obj "FBXtoBiped_FixedDistHelperType")
	)

	function GetLookAtHelperByPointer obj = (
		local tUserProp = getUserProp obj "FBXtoBiped_FixedDistPointerLookAt"
		if (tUserProp == undefined) do return undefined
		return (maxOps.getNodeByHandle tUserProp)	
	)

	function GetOrientationHelperByPointer obj = (
		local tUserProp = getUserProp obj "FBXtoBiped_FixedDistPointerOrientation"
		if (tUserProp == undefined) do return undefined
		return (maxOps.getNodeByHandle tUserProp)	
	)

	-- 颊格鞍篮 何困绰 夯狼 磊侥栏肺 咯矾 夯捞 乐阑 荐 乐绢辑 咯矾 俺狼 秋欺啊 吝酶等促.
	-- 弊矾骨肺 何葛 夯俊 磊侥 秋欺 器牢磐 锅龋甫 扁废窍妨搁 备炼啊 汗棱秦柳促.
	-- 弊贰辑 窜鉴窍霸, 磊侥吝俊 秋欺啊 乐绰瘤, 弊府绊 滴 锅掳 急琶 夯苞 老摹窍绰瘤甫 炼荤茄促.
	-- 涝仿蔼 : selA绰 霉 锅掳 急琶 夯, selB绰 滴 锅掳 急琶 夯
	-- 免仿蔼 : 概莫 登搁 秋欺甫 府畔窍带啊, 概莫捞 救登搁 undefined
	-- 捞 规侥篮 Orientation 秋欺甫 茫绰单 荤侩且 荐 绝促. Orientation 秋欺绰 selA狼 磊侥俊 绝栏骨肺. 措脚俊 FindOrientationHelperByTarget 窃荐甫 荤侩秦具窃
	function GetLookAtHelper selA selB = (
		for obj in selA.children do (
			if (GetHelperType obj == "LookAt") do (
				tTarget = GetTargetObj obj
				if (tTarget == selB) do ( return obj)
			)
		)
		-- 概莫登绰霸 绝栏搁 undefined
		return undefined
	)

	-- 纠 傈眉俊辑 obj甫 鸥百栏肺 窍绰 Orientation 秋欺甫 茫绰促. 绝栏搁 undefined
	function FindOrientationHelperByTarget obj = (
		for o in helpers do (
			if (GetHelperType o == "Orientation") do (
				local target = GetTargetObj o
				if (target == obj) do (return o)
			)
		)
		return undefined
	)
	
	-- 妮归俊辑 龋免登绰 窃荐. 纠俊辑 急琶捞 函拳瞪 锭付促 砒狼 府胶飘甫 悼扁拳 秦霖促.
	-- Fixed Distance Helper 滚瓢狼 劝己, 厚劝己档 技泼茄促.
	function CallbackSyncSel = (
		if ( pairs.count == 0 ) do return ()
		tIndex = 0
		for i = 1 to pairs.count do (
			if ( pairs[i].fbxObj == selection[1] and selection.count != 0 ) do ( tIndex = i )
			if ( pairs[i].bipObj == selection[1] and selection.count != 0 ) do ( tIndex = i )
		)
		
		if ( tIndex != 0  ) do (
			uiLBoxFbxBip.selection = tIndex
			SetList ()
 			SetStatus ()
			SetBipInfo()
		)
	)

	-- FBX狼 惯篮 惯啊遏阑 官扼焊绊, 官捞菩靛狼 惯篮 惯啊遏苞 荐乞牢 瞒捞肺 牢秦
	-- 官捞菩靛 惯狼 臭捞客 阿档甫 FBX 扁霖栏肺 舅酒郴具窃.
	-- Z绵栏肺 Angle父怒 付捞呈胶 雀傈等 孽磐聪攫阑 府畔
	function GetBipedFootAngleQuat bipFoot = (
		local footAngle = 0
		local bipToe = bipFoot.children[1]	-- 官捞菩靛 惯篮 惯啊遏捞 公炼扒 窍唱扼档 乐促.
		
		local footIndex = FindInPairsBip bipFoot
		if footIndex == 0 do (return footAngle)	-- 府胶飘俊 粮犁窍瘤 臼栏搁 扁夯 Angle 蔼阑 府畔
		local toeIndex = FindInPairsBip bipToe
		if toeIndex == 0 do (return footAngle)	-- 府胶飘俊 粮犁窍瘤 臼栏搁 扁夯 Angle 蔼阑 府畔

		local fbxFoot = pairs[footIndex].fbxObj
		if (fbxFoot == undefined) OR (isDeleted fbxFoot) do (return footAngle)
		local fbxToe = pairs[toeIndex].fbxObj
		if (fbxToe == undefined) OR (isDeleted fbxToe) do (return footAngle)

		local distC = distance fbxFoot.pos fbxToe.pos
		local distB = uiSpnFootHeight.value
		local distA = sqrt(distC * distC - distB * distB)	-- 伙阿窃荐 a力蚌 + b力蚌 = c力蚌
		footAngle = atan(distB/distA)
		return (quat -footAngle [0, 0, 1])
	)
	
	-- pairs 傈眉俊 措秦 瘤沥等 矫埃父怒 局聪皋捞记 虐甫 教农 茄促.
	function SyncKeyRangedAll frameStart frameEnd = (
		if ( classof rootObjBip ) == Biped_Object do (
			rootObjBip.controller.rootnode.controller.figureMode = false
			-- Separate FK Tracks甫 盒府秦具 迫厕摹客 公腑捞 救沥利栏肺 备况柳促. 官捞菩靛绰 窍冠捞唱 辆酒府甫 雀傈矫懦 锭 何葛啊 鞍捞 撇绢瘤绰 漂己捞 乐绰单, 飘发阑 盒府窍搁 刀磊利栏肺 虐啊 馆康等促.
			rootObjBip.controller.sepLegsTracks = true
			rootObjBip.controller.sepArmsTracks = true
		)
		clearSelection()		-- 官捞菩靛啊 急琶等 惑怕俊辑绰 at time 规侥苞 龋券登瘤 臼绰促.
		
		--disableSceneRedraw()
		
		--老窜 虐 昏力
		deselectKeys rootObjBip.controller frameStart frameEnd
		selectKeys rootObjBip.controller frameStart frameEnd
		local deleteType
		if uiChkDeleteExistingKeys.state then (deleteType = #allKeys) else (deleteType = #selection)
		if ( classof rootObjBip ) == Biped_Object then (
			biped.deleteKeys rootObjBip.controller.vertical.controller deleteType
			biped.deleteKeys rootObjBip.controller.horizontal.controller deleteType
			biped.deleteKeys rootObjBip.controller.turning.controller deleteType
		)
		else (
			deleteKeys rootObjBip.controller deleteType
		)
		
		for p = 1 to pairs.count do (
			local bipObj = pairs[p].bipObj
			deselectKeys bipObj.controller frameStart frameEnd
			selectKeys bipObj.controller frameStart frameEnd
			if ( classof bipObj ) == Biped_Object then (
				biped.deleteKeys bipObj.controller deleteType 
			)
			else (
				deleteKeys bipObj.controller deleteType 
			)
		)
		
		-- root 畴靛 刚历
		for i = frameStart to frameEnd do (
			at time (i as time) (
				if ( classof rootObjBip ) == Biped_Object then (
						biped.setTransform rootObjBip #pos rootObjFbx.transform.position true
						biped.setTransform rootObjBip #rotation  rootObjFbx.transform.rotation true
				)
				else (
					with animate on (
						tMatrix = matrix3 1
						tMatrix.rotation = rootObjFbx.transform.rotation
						tMatrix.position = rootObjFbx.transform.position		-- rotation 促澜俊 position 狼 鉴辑啊 吝夸
						rootObjBip.transform = tMatrix
					)
				)
			) -- at time end
		) -- for end

		-- fbx 夯狼 虐橇饭烙捞 剁决 剁决 乐阑 版快 概 坷宏璃飘付促 傈眉 橇饭烙阑 葛滴 累诀茄 第俊 促澜 坷宏璃飘肺 逞绢啊绰 规侥阑 秒秦具茄促.
		for p = 1 to pairs.count do (
			local bipObj = pairs[p].bipObj
			local fbxObj = pairs[p].fbxObj
			local bipType = GetBipedType bipObj
			for i = frameStart to frameEnd do (
				at time (i as time) (
					if ( classof bipObj ) == Biped_Object then (
						-- 哭惯捞芭唱 坷弗惯捞绊 傅农 锅龋啊 3锅牢 Foot牢 版快 Offset 阿档甫 歹茄促.
						local tQuat = fbxObj.transform.rotation
						if (bipType.limbName == #lleg OR bipType.limbName == #rleg) do (
							if (bipType.linkIndex == 3) do (
								-- 咯扁辑 歹窍绰 阿档绰 Figure Sync俊辑 捞固 拌魂等 蔼阑 犁荤侩窍绰 巴档 八配沁栏唱, Figure Sync 绝捞 Key All阑 窍绰 版快档 绊妨轻咯 概 锅 Angle阑 拌魂窍绰 规侥栏肺 利侩
								-- 哭惯阑 扁霖栏肺 固府 惯格 Offset Angle阑 掘绢敌促. (FBX客 官捞菩靛狼 惯格 备炼 瞒捞 焊沥)
								local offsetQuat = GetBipedFootAngleQuat bipObj	-- 惯格阑 Z绵 付捞呈胶 规氢栏肺 倒赴 孽磐聪攫 积己
								tQuat = offsetQuat * tQuat	-- 扁粮 FBX 惯格 阿档俊 坷橇悸 巨臂 利侩
							)
						)
						biped.setTransform bipObj #pos fbxObj.transform.position true
						biped.setTransform bipObj #rotation tQuat true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = fbxObj.transform.rotation
							tMatrix.position = fbxObj.transform.position		-- rotation 促澜俊 position 狼 鉴辑啊 吝夸
							bipObj.transform = tMatrix
						)
					)
				) -- at time end
			) -- for end
			uiPBar.value = (((p as float) / (pairs.count as float)) * 100 ) as integer
		)
		
		--enableSceneRedraw()
	)
	
	-- 急琶等 官捞菩靛 窍唱俊 措秦 瘤沥等 矫埃父怒 局聪皋捞记 虐甫 教农 茄促.
	function SyncKeyRangedSel frameStart frameEnd obj= (
		if ( classof rootObjBip ) == Biped_Object do (
			rootObjBip.controller.rootnode.controller.figureMode = false
			-- Separate FK Tracks甫 盒府秦具 迫厕摹客 公腑捞 救沥利栏肺 备况柳促. 官捞菩靛绰 窍冠捞唱 辆酒府甫 雀傈矫懦 锭 何葛啊 鞍捞 撇绢瘤绰 漂己捞 乐绰单, 飘发阑 盒府窍搁 刀磊利栏肺 虐啊 馆康等促.
			rootObjBip.controller.sepLegsTracks = true
			rootObjBip.controller.sepArmsTracks = true
		)
		clearSelection()		-- 官捞菩靛啊 急琶等 惑怕俊辑绰 at time 规侥苞 龋券登瘤 臼绰促.
		
		--disableSceneRedraw() 
		
		tIndex = FindInPairsBip obj
		for i = frameStart to frameEnd do (
			if ( obj == rootObjBip ) then (
				-- root 畴靛牢 版快
				at time (i as time) (
					if ( classof rootObjBip ) == Biped_Object then (
						biped.setTransform rootObjBip #pos rootObjFbx.transform.position true
						biped.setTransform rootObjBip #rotation  rootObjFbx.transform.rotation true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = rootObjFbx.transform.rotation
							tMatrix.position = rootObjFbx.transform.position		-- rotation 促澜俊 position 狼 鉴辑啊 吝夸
							rootObjBip.transform = tMatrix
						)
					)
				) -- at time end
			)
			else (
				-- 唱赣瘤 何困牢 版快
				local bipObj = pairs[tIndex].bipObj
				local fbxObj = pairs[tIndex].fbxObj
				at time (i as time) (
					if ( classof bipObj ) == Biped_Object then (
						local tQuat = fbxObj.transform.rotation
						local bipType = GetBipedType bipObj
						-- 哭惯捞芭唱 坷弗惯捞绊 傅农 锅龋啊 3锅牢 Foot牢 版快 Offset 阿档甫 歹茄促.
						if (bipType.limbName == #lleg OR bipType.limbName == #rleg) do (
							if (bipType.linkIndex == 3) do (
								-- 咯扁辑 歹窍绰 阿档绰 Figure Sync俊辑 捞固 拌魂等 蔼阑 犁荤侩窍绰 巴档 八配沁栏唱, Figure Sync 绝捞 Key All阑 窍绰 版快档 绊妨轻咯 概 锅 Angle阑 拌魂窍绰 规侥栏肺 利侩
								-- 哭惯阑 扁霖栏肺 固府 惯格 Offset Angle阑 掘绢敌促. (FBX客 官捞菩靛狼 惯格 备炼 瞒捞 焊沥)
								local offsetQuat = GetBipedFootAngleQuat bipObj	-- 惯格阑 Z绵 付捞呈胶 规氢栏肺 倒赴 孽磐聪攫 积己
								tQuat = offsetQuat * tQuat	-- 扁粮 FBX 惯格 阿档俊 坷橇悸 巨臂 利侩
							)
						)
						biped.setTransform bipObj #pos fbxObj.transform.position true
						biped.setTransform bipObj #rotation tQuat true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = fbxObj.transform.rotation
							tMatrix.position = fbxObj.transform.position		-- rotation 促澜俊 position 狼 鉴辑啊 吝夸
							bipObj.transform = tMatrix
						)
					)
				) -- at time end
			)
		) -- for end
		
		--enableSceneRedraw()
	)

	-- 虐橇饭烙 积己窍扁 傈 傈眉 官捞菩靛俊 措秦 概飘腐胶 府悸阑 茄促.
	-- 概飘腐胶 府悸阑 窍绰 捞蜡 : 俊叼磐俊辑 荐悼栏肺 Align 殿阑 窍搁 官捞菩靛狼 概飘腐胶啊 部咯辑 捞饶 胶农赋飘俊辑 Align阑 秦档 力措肺 沥纺捞 救等促.
	-- 局聪皋捞记 虐 积己窍扁 傈俊 老褒肺 秦具窍绰 捞蜡 : IK啊 混酒乐绰 Limb 何困, 抗甫 甸绢 窍冠俊辑 Matrix3 1 甫 窍绰 鉴埃 惑冠俊 康氢阑 林扁锭巩俊 夯拜利栏肺 虐甫 积己窍扁 傈俊 茄锅 热绢具茄促.
	function ResetBipedMatrix = (
		for i = 1 to pairs.count do (
			pairs[i].bipObj.transform = Matrix3 1
		)
	)

	on uiBtnScanRoot pressed do (
		if ( objects.count == 0 ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_FbxRoot") == true ) do ( rootObjFbx = o )
			if ( (getUserProp o "SoxFbxToBiped_BipRoot") == true ) do ( rootObjBip = o )
		)
		
		SetList ()
	)
	
	on uiBtnFigureSync pressed do (
		-- pairs 甫 拌摸备炼 鉴辑措肺 刚历 沥纺茄促.
		-- 沥纺窍绰 捞蜡 : 官捞菩靛绰 霸摸备炼 鉴辑措肺 figure 甫 炼沥秦具窃
		-- 3ds Max 弥脚滚傈捞 登搁辑 家泼 累悼捞 概快 蠢府促. 0.29滚傈鳖瘤绰 府胶飘 盎脚矫付促 家泼阑 沁栏唱 0.30何磐 府胶飘 盎脚矫俊绰 家泼阑 救茄促.
		SortByHierarchy ()
		SetList ()

		if NonBipedCheck() do return()		-- 官捞菩靛啊 酒囱 坷宏璃飘甫 措惑栏肺 窍绰 府胶飘俊辑绰 Figure Sync 扁瓷捞 累悼窍瘤 臼绰促.
		
		if ( CheckMatch () == false ) do (
			messagebox "Please check list"
			return ()
		)
		
		if ( pairs.count == 0 ) do return ()
		if ( rootObjBip == undefined or rootObjFbx == undefined ) do return ()
		
		setCommandPanelTaskMode mode:#motion -- 救傈阑 困秦 葛记 菩澄肺 函版
		select rootObjBip	-- 官捞菩靛 急琶 惑怕俊辑 贸府秦具窃
		undo on (
		tFigureSaved = rootObjBip.controller.rootnode.controller.figureMode
		rootObjBip.controller.rootnode.controller.figureMode = true
		
		biped.setTransform rootObjBip #pos rootObjFbx.transform.position false
		biped.setTransform rootObjBip #rotation  rootObjFbx.transform.rotation false
		
		for i = 1 to pairs.count do (
			local meFbx = pairs[i].fbxObj
			local meBip = pairs[i].bipObj

			-- bipType.limbName, bipType.linkIndex
			local bipType = GetBipedType meBip
			
			-- X绵 胶纳老俊 荤侩且 磊侥 官捞菩靛 坷宏璃飘 急沥. undefined搁 磊侥捞 绝绰 畴靛烙. 窍瘤父 nub锭巩俊 磊侥捞 绝绰 畴靛啊 瘤沥瞪 老篮 芭狼 绝澜. 乐促搁 蜡历 角荐
			tChildForScale = GetChildByScalePos meBip
			tOriginalScale = biped.getTransform meBip #scale

			case of
				(
					-- Pelvis
					(bipType.limbName == #pelvis):(
						tLLeg = biped.getNode rootObjBip #lleg link:1
						tIndex = FindInPairsBip tLLeg
						if ( tIndex != 0 ) then ( tLLegFbx = pairs[tIndex].fbxObj ) else ( tLLegFbx = undefined )
						
						tRLeg = biped.getNode rootObjBip #rleg link:1
						tIndex = FindInPairsBip tRLeg
						if ( tIndex != 0 ) then ( tRLegFbx = pairs[tIndex].fbxObj ) else ( tRLegFbx = undefined )
						
						if ( tLLegFbx != undefined and tRLegFbx != undefined ) do (
							tOriginalScale = biped.getTransform meBip #scale
							tDist = distance tLLegFbx.transform.position tRLegFbx.transform.position
							meBip.transform = Matrix3 1 -- 飘罚胶汽 檬扁拳, 钙胶 俊叼磐俊辑 蜡历俊 狼秦 Align 等 夯篮 飘罚胶汽捞 部咯乐绰 版快啊 啊阐 惯积茄促(措钎利栏肺 坷弗率 尖榜). 捞繁 版快俊档 巩力 绝捞 登妨搁 Matrix3 1 肺 檬扁拳 秦林搁 救傈窍促.
							biped.setTransform meBip #rotation ( meFbx.transform.rotation ) false
							biped.setTransform meBip #scale [tOriginalScale.x, tOriginalScale.y, tDist ] false
						)
					) -- Pelvis end

					-- Left Foot
					(bipType.limbName == #lleg and bipType.linkIndex == 3):(
						if (meBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx 飘府备炼绰 官捞菩靛客狼 绵 沥纺阑 困秦 措府侩 歹固甫 辆辆 荤侩窍扁锭巩俊 fbx狼 何葛甫 茫扁 困秦辑绰 官捞菩靛 何葛 扁霖栏肺 fbx 府胶飘甫 八祸秦具茄促.
							tMeFbxParent = pairs[(FindInPairsBip meBip.parent)].fbxObj
						)
						
						tDeltaPosFbx = meFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = FindInPairsFbx tMeFbxParent
							tBipParent = pairs[tFbxParentIndex].bipObj
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						meBip.transform = Matrix3 1 -- 飘罚胶汽 檬扁拳, 钙胶 俊叼磐俊辑 蜡历俊 狼秦 Align 等 夯篮 飘罚胶汽捞 部咯乐绰 版快啊 啊阐 惯积茄促(措钎利栏肺 坷弗率 尖榜). 捞繁 版快俊档 巩力 绝捞 登妨搁 Matrix3 1 肺 檬扁拳 秦林搁 救傈窍促.
						biped.setTransform meBip #pos tBipPos false
						
						-- FBX绰 惯格捞 惯啊遏阑 官扼焊绊 官捞菩靛绰 惯格苞 惯啊遏捞 乞青茄 巩力啊 乐绢辑 uiSpnFootHeight 臭捞蔼阑 扁馆栏肺 茄 雀傈 坷橇悸 馆康
						local offsetQuat = GetBipedFootAngleQuat meBip	-- 惯格阑 Z绵 付捞呈胶 规氢栏肺 倒赴 孽磐聪攫 积己
						offsetQuat = offsetQuat * meFbx.transform.rotation	-- 扁粮 FBX 惯格 阿档俊 坷橇悸 巨臂 利侩
						biped.setTransform meBip #rotation offsetQuat false
						
						tChildIndex = FindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							--tLocalDistM3 = GetLocalTransform meFbx.transform tChildFbx.transform		-- 磊侥狼 肺拿 飘罚胶汽阑 荤侩窍绰 规侥篮 豪牢.
							--FBX绰 惯捞 惯啊遏阑 官扼焊绰单 官捞菩靛绰 惯苞 惯啊遏捞 乞青窍绊 臭捞 瞒啊 乐绰 规侥捞促. FBX狼 惯 雀傈蔼阑 力措肺 馆康窍妨搁 惯啊遏阑 官扼焊绰 规侥栏肺 秦具父 茄促. 官扼焊绰 规侥俊辑绰 磊侥狼 臭捞蔼捞 0牢 巩力啊 惯积茄促.
							--弊贰辑 惯俊 措秦辑父 荐悼栏肺 Foot Height 蔼阑 瘤沥窍咯 荤侩茄促.
							biped.setTransform meBip #scale [uiSpnFootHeight.value, tOriginalScale.y, tOriginalScale.z ] false
						)
					) -- Left Foot end
					
					-- Right Foot
					(bipType.limbName == #rleg and bipType.linkIndex == 3):(
						if (meBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx 飘府备炼绰 官捞菩靛客狼 绵 沥纺阑 困秦 措府侩 歹固甫 辆辆 荤侩窍扁锭巩俊 fbx狼 何葛甫 茫扁 困秦辑绰 官捞菩靛 何葛 扁霖栏肺 fbx 府胶飘甫 八祸秦具茄促.
							tMeFbxParent = pairs[(FindInPairsBip meBip.parent)].fbxObj
						)
						
						tDeltaPosFbx = meFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = FindInPairsFbx tMeFbxParent
							tBipParent = pairs[tFbxParentIndex].bipObj
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						meBip.transform = Matrix3 1 -- 飘罚胶汽 檬扁拳, 钙胶 俊叼磐俊辑 蜡历俊 狼秦 Align 等 夯篮 飘罚胶汽捞 部咯乐绰 版快啊 啊阐 惯积茄促(措钎利栏肺 坷弗率 尖榜). 捞繁 版快俊档 巩力 绝捞 登妨搁 Matrix3 1 肺 檬扁拳 秦林搁 救傈窍促.
						biped.setTransform meBip #pos tBipPos false
						
						-- FBX绰 惯格捞 惯啊遏阑 官扼焊绊 官捞菩靛绰 惯格苞 惯啊遏捞 乞青茄 巩力啊 乐绢辑 uiSpnFootHeight 臭捞蔼阑 扁馆栏肺 茄 雀傈 坷橇悸 馆康
						local offsetQuat = GetBipedFootAngleQuat meBip	-- 惯格阑 Z绵 付捞呈胶 规氢栏肺 倒赴 孽磐聪攫 积己
						offsetQuat = offsetQuat * meFbx.transform.rotation	-- 扁粮 FBX 惯格 阿档俊 坷橇悸 巨臂 利侩
						biped.setTransform meBip #rotation offsetQuat false
						
						tChildIndex = FindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							--tLocalDistM3 = GetLocalTransform meFbx.transform tChildFbx.transform		-- 磊侥狼 肺拿 飘罚胶汽阑 荤侩窍绰 规侥篮 豪牢.
							--FBX绰 惯捞 惯啊遏阑 官扼焊绰单 官捞菩靛绰 惯苞 惯啊遏捞 乞青窍绊 臭捞 瞒啊 乐绰 规侥捞促. FBX狼 惯 雀傈蔼阑 力措肺 馆康窍妨搁 惯啊遏阑 官扼焊绰 规侥栏肺 秦具父 茄促. 官扼焊绰 规侥俊辑绰 磊侥狼 臭捞蔼捞 0牢 巩力啊 惯积茄促.
							--弊贰辑 惯俊 措秦辑父 荐悼栏肺 Foot Height 蔼阑 瘤沥窍咯 荤侩茄促.
							biped.setTransform meBip #scale [uiSpnFootHeight.value, tOriginalScale.y, tOriginalScale.z ] false
						)
					) -- Right Foot end

					-- L R Clavicle 官捞菩靛 尖榜篮 figure 葛靛俊辑 雀傈捞 力措肺 烹力登瘤 臼绰 巩力啊 乐绢辑 standard 葛靛俊辑 规氢阑 棱绊 copy posture肺 figure 葛靛俊辑 利侩 (瘤历盒茄 快雀规过烙)
					-- 包访 器胶泼 https://forums.cgsociety.org/t/clavicle-orientation-in-figure-mode-biped/1512488/3
					(bipType.limbName == #larm and bipType.linkIndex == 1 or bipType.limbName == #rarm and bipType.linkIndex == 1):(
						if (meBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx 飘府备炼绰 官捞菩靛客狼 绵 沥纺阑 困秦 措府侩 歹固甫 辆辆 荤侩窍扁锭巩俊 fbx狼 何葛甫 茫扁 困秦辑绰 官捞菩靛 何葛 扁霖栏肺 fbx 府胶飘甫 八祸秦具茄促.
							tMeFbxParent = pairs[(FindInPairsBip meBip.parent)].fbxObj
						)

						tDeltaPosFbx = meFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = FindInPairsFbx tMeFbxParent
							-- Xtra夯 殿阑 荤侩且 锭 Xtra狼 何葛甫 飘困胶飘夯阑 何葛肺 荤侩窍绰 殿 拌摸备炼啊 捞绢瘤瘤 臼绰 惑炔俊辑
							-- 娄阑 茫瘤 给窍绊 tFbxParentIndex 蔼捞 0捞 瞪 荐 乐促.
							-- 弊矾搁 绢驴 荐 绝捞 累悼篮 窍档废 meBip.parent甫 荤侩窍磊.
							if ( tFbxParentIndex != 0 ) then (
								tBipParent = pairs[tFbxParentIndex].bipObj
							)
							else (
								tBipParent = meBip.parent;
							)
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						meBip.transform = Matrix3 1 -- 飘罚胶汽 檬扁拳, 钙胶 俊叼磐俊辑 蜡历俊 狼秦 Align 等 夯篮 飘罚胶汽捞 部咯乐绰 版快啊 啊阐 惯积茄促(措钎利栏肺 坷弗率 尖榜). 捞繁 版快俊档 巩力 绝捞 登妨搁 Matrix3 1 肺 檬扁拳 秦林搁 救傈窍促.
						biped.setTransform meBip #pos tBipPos false
						
						-- 尖榜 肺抛捞记 贸府 矫累
						rootObjBip.controller.figureMode = false -- 泪矫 standard 葛靛肺 傈券
						biped.setTransform meBip #rotation meFbx.transform.rotation false
						local tNowBipedController = meBip.controller -- 吝汗 荤侩窍绰 牧飘费矾甫 肺拿 函荐肺 积己
						-- 妮泛记捞 绝栏搁 窍唱 父电促
						if (biped.numCopyCollections tNowBipedController == 0) do (
							biped.createCopyCollection tNowBipedController "Col01"
						)
						select meBip
						local tPostureName = biped.copyPosture tNowBipedController #posture true true true
						rootObjBip.controller.figureMode = true -- 促矫 figure 葛靛肺 傈券
						biped.pastePosture tNowBipedController #posture false tPostureName
						biped.deleteCopy tNowBipedController #posture tPostureName
						-- 尖榜 肺抛捞记 贸府 场

						tChildIndex = FindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							tDist = distance meFbx.transform.position tChildFbx.transform.position		-- 磊侥苞狼 芭府
							biped.setTransform meBip #scale [tDist, tOriginalScale.y, tOriginalScale.z ] false
						)
					) -- L R Clavicle end
					
					default: (
						if (meBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx 飘府备炼绰 官捞菩靛客狼 绵 沥纺阑 困秦 措府侩 歹固甫 辆辆 荤侩窍扁锭巩俊 fbx狼 何葛甫 茫扁 困秦辑绰 官捞菩靛 何葛 扁霖栏肺 fbx 府胶飘甫 八祸秦具茄促.
							local tIndex = FindInPairsBip meBip.parent
							if tIndex == 0 then
							(
								--版绊 皋矫瘤冠胶 豪牢, 抗寇贸府啊 眠啊登搁辑 版绊绰 绝绢档 瞪 淀.
								--messagebox ("Warning - There are no pairs in the list that match the 'biped' you specified as parent. - " + tMeBip.parent.name)
								-- 府胶飘俊 绝绰 飘困胶飘夯狼 磊侥栏肺 嘿篮 Xtra 夯阑 府胶飘俊 荤侩且 版快 捞繁 老捞 积辨 荐 乐促.
								-- 咯扁辑 吝窜且 荐档 绝栏聪 磊脚狼 fbx 其绢甫 茫绊 弊 fbx狼 何葛甫 荤侩窍磊.
								tIndex = FindInPairsBip meBip -- 泅犁 官捞菩靛狼 牢郸胶甫 舅酒郴绊
								tMeFbxParent = pairs[tIndex].fbxObj.parent -- 牢郸胶 街狼 fbx狼 何葛甫 tMeFbxParent俊 持绰促.
								-- 版绊档 沁栏聪 捞贰档 救登绰扒 唱吝俊 粱歹 绊刮秦杭 何盒.
							)
							else (
								tMeFbxParent = pairs[tIndex].fbxObj
							)
						)
						
						tDeltaPosFbx = meFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = FindInPairsFbx tMeFbxParent
							-- Xtra夯 殿阑 荤侩且 锭 Xtra狼 何葛甫 飘困胶飘夯阑 何葛肺 荤侩窍绰 殿 拌摸备炼啊 捞绢瘤瘤 臼绰 惑炔俊辑
							-- 娄阑 茫瘤 给窍绊 tFbxParentIndex 蔼捞 0捞 瞪 荐 乐促.
							-- 弊矾搁 绢驴 荐 绝捞 累悼篮 窍档废 meBip.parent甫 荤侩窍磊.
							if ( tFbxParentIndex != 0 ) then (
								tBipParent = pairs[tFbxParentIndex].bipObj
							)
							else (
								tBipParent = meBip.parent;
							)
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						-- 促澜 飘罚胶汽 檬扁拳绰 尖榜阑 盒府窍搁辑 蜡瘤秦具窍绰瘤 抛胶飘 鞘夸
						meBip.transform = Matrix3 1 -- 飘罚胶汽 檬扁拳, 钙胶 俊叼磐俊辑 蜡历俊 狼秦 Align 等 夯篮 飘罚胶汽捞 部咯乐绰 版快啊 啊阐 惯积茄促(措钎利栏肺 坷弗率 尖榜). 捞繁 版快俊档 巩力 绝捞 登妨搁 Matrix3 1 肺 檬扁拳 秦林搁 救傈窍促.
						biped.setTransform meBip #pos tBipPos false
						
						biped.setTransform meBip #rotation meFbx.transform.rotation false
						
						tChildIndex = FindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							tDist = distance meFbx.transform.position tChildFbx.transform.position		-- 磊侥苞狼 芭府
							biped.setTransform meBip #scale [tDist, tOriginalScale.y, tOriginalScale.z ] false
						)
					) -- default end
				) -- case end
		) -- for end
		) -- undo off
		
-- 		rootObjBip.controller.figureMode = tFigureSaved -- 磊悼栏肺 Figure葛靛俊辑 盔贰 老馆 葛靛肺 登倒酒啊档废 且 版快 Clevicle 俊辑 捞蜡甫 舅 荐 绝绰 肺抛捞记 俊矾啊 惯积秦辑 公炼扒 Figure葛靛肺 场郴档废 窃
	)
	
	on uiBtnKeyAll pressed do (
		if ( CheckMatch () == false ) do (
			messagebox "Please check list"
			return ()
		)
		if ( pairs.count == 0 ) do return ()
		if ( rootObjBip == undefined or rootObjFbx == undefined ) do return ()
		
		if ( uiRBtnKeyOption.state == 1 ) then (
			frameStart = animationRange.start as integer / TicksPerFrame
			frameEnd = animationRange.end as integer / TicksPerFrame
		)
		else (
			frameStart = slidertime as integer / TicksPerFrame
			frameEnd = slidertime as integer / TicksPerFrame
		)
		tSelBackup = selection as array
		undo on (
			ResetBipedMatrix()
			SyncKeyRangedAll frameStart frameEnd
		)
		select tSelBackup
	)
	
	on uiBtnKeySelectedOne pressed do (
		if ( CheckMatch () == false ) do (
			messagebox "Please check list"
			return ()
		)
		if ( pairs.count == 0 ) do return ()
		if ( rootObjBip == undefined or rootObjFbx == undefined ) do return ()
		
		-- 急琶等 坷宏璃飘啊 府胶飘俊 绝栏搁 弊成 府畔
		if ( ( FindInPairsBip selection[1] ) == 0 and selection[1] != rootObjBip ) do return ()
		
		if ( uiRBtnKeyOption.state == 1 ) then (
			frameStart = animationRange.start as integer / TicksPerFrame
			frameEnd = animationRange.end as integer / TicksPerFrame
		)
		else (
			frameStart = slidertime as integer / TicksPerFrame
			frameEnd = slidertime as integer / TicksPerFrame
		)
		tSelBackup = selection as array
		undo on (
			-- 急琶等 巴 窍唱俊 措秦辑绰 Matrix3 1 阑 窍搁 救等促. Limb鞍篮镑俊辑 窍困 窍唱俊辑 窍搁 惑困俊档 康氢阑 霖促.
			SyncKeyRangedSel frameStart frameEnd selection[1]
		)
		select tSelBackup
	)
	
	on uiBtnReset pressed do (
		pairs = #()
		rootObjFbx = undefined
		rootObjBip = undefined
		SetList ()
	)

	-- Bip001捞 酒囱 老馆 坷宏璃飘俊辑 局聪皋捞记 虐 箭磊甫 舅酒郴绰 窃荐.
	-- 老馆 官捞菩靛俊辑 keys甫 流立 掘绢坷绰 规过阑 给茫酒辑 count 掘绢坷绰 巴阑 快雀利栏肺 备泅.
	function GetKeyCountNonRootBiped bipObj = (
		local keyCount = 1
		local breakFlag = false
		while breakFlag == false do (
			try(biped.getKey bipObj.transform.controller keyCount) catch (
				breakFlag = true
				return (keyCount - 1)
			)
			keyCount += 1
		)
	)

	on uiBtnSetAnimRangeBySelectedObj pressed do (
		if selection.count == 0 then return()
		local tempFirst
		local tempLast
		local returnFirst = 999999f
		local returnLast = 0f
		for obj in selection do (
			if (classof obj.baseobject) == Biped_Object then (
				if obj == obj.transform.controller.rootNode then (
					-- Bip001牢 版快
					local bipRootKeys = obj.transform.controller.horizontal.controller.keys -- 捞扒 Bip001侩
					if bipRootKeys.count != 0 do (
						tempFirst = bipRootKeys[1].time
						tempLast = bipRootKeys[bipRootKeys.count].time
					)
				)
				else (
					-- 老馆 官捞菩靛牢 版快
					local bipKeyCount = GetKeyCountNonRootBiped obj
					if bipKeyCount != 0 do (
						tempFirst = (biped.getKey obj.transform.controller 1).time
						tempLast = (biped.getKey obj.transform.controller bipKeyCount).time
					)
				)
			)
			else (
				-- 官捞菩靛啊 酒囱 老馆 坷宏璃飘牢 版快
				local notError = true
				try (obj.position.controller) catch (notError = false)	-- 抗寇贸府. 官捞菩靛 Nub 歹固鞍篮 版快 官捞菩靛 努贰胶档 酒聪绊 牧飘费矾甫 掘绢棵 荐 绝澜.
				if notError do
				(
					local positionKeys = obj.position.controller.keys
					local rotationKeys = obj.rotation.controller.keys
					local keys
					if (positionKeys.count > rotationKeys.count) then (
						keys = positionKeys
					)
					else (
						keys = rotationKeys
					)
					local keyCount = keys.count
					if keyCount >= 1 do (
						tempFirst = keys[1].time
						tempLast = keys[keyCount].time
					)
				)
			)
			returnFirst = amin tempFirst returnFirst
			returnLast = amax tempLast returnLast
		)
		animationRange = Interval returnFirst returnLast
	)
	
	on uiBtnDoReplace pressed do (
		strToFind = uiETxtReplaceFrom.text
		strToReplace = uiETxtReplaceTo.text
	
        undo on (
            for o in selection do(
                tStr = o.name
                tPos = findstring tStr strToFind
                if (tPos != undefined) do (
                    newStr = replace tStr tPos strToFind.count strToReplace
                    o.name = newStr
                )
            )
        ) --undo end
		
		SetList ()
	)

    on uiBtnDoAppend pressed do (
        if ( selection.count >= 3) do (
            messagebox ( "Please select only one or two objects." )
            return()
        )
        
        undo on (
            --窍唱 急琶窍搁 弊成 咆胶飘父 眠啊
            if ( selection.count == 1) do (
                selection[1].name += uiETxtAppend.text
            )

            --笛 急琶窍搁 1锅 捞抚阑 扁馆栏肺 2锅俊 咆胶飘甫 眠啊秦淋
            if ( selection.count == 2) do (
                selection[2].name = selection[1].name + uiETxtAppend.text
            )
        ) --undo end
    )

    on uiBtnDoAppendAlign pressed do (
        if ( selection.count != 2) do (
            messagebox ( "You need to select two objects." )
            return()
        )

        undo on (
            selection[2].transform = selection[1].transform
            selection[2].parent = selection[1]
            selection[2].name = selection[1].name + uiETxtAppend.text
        ) --undo end
    )

    on uiBtnDoAppendAlignedPoint pressed do (
        undo on (
            tSel = #()
            for o in selection do(
                tPoint = Point()
                tPoint.wirecolor = (color 14 255 2)
                tPoint.size = uiSpnPointSize.value
                tPoint.parent = o
                tPoint.transform = o.transform
                tPoint.name = o.name + uiETxtAppend.text
                append tSel tPoint
            )
        select tSel
        )--undo end
    )

    on uiBtnAddPositionConstraint pressed do (
        undo on (
            for o in selection do(
                o.pos.controller = Position_Constraint ()
            )
        ) -- undo end
    )

    on uiBtnAddLookatConstraint pressed do (
        undo on (
        for o in selection do(
            o.rotation.controller = LookAt_Constraint ()
        )
        ) -- undo end
    )

    on uiBtnAddOrientationConstraint pressed do (
        undo on (
        for o in selection do(
            o.rotation.controller = Orientation_Constraint ()
        )
        ) -- undo end
    )
	
	on uiBtnSetRootFbx pressed do (
		if selection[1] == undefined do return ()
		if ( classof selection[1] == Biped_Object ) do (
			messagebox ( "Please select NON Biped Object" )
			return ()
		)
		
		if ( rootObjFbx == selection[1] ) do return ()
		
		uiLabelRootFbx.text = selection[1].name
		rootObjFbx = selection[1]
		
		-- Root 坷宏璃飘啊 函版登菌栏搁 唱赣瘤 FBX 坷宏璃飘甸篮 货肺 备己秦具窃. 葛滴 朝妨滚赴促.
		if ( pairs.count > 0 ) do (
			for o = 1 to pairs.count do (
				pairs[o].fbxObj = undefined
			)
		)
		
		-- 蜡历 橇肺欺萍俊 风飘 畴靛扼绰 钎矫甫 茄促.
		SetUserPropFbxRoot selection[1]
		
		if uiCBoxAutoHide.state do (
			hide selection[1]
			clearSelection()
		)
		
		SetList ()
	)
	
	on uiBtnSetRootBip pressed do (
		if selection[1] == undefined do return ()
		if ( classof selection[1] != Biped_Object and uiCBoxNonBipedMode.state == false ) do (
			messagebox ( "Please select Biped Object" )
			return ()
		)
		
		if ( rootObjBip == selection[1] ) do return ()
		
		uiLabelRootBip.text = selection[1].name
		rootObjBip = selection[1]
		
		-- Root 坷宏璃飘啊 函版登菌栏搁 唱赣瘤 Bip 坷宏璃飘甸篮 货肺 备己秦具窃. 葛滴 朝妨滚赴促.
		if ( pairs.count > 0 ) do (
			for o = 1 to pairs.count do (
				pairs[o].bipObj = undefined
			)
		)
		
		-- 蜡历 橇肺欺萍俊 风飘 畴靛扼绰 钎矫甫 茄促.
		SetUserPropBipRoot selection[1]
		
		if uiCBoxAutoHide.state do (
			hide selection[1]
			clearSelection()
		)
		
		SetList ()
	)
	
	on uiLBoxFbxBip selected arg do (
		SetBipInfo ()
	)
	
	on uiLBoxFbxBip doubleClicked arg do (
		if ( pairs.count == 0 ) do return ()
		
		objs = #()
		if ( pairs[arg].fbxObj != undefined ) do append objs pairs[arg].fbxObj
		if ( pairs[arg].bipObj != undefined ) do append objs pairs[arg].bipObj
		select objs
	)
	
	on uiBtnSelectFbxRoot pressed do (
		if ( rootObjFbx != undefined ) do ( select rootObjFbx )
	)
	
	on uiBtnSelectBipRoot pressed do (
		if ( rootObjBip != undefined ) do ( select rootObjBip )
	)
	
	on uiBtnSelectFbx pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		try ( select pairs[uiLBoxFbxBip.selection].fbxObj ) catch ()
	)
	on uiBtnSelectFbxAll pressed do (
		if ( pairs.count == 0 ) do return ()
		objs = #()
		for o in pairs do (
			if ( o.fbxObj != undefined ) do ( append objs o.fbxObj )
		)
		if ( rootObjFbx != undefined ) do ( append objs rootObjFbx )
		
		if ( objs.count != 0 ) do ( select objs )
	)
	on uiBtnSelectBip pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		try ( select pairs[uiLBoxFbxBip.selection].bipObj ) catch ()
	)
	on uiBtnSelectBipAll pressed do (
		if ( pairs.count == 0 ) do return ()
		objs = #()
		for o in pairs do (
			if ( o.bipObj != undefined ) do ( append objs o.bipObj )
		)
		
		if ( rootObjBip != undefined ) do ( append objs rootObjBip )
		
		if ( objs.count != 0 ) do ( select objs )
	)
	
	on uiBtnLoad pressed do
	(
		if ( rootObjFbx == undefined or rootObjBip == undefined ) do (
			messagebox "You must Get root objects tempFirst"
			return ()
		)
		
		sftbFile = (getOpenFileName caption:"Select sftb file" types:"SOX Fbx to Biped (*.sftb)|*.sftb|All (*.*)|*.*|") as string
		if sftbFile == "undefined" do return ()
		if (CheckFileExt sftbFile) == false do (messagebox "*.sftb 犬厘磊父 瘤盔钦聪促"; return())
		
		openStream = openFile sftbFile mode:#rt
		
		pairs = #()
		pairsIndex = 0
		
		if ( uiRBtnLoadingType.state == 2 ) then (
			-- Handle 锅龋肺 阂矾坷绰 规侥
			while (eof openStream) != true do
			(
				tempKeyword = readDelimitedString openStream "="	-- "=" 掉府固磐甫 父朝 锭鳖瘤 胶飘覆 佬绢甸烙
				tempKeyword = trimLeft tempKeyword -- 救傈阑 困秦 菊第 傍归阑 绝矩促
				tempKeyword = trimRight tempKeyword -- 救傈阑 困秦 菊第 傍归阑 绝矩促
				
				case of
				(
					(tempKeyword == "FootHeight"):(
						tempValue = readDelimitedString openStream "\n"	-- 府畔 掉府固磐甫 父朝 锭鳖瘤 胶飘覆 佬绢甸烙
						uiSpnFootHeight.value = execute tempValue	-- 胶飘傅栏肺何磐 臭捞蔼 掘绢郴辑 ui俊 利侩
					)

					(tempKeyword == "FbxObjHandle"):(
						append pairs (pairdef ()) ; pairsIndex += 1	-- pairs 硅凯俊 眠啊
						tempValue = readDelimitedString openStream "\n"	-- 府畔 掉府固磐甫 父朝 锭鳖瘤 胶飘覆 佬绢甸烙
						tHandle = execute tempValue
						tHandleObj = try ( maxOps.getNodeByHandle tHandle ) catch (undefined)
						pairs[pairsIndex].fbxObj = undefined
						
						--if ( tHandle != undefined  and (IfChild rootObjFbx tHandleObj) ) do (
						if ( tHandle != undefined  ) do (
							pairs[pairsIndex].fbxObj = tHandleObj
						)
					)
					
					(tempKeyword == "BipObjHandle"):(
						tempValue = readDelimitedString openStream "\n"
						tHandle = execute tempValue
						tHandleObj = try ( maxOps.getNodeByHandle tHandle ) catch (undefined)
						pairs[pairsIndex].bipObj = undefined
						if ( tHandle != undefined and (IfChild rootObjBip tHandleObj) ) do (
							pairs[pairsIndex].bipObj = tHandleObj
						)
					)
					
					default: (readDelimitedString openStream "\n")
				)
			)
		)
		else (
			-- Name栏肺 阂矾坷绰 规侥
			while (eof openStream) != true do
			(
				tempKeyword = readDelimitedString openStream "="
				tempKeyword = trimLeft tempKeyword -- 救傈阑 困秦 菊第 傍归阑 绝矩促
				tempKeyword = trimRight tempKeyword -- 救傈阑 困秦 菊第 傍归阑 绝矩促
				
				case of
				(
					(tempKeyword == "FootHeight"):(
						tempValue = readDelimitedString openStream "\n"	-- 府畔 掉府固磐甫 父朝 锭鳖瘤 胶飘覆 佬绢甸烙
						uiSpnFootHeight.value = execute tempValue	-- 胶飘傅栏肺何磐 臭捞蔼 掘绢郴辑 ui俊 利侩
					)
					
					(tempKeyword == "FbxObjName"):(
						append pairs (pairdef ()) ; pairsIndex += 1
						tempValue = readDelimitedString openStream "\n"
						tempValue = trimLeft tempValue -- 救傈阑 困秦 菊第 傍归阑 绝矩促
						tempValue = trimRight tempValue -- 救傈阑 困秦 菊第 傍归阑 绝矩促
						tObjs = GetObjsByName tempValue
						pairs[pairsIndex].fbxObj = undefined
						if ( tObjs.count != 0 ) do (
							for o in tObjs do (
								--if ( IfChild rootObjFbx o ) do ( pairs[pairsIndex].fbxObj = o )
								pairs[pairsIndex].fbxObj = o
							)
						)
					)
					
					(tempKeyword == "BipObjName"):(
						tempValue = readDelimitedString openStream "\n"
						tObj = getNodeByName tempValue
						tempValue = trimLeft tempValue -- 救傈阑 困秦 菊第 傍归阑 绝矩促
						tempValue = trimRight tempValue -- 救傈阑 困秦 菊第 傍归阑 绝矩促
						tObjs = GetObjsByName tempValue
						pairs[pairsIndex].bipObj = undefined
						if ( tObjs.count != 0 ) do (
							for o in tObjs do (
								--if ( IfChild rootObjBip o ) do ( pairs[pairsIndex].bipObj = o )
								pairs[pairsIndex].bipObj = o
							)
						)
					)
					
					default: (readDelimitedString openStream "\n")
				)
			)
		)
		SetList ()
		
		close openStream
	)
	
	on uiBtnSaveAs pressed do ( 
		file = (getSaveFileName caption:"Save sftb file" types:"Sox Fbx to Biped (*.sftb)|*.sftb|All (*.*)|*.*|")

		-- 历厘 傈 拌摸备炼 扁霖栏肺 家泼 荐青 (发捞 吧府绰 累诀烙)
		SortByHierarchy ()
		SetList ()

		try (
			if (file != undefined) and (ss = createFile file) != undefined do
			(
			format "%" (SetFileStream() as string) to:ss

			flush ss
			close ss
			true
			)
		) catch ( messagebox "File Access Error" )
	)
	
	on uiBtnListAdd pressed do (
		append pairs (pairDef ())
		uiLBoxFbxBip.selection = pairs.count
		SetList ()
	)
	
	on uiBtnListDel pressed do (
		if ( pairs.count == 0 ) do return ()
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		deleteItem pairs uiLBoxFbxBip.selection
		SetList ()
	)

    on uiBtnListHide pressed do (
        if ( pairs.count == 0 ) do return ()
		local selIndex = uiLBoxFbxBip.selection

		objs = #()
		if ( pairs[selIndex].fbxObj != undefined ) do append objs pairs[selIndex].fbxObj
		if ( pairs[selIndex].bipObj != undefined ) do append objs pairs[selIndex].bipObj
		hide objs
    )

    on uiBtnListUnHide pressed do (
        if ( pairs.count == 0 ) do return ()
        local selIndex = uiLBoxFbxBip.selection
		
		objs = #()
		if ( pairs[selIndex].fbxObj != undefined ) do append objs pairs[selIndex].fbxObj
		if ( pairs[selIndex].bipObj != undefined ) do append objs pairs[selIndex].bipObj
		unhide objs
    )
	
	-- 泅犁 急琶等 坷宏璃飘甫 FBX 府飘胶俊 眠啊
	on uiBtnSetFbx pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( classof selection[1] == Biped_Object ) do (
			messagebox ( "Please select NON Biped Object" )
			return ()
		)
		
		/*
		-- FBX绰 拌摸备炼狼 磊蜡档甫 困秦辑 鞍篮 拌摸备炼俊 乐绰瘤 八荤甫 积帆窃
		if ( IfChild rootObjFbx selection[1] ) == false do (
			messagebox "It must exist in same hierarchy"
			return ()
		)
		*/
		
		
		tPos = FindInPairsFbx (selection[1])
		if ( tPos > 0 ) do (
			-- 泅犁 急琶等 坷宏璃飘 捞抚捞 扁粮俊 捞固 粮犁茄促搁
			-- 扁粮俊 粮犁窍绰 坷宏璃飘 楷搬阑 老窜 秦力
			pairs[tPos].fbxObj = undefined
		)

		pairs[uiLBoxFbxBip.selection].fbxObj = selection[1]
		
		if uiCBoxAutoHide.state then (
			hide selection[1]
			clearSelection()
			SetList ()
		)
		else (
			SetList ()
			CallbackSyncSel ()
		)
	)
	on uiBtnClearFbx pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( pairs.count == 0 ) do return ()
		pairs[uiLBoxFbxBip.selection].fbxObj = undefined
		SetList ()
	)
	
	-- 泅犁 急琶等 坷宏璃飘甫 Bip 府飘胶俊 眠啊
	on uiBtnSetBip pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( classof selection[1] != Biped_Object and uiCBoxNonBipedMode.state == false ) do (
			messagebox ( "Please select Biped Object" )
			return ()
		)
		if ( IfChild rootObjBip selection[1] ) == false do (
			messagebox "It must exist in same hierarchy"
			return ()
		)
		
		tPos = FindInPairsBip (selection[1])
		if ( tPos > 0 ) do (
			-- 泅犁 急琶等 坷宏璃飘 捞抚捞 扁粮俊 捞固 粮犁茄促搁
			-- 扁粮俊 粮犁窍绰 坷宏璃飘 楷搬阑 老窜 秦力
			pairs[tPos].bipObj = undefined
		)

		pairs[uiLBoxFbxBip.selection].bipObj = selection[1]
		
		if uiCBoxAutoHide.state then ( 
			hide selection[1]
			clearSelection()
			SetList ()
		)
		else (
			SetList ()
			CallbackSyncSel ()
		)
	)
	
	on uiBtnClearBip pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( pairs.count == 0 ) do return ()
		pairs[uiLBoxFbxBip.selection].bipObj = undefined
		SetList ()
	)
	
	on SoxFbxToBiped open do (
        callbacks.addScript #selectionSetChanged "SoxFbxToBiped.CallbackSyncSel ()" id:#SFTBSelect
        -- 坷锹 流饶 Scan Root 荐青窍绰 累诀篮 府胶飘甫 厚快霸登绊 坷洒妨 阂祈秦辑 豪牢.
		callbacks.addScript #filePostOpen "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBOpen
        callbacks.addScript #systemPostNew "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBNew
        callbacks.addScript #systemPostReset "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBReset
    
        rootObjFbx = undefined
        rootObjBip = undefined
    
-- 			uiSpnThickHor.value	= 0.5
-- 			uiSpnThickVer.value	= 0.4

        uiBtnScanRoot.pressed()
        SetList ()

        uiETxtAppend.text = "_proxy"
    )
	
	on SoxFbxToBiped close do (
        callbacks.removeScripts id:#SFTBSelect
        callbacks.removeScripts id:#SFTBOpen
        callbacks.removeScripts id:#SFTBNew
        callbacks.removeScripts id:#SFTBReset
	)
	
	on uiBtnAbout pressed do
	(
		shellLaunch "http://cafe.naver.com/pinksox/6064" ""
	)
	
)

createDialog SoxFbxToBiped style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) lockWidth:true