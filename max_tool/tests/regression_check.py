# -*- coding: utf-8 -*-
"""
Static regression check for MaxTool framework.
This does not launch 3ds Max. It verifies file layout and load-chain references.
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

required_files = [
    "install.bat",
    "modules/MaxTool.mod.template",
    "scripts/startup/max_tool_startup.ms",
    "scripts/max_tool/core/path_manager.ms",
    "scripts/max_tool/core/bootstrap.ms",
    "scripts/max_tool/menu_system/main_menu.ms",
    "scripts/max_tool/menu_system/menu_register.ms",
    "scripts/max_tool/menu_system/menu_loader.ms",
    "scripts/max_tool/rig/rig_menu.ms",
    "scripts/max_tool/mesh/mesh_menu.ms",
    "scripts/max_tool/help/help_menu.ms",
]

checks = []

for rel in required_files:
    p = ROOT / rel
    checks.append((p.exists(), f"exists: {rel}"))

# Load chain checks
startup = (ROOT / "scripts/startup/max_tool_startup.ms").read_text(encoding="utf-8")
bootstrap = (ROOT / "scripts/max_tool/core/bootstrap.ms").read_text(encoding="utf-8")
loader = (ROOT / "scripts/max_tool/menu_system/menu_loader.ms").read_text(encoding="utf-8")
help_menu = (ROOT / "scripts/max_tool/help/help_menu.ms").read_text(encoding="utf-8")
mod_template = (ROOT / "modules/MaxTool.mod.template").read_text(encoding="utf-8")

checks += [
    ("core\\\\bootstrap.ms" in startup or "core\\bootstrap.ms" in startup, "startup loads bootstrap"),
    ("path_manager.ms" in bootstrap, "bootstrap loads path_manager"),
    ("main_menu.ms" in bootstrap, "bootstrap loads main_menu"),
    ("menu_register.ms" in bootstrap, "bootstrap loads menu_register"),
    ("menu_loader.ms" in bootstrap, "bootstrap loads menu_loader"),
    ("rig\\\\rig_menu.ms" in loader or "rig\\rig_menu.ms" in loader, "loader loads rig_menu"),
    ("mesh\\\\mesh_menu.ms" in loader or "mesh\\mesh_menu.ms" in loader, "loader loads mesh_menu"),
    ("help\\\\help_menu.ms" in loader or "help\\help_menu.ms" in loader, "loader loads help_menu"),
    ("max_tool加载成功" in help_menu, "help action message is correct"),
    ("{ROOT_PATH}" in mod_template, "mod template has ROOT_PATH token"),
]

failed = [msg for ok, msg in checks if not ok]

print("==== MaxTool Static Regression Check ====")
for ok, msg in checks:
    print(("[PASS] " if ok else "[FAIL] ") + msg)

if failed:
    raise SystemExit("FAILED: " + ", ".join(failed))

print("==== Result: PASS ====")
