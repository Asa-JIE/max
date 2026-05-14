# Sox Fbx to Biped v0.34 使用说明

## 工具简介

`Sox Fbx to Biped` 是一个 3ds Max MaxScript 工具。

主要功能：

将 FBX 骨骼动画转换到 3ds Max Biped 骨架。

适用于：

- 动捕 FBX 转 Biped
- 游戏动画重定向
- 第三方角色动画导入
- 非标准骨架转 Biped
- 快速动画烘焙

---

# 工具核心流程

整体流程：

1. 导入 FBX
2. 创建/准备 Biped
3. 设置 Root
4. 建立骨骼映射
5. Figure Sync
6. Key All
7. 得到最终 Biped 动画

---

# UI 功能说明

---

# 一、Root 设置

## Set Fbx Root

```maxscript
Set Fbx Root