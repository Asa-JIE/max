# MaxTool 小框架

## 目标

工具代码放在 P4 / 共享盘，不同用户本地路径可以不同。
每个人只需要运行 `install.bat`，安装脚本会把当前工具根路径写入 `MaxTool.mod`。

3ds Max 启动后自动加载：

```text
max-tool
├─ rig
├─ mesh
└─ help
```

点击 `max-tool > help > Load Success` 会弹出：

```text
max_tool加载成功
```

## 启动链路

```text
P4共享工具库
        ↓
install.bat
        ↓
MaxTool.mod
        ↓
max_tool_startup.ms
        ↓
bootstrap.ms
        ↓
menu_system
        ↓
rig / mesh / help
```

## 安装

1. 修改 `install.bat` 里的 Max Modules 路径：

```bat
set "MAX_MODULE_DIR=C:\Program Files\Autodesk\3ds Max 2020\Modules"
```

2. 双击运行：

```bat
install.bat
```

3. 重启 3ds Max。

## 注意

如果你的 3ds Max 环境不读取 `.mod`，需要改成 Max 原生的 `ApplicationPlugins/package.xml` 或者把 `max_tool_startup.ms` 放到用户 startup 目录。这个包保留了 `.mod` 范式，适合你当前设计方向。
