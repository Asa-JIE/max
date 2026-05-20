try
(
    fileIn @"E:\max_tool\scripts\max_tool\core\path_manager.ms"
    fileIn (MAX_TOOL_ROOT + @"\core\bootstrap.ms")
)
catch e
(
    format "[MaxTool][ERROR] startup failed: %\n" e
)
