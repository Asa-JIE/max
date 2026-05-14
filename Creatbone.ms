try (destroyDialog create_point_bone_roll )catch()
rollout create_point_bone_roll "选择根节点重建骨骼0.2" width:200 height:210
(
	group "" (
		label lab_01 "x轴指向下一节骨骼时才可用"
		checkbox chk_rotaion "原骨骼方向" Align:#center
	)
	group ""(
		checkbox chk_end_rotaion "尾骨骼原方向" Align:#center checked:true
		edittext edit_prefix_name "命名空间" text:"Bone:"
		spinner sp_bone_size "骨骼大小" range:[0.01,10,1]
	)
	button btn_do "选择根节点重建骨骼" width:180 height:24
	hyperLink help_ "帮助" address:"http://101.34.112.80/pages/9b4465" Align:#center
	fn create_end_bone newbone parent_bone =
	(
		if isValidNode parent_bone do
		(
			endbone_1pos = [parent_bone.length,0,0] * parent_bone.objectTransform
			endbone = boneSys.createBone newbone.transform.pos (endbone_1pos+sp_bone_size.value * 2.0) parent_bone.dir
			endbone.sidefins= false
			endbone.backfin=false
			endbone.frontfin = true
			endbone.frontfinsize = sp_bone_size.value
			endbone.rotation = parent_bone.rotation
			endbone.pos = newbone.transform.translation
			--in coordSys Local move endbone [parent_bone.length,0,0]
			endbone.taper=90
			endbone.parent = parent_bone
			endbone.length=(parent_bone.width+parent_bone.height)/2
			endbone.wirecolor=parent_bone.wirecolor
			endbone.realignBoneToChild()
			endbone.resetBoneStretch()
			endbone.name = ( edit_prefix_name.text + newbone.name )
		)
		--endbone
	)
	fn create_bones obj_1 obj_2 zaxis = --创建骨骼 根据传入的两对象的 位置创建骨骼
	(
		if zaxis == undefined then 
		(
			zaxis = [0,0,1]
		)else (
		    zaxis = zaxis.dir 
		)
		newbone = boneSys.createBone obj_1.transform.pos obj_2.transform.pos zaxis
		newbone.sidefins= false
		newbone.backfin=false
		newbone.frontfin = true
		newbone.frontfinsize = sp_bone_size.value
		newbone.realignBoneToChild()
		newbone.resetBoneStretch()
		newbone.name = ( edit_prefix_name.text + obj_1.name )
		newbone
		--clearSelection()
	)
	fn create_bones_one base_node parent_bone =
	(

		if isValidNode parent_bone then (
			endbone_1pos = base_node.transform.pos + (base_node.transform.pos - parent_bone.transform.pos )
			length_ = (parent_bone.width+parent_bone.height)*0.5
			wirecolor_ = parent_bone.wirecolor
			dir_ = parent_bone.dir
			prefix_name = edit_prefix_name.text
		)else(
			--X轴指向下一节时
			endbone_1pos = [sp_bone_size.value * 2.0,0,0] + base_node.transform.translation
			length_ = sp_bone_size.value
			wirecolor_ = red 
			dir_ = base_node.dir 
			prefix_name = edit_prefix_name.text
		)
		endbone = boneSys.createBone base_node.transform.pos (endbone_1pos+sp_bone_size.value*2.0) dir_
		endbone.frontfin = true
		endbone.frontfinsize = sp_bone_size.value
		
		--if chk_rotaion.state do (
		endbone.rotation = base_node.transform.rotation
		--)
		endbone.pos = base_node.transform.translation
		--in coordSys Local move parent_bone [parent_bone.length,0,0]
		--endbone.taper=90
		endbone.parent = parent_bone
		endbone.sidefins= false
		endbone.backfin=false
		endbone.frontfin = true
		endbone.frontfinsize = sp_bone_size.value
		endbone.length = length_
		endbone.wirecolor = wirecolor_
		endbone.realignBoneToChild()
		endbone.resetBoneStretch()
		---endbone.name = uniqueName( "Bone_" + base_node.name)
		endbone.name =( prefix_name + base_node.name)
		
		endbone 
	)
	
	fn create_bones_childen base_node parent_bone = 
	(
		if base_node.children.count == 1 do
		(
			for i in base_node.children do 
			(
				new_bone = create_bones base_node i parent_bone
				new_bone.parent = parent_bone 
				if chk_rotaion.state do 
				(
					new_bone.transform = base_node.transform
				)
				create_bones_childen i new_bone
			)
		)
		if base_node.children.count > 1 do (
			parent_bone = create_bones_one base_node parent_bone
			for i in base_node.children do 
			(
				create_bones_childen i parent_bone
			)
		)
		if base_node.children.count < 1 do (
			
			if chk_end_rotaion.state then 
			(
				create_bones_one base_node parent_bone
			)else(
				create_end_bone base_node parent_bone
			)
			--最后一节尾骨可能是反向的
		)

	)
	on btn_do pressed do 
	(
		if selection.count == 1 do 
		(
			create_bones_childen selection[1] undefined
		)
	)
)

createdialog create_point_bone_roll