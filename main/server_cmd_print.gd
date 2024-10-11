@tool
extends EditorScript

func _run():
	var godot = OS.get_executable_path()
	var project = ProjectSettings.globalize_path("res://")
	var cmd = "%s --path %s --server --headless" % [godot, project]
	Debug.log_msg(cmd)
