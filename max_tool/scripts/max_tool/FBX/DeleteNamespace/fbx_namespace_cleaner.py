# -*- coding: utf-8 -*-
'''
from core import fbx_loader
import fbx
import FbxCommon
'''
import os
import sys

CURRENT_DIR = os.path.dirname(__file__)

FBXSDK_PATH = os.path.normpath(
    os.path.join(
        CURRENT_DIR,
        "..",
        "..",
        "third_part",
        "fbxsdk",
        "Max-2020",
        "FBXSDK202011_Python27_x64"
    )
)

if FBXSDK_PATH not in sys.path:
    sys.path.append(FBXSDK_PATH)

import fbx
import FbxCommon

class FBXNamespaceCleaner(object):

    def __init__(self, fbx_path):
        self.fbx_path = fbx_path
        self.sdk_manager = None
        self.scene = None
        self.root_node = None
        self.changed_nodes = []

    def load(self):
        self.sdk_manager, self.scene = FbxCommon.InitializeSdkObjects()

        result = FbxCommon.LoadScene(
            self.sdk_manager,
            self.scene,
            self.fbx_path
        )

        if not result:
            raise RuntimeError("Load FBX Failed: {}".format(self.fbx_path))

        self.root_node = self.scene.GetRootNode()

    def walk_node(self, node):
        self.clean_node_name(node)

        for i in range(node.GetChildCount()):
            self.walk_node(node.GetChild(i))

    def clean_node_name(self, node):
        old_name = node.GetName()

        if ":" not in old_name:
            return

        new_name = old_name.split(":")[-1]
        node.SetName(new_name)

        self.changed_nodes.append((old_name, new_name))
        print("[Namespace Clean] {} -> {}".format(old_name, new_name))

    def clean(self):
        if not self.root_node:
            return

        for i in range(self.root_node.GetChildCount()):
            self.walk_node(self.root_node.GetChild(i))

    def remove_property_all_nodes(self, property_name):
        for node in self.get_all_nodes():
            prop = node.FindProperty(property_name)
            if prop.IsValid():
                prop.DestroyRecursively()
                print("[Remove Property] {} : {}".format(node.GetName(), property_name))

    def remove_nodes_by_names(self, names):
        if not names:
            return

        names = [n.strip() for n in names if n.strip()]

        for node in self.get_all_nodes():
            if node.GetName() in names:
                print("[Remove Node] {}".format(node.GetName()))
                self.scene.RemoveNode(node)

    def get_all_nodes(self):
        nodes = []

        def walk(node):
            nodes.append(node)
            for i in range(node.GetChildCount()):
                walk(node.GetChild(i))

        if self.root_node:
            for i in range(self.root_node.GetChildCount()):
                walk(self.root_node.GetChild(i))

        return nodes

    def save(self, output_path):
        FbxCommon.SaveScene(
            self.sdk_manager,
            self.scene,
            output_path
        )

    def close(self):
        if self.sdk_manager:
            self.sdk_manager.Destroy()


def clean_fbx(
    input_path,
    output_path,
    remove_namespace=True,
    remove_udp3dsmax=False,
    remove_no_export=False,
    remove_node_names=None
):
    cleaner = FBXNamespaceCleaner(input_path)

    try:
        cleaner.load()

        if remove_namespace:
            cleaner.clean()

        if remove_udp3dsmax:
            cleaner.remove_property_all_nodes("UDP3DSMAX")

        if remove_no_export:
            cleaner.remove_property_all_nodes("no_export")
            cleaner.remove_property_all_nodes("no_anim_export")

        if remove_node_names:
            cleaner.remove_nodes_by_names(remove_node_names)

        cleaner.save(output_path)

        return len(cleaner.changed_nodes)

    finally:
        cleaner.close()