extends Control
class_name TerminalInfo

signal on_info_set(success: bool)

@export var image_texture: TextureRect
@export var title_label: Label
@export var desc_one: RichTextLabel
@export var desc_two: RichTextLabel

var current_desc: RichTextLabel


func set_info(gate_url: String) -> void:
	var config_path = await FileDownloader.download(gate_url, 10)
	if config_path.is_empty():
		print("Cannot download gate config")
		on_info_set.emit(false)
		return
	
	var c_gate = ConfigGate.new(config_path, gate_url)
	title_label.text = c_gate.title
	set_desc(c_gate.description)
	
	var image_path = await FileDownloader.download(c_gate.image_url)
	image_texture.texture = FileTools.load_external_tex(image_path)
	
	on_info_set.emit(true)


func set_desc(text: String) -> void:
	desc_one.visible = false
	desc_two.visible = false
	
	var lines = title_label.get_line_count()
	current_desc = desc_one if lines == 1 else desc_two
	
	current_desc.visible = true
	current_desc.text = text
