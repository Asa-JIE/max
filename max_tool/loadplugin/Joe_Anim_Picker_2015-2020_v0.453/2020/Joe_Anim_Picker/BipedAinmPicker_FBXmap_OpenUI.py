import sys
import MaxPlus

from PySide2 import QtGui,QtWidgets,QtCore

try:
	temp_path = MaxPlus.PathManager.GetScriptsDir() + "\\Joe_Anim_Picker"
	temp_fbx = MaxPlus.PathManager.GetScriptsDir() + "\\FBXSDK202011_Python27_x64"
	if not temp_path in sys.path:
		sys.path.append(temp_path)
	
	if not temp_fbx in sys.path:
		sys.path.append(temp_fbx)

	import BipedAinmPicker_FBXmap_v21

except BaseException:
	print("No Folder scripts\\Joe_Anim_Picker")

if __name__ == "__main__":
	app = QtWidgets.QApplication.instance()
	ui = BipedAinmPicker_FBXmap_v21.FBXedit_MainWindow()
	ui.run()

print("# coding=UTF-8")