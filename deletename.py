# -*- coding: utf-8 -*-
import os
import traceback

import maya.cmds as cmds
import maya.mel as mel
import maya.OpenMayaUI as omui

from PySide2 import QtWidgets, QtCore
from shiboken2 import wrapInstance


def maya_main_window():
    ptr = omui.MQtUtil.mainWindow()
    if ptr is not None:
        return wrapInstance(int(ptr), QtWidgets.QWidget)
    return None


class Maya2022FBXNamespaceCleanerUI(QtWidgets.QDialog):

    def __init__(self, parent=maya_main_window()):
        super(Maya2022FBXNamespaceCleanerUI, self).__init__(parent)

        self.setWindowTitle(u"Maya2022 FBX批量清理命名空间")
        self.setMinimumWidth(600)
        self.resize(700, 500)

        self.setWindowFlags(
            self.windowFlags() ^ QtCore.Qt.WindowContextHelpButtonHint
        )

        self.build_ui()
        self.connect_signals()

    def build_ui(self):
        layout = QtWidgets.QVBoxLayout(self)

        path_layout = QtWidgets.QHBoxLayout()

        self.path_line = QtWidgets.QLineEdit()
        self.path_line.setPlaceholderText(u"选择 FBX 文件夹")

        self.browse_btn = QtWidgets.QPushButton(u"选择文件夹")

        path_layout.addWidget(self.path_line)
        path_layout.addWidget(self.browse_btn)

        self.recursive_check = QtWidgets.QCheckBox(u"包含子文件夹")
        self.recursive_check.setChecked(False)

        self.info_label = QtWidgets.QLabel(
            u"输出规则：在选择的文件夹下面创建 delete 文件夹，FBX 文件名保持原名"
        )

        self.run_btn = QtWidgets.QPushButton(u"开始批量处理")
        self.run_btn.setMinimumHeight(40)

        self.log_text = QtWidgets.QTextEdit()
        self.log_text.setReadOnly(True)

        layout.addLayout(path_layout)
        layout.addWidget(self.recursive_check)
        layout.addWidget(self.info_label)
        layout.addWidget(self.run_btn)
        layout.addWidget(self.log_text)

    def connect_signals(self):
        self.browse_btn.clicked.connect(self.choose_folder)
        self.run_btn.clicked.connect(self.run_batch)

    def log(self, text):
        self.log_text.append(str(text))
        print(text)
        QtWidgets.QApplication.processEvents()

    def choose_folder(self):
        folder = QtWidgets.QFileDialog.getExistingDirectory(
            self,
            u"选择 FBX 文件夹",
            ""
        )

        if folder:
            folder = folder.replace("\\", "/")
            self.path_line.setText(folder)

    def load_fbx_plugin(self):
        if not cmds.pluginInfo("fbxmaya", query=True, loaded=True):
            cmds.loadPlugin("fbxmaya")
            self.log(u"[Info] 已加载 fbxmaya 插件")

    def new_scene(self):
        cmds.file(new=True, force=True)

    def import_fbx(self, fbx_path):
        fbx_path = fbx_path.replace("\\", "/")

        mel.eval('FBXImportMode -v add;')
        mel.eval('FBXImport -f "{}";'.format(fbx_path))

    def clean_namespaces(self):
        namespaces = cmds.namespaceInfo(
            listOnlyNamespaces=True,
            recurse=True
        ) or []

        namespaces = [
            ns for ns in namespaces
            if ns not in ["UI", "shared"]
        ]

        namespaces.sort(key=lambda x: x.count(":"), reverse=True)

        for ns in namespaces:
            try:
                cmds.namespace(
                    removeNamespace=ns,
                    mergeNamespaceWithRoot=True
                )
                self.log(u"[CleanNamespace] {}".format(ns))
            except Exception as e:
                self.log(u"[WARN] namespace 删除失败: {} | {}".format(ns, e))

    def setup_fbx_export_options(self):
        mel.eval("FBXResetExport;")

        mel.eval("FBXExportSmoothingGroups -v true;")
        mel.eval("FBXExportHardEdges -v false;")
        mel.eval("FBXExportTangents -v true;")
        mel.eval("FBXExportSmoothMesh -v true;")
        mel.eval("FBXExportInstances -v false;")

        mel.eval("FBXExportSkins -v true;")
        mel.eval("FBXExportShapes -v true;")

        mel.eval("FBXExportConstraints -v false;")
        mel.eval("FBXExportCameras -v false;")
        mel.eval("FBXExportLights -v false;")

        mel.eval("FBXExportAnimationOnly -v false;")
        mel.eval("FBXExportBakeComplexAnimation -v false;")

        # 关键：这里不设置 FBXExportUpAxis
        # 不做 Y-Up / Z-Up 转换

    def export_fbx(self, output_path):
        output_path = output_path.replace("\\", "/")

        out_dir = os.path.dirname(output_path)
        if not os.path.exists(out_dir):
            os.makedirs(out_dir)

        self.setup_fbx_export_options()

        cmds.select(all=True)
        mel.eval('FBXExport -f "{}" -s;'.format(output_path))

    def get_fbx_files(self, input_dir, recursive=False):
        input_dir = input_dir.replace("\\", "/")
        result = []

        if recursive:
            for root, dirs, files in os.walk(input_dir):
                root = root.replace("\\", "/")

                # 避免重复处理输出目录 delete
                if "/delete" in root.lower().replace("\\", "/"):
                    continue

                for filename in files:
                    if filename.lower().endswith(".fbx"):
                        result.append(
                            os.path.join(root, filename).replace("\\", "/")
                        )
        else:
            for filename in os.listdir(input_dir):
                full_path = os.path.join(input_dir, filename).replace("\\", "/")
                if os.path.isfile(full_path) and filename.lower().endswith(".fbx"):
                    result.append(full_path)

        return result

    def process_one(self, input_fbx, output_fbx):
        self.log(u"")
        self.log(u"====================================")
        self.log(u"[Process] {}".format(input_fbx))

        self.new_scene()
        self.import_fbx(input_fbx)
        self.clean_namespaces()
        self.export_fbx(output_fbx)

        self.log(u"[Done] {}".format(output_fbx))

    def run_batch(self):
        input_dir = self.path_line.text().strip().replace("\\", "/")

        if not input_dir:
            cmds.warning(u"请选择 FBX 文件夹")
            return

        if not os.path.exists(input_dir):
            cmds.warning(u"文件夹不存在: {}".format(input_dir))
            return

        output_root = os.path.join(input_dir, "delete").replace("\\", "/")

        if not os.path.exists(output_root):
            os.makedirs(output_root)

        recursive = self.recursive_check.isChecked()

        self.log_text.clear()
        self.log(u"[Input]  {}".format(input_dir))
        self.log(u"[Output] {}".format(output_root))
        self.log(u"[Recursive] {}".format(recursive))

        self.load_fbx_plugin()

        fbx_files = self.get_fbx_files(input_dir, recursive)

        if not fbx_files:
            self.log(u"[WARN] 没有找到 FBX 文件")
            return

        success = 0
        failed = 0

        for input_fbx in fbx_files:
            try:
                filename = os.path.basename(input_fbx)

                if recursive:
                    rel_dir = os.path.relpath(
                        os.path.dirname(input_fbx),
                        input_dir
                    ).replace("\\", "/")

                    if rel_dir == ".":
                        out_dir = output_root
                    else:
                        out_dir = os.path.join(output_root, rel_dir).replace("\\", "/")
                else:
                    out_dir = output_root

                output_fbx = os.path.join(out_dir, filename).replace("\\", "/")

                self.process_one(input_fbx, output_fbx)
                success += 1

            except Exception as e:
                failed += 1
                self.log(u"[ERROR] {}".format(input_fbx))
                self.log(str(e))
                self.log(traceback.format_exc())

        self.new_scene()

        self.log(u"")
        self.log(u"====================================")
        self.log(u"[Batch Finished]")
        self.log(u"Success: {}".format(success))
        self.log(u"Failed : {}".format(failed))
        self.log(u"Output : {}".format(output_root))


def show_maya2022_fbx_namespace_cleaner():
    global maya2022_fbx_namespace_cleaner_ui

    try:
        maya2022_fbx_namespace_cleaner_ui.close()
        maya2022_fbx_namespace_cleaner_ui.deleteLater()
    except Exception:
        pass

    maya2022_fbx_namespace_cleaner_ui = Maya2022FBXNamespaceCleanerUI()
    maya2022_fbx_namespace_cleaner_ui.show()


show_maya2022_fbx_namespace_cleaner()