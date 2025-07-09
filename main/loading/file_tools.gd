extends Node
# class_name FileTools


func remove_recursive(path: String) -> void:
	if not DirAccess.dir_exists_absolute(path) and not FileAccess.file_exists(path): return
	
	var dir = DirAccess.open(path)
	if dir:
		# List directory content
		var err : Error
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				remove_recursive(path + "/" + file_name)
			else:
				err = dir.remove(file_name)
				if err != OK: printerr("Error removing: " + path + "/" + file_name)
			file_name = dir.get_next()
		
		# Remove current path
		err = dir.remove(path)
		if err != OK: printerr("Error removing: " + path)
	else:
		printerr("Error removing " + path)


func load_external_tex(path: String, use_threads: bool = false) -> Texture2D:
	if use_threads:
		var thread = Thread.new()
		thread.start(_load_texture_internal.bind(path))
		
		while thread.is_alive():
			await get_tree().process_frame

		var texture = thread.wait_to_finish()
		return texture
	else:
		return _load_texture_internal(path)


func _load_texture_internal(path: String) -> Texture2D:
	if path.begins_with("res://"): return load(path)
	if not FileAccess.file_exists(path): return null
	
	var file = FileAccess.open(path, FileAccess.READ)
	var bytes = file.get_buffer(file.get_length())
	var image = Image.new()
	match path.get_extension():
		"png":
			image.load_png_from_buffer(bytes)
		"jpeg", "jpg":
			image.load_jpg_from_buffer(bytes)
		"webp":
			image.load_webp_from_buffer(bytes)
		"bmp":
			image.load_bmp_from_buffer(bytes)
		_:
			return null
	return ImageTexture.create_from_image(image) as Texture2D
