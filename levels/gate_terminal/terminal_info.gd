extends Control
class_name TerminalInfo

signal on_info_set()

@export var image_texture: TextureRect
@export var title_label: Label
@export var desc_rich: RichTextLabel


func set_info(gate_url: String) -> void:
	var config_path = await FileDownloader.download(gate_url, 10)
	if config_path.is_empty(): print("Cannot download gate config"); return
	
	var c_gate = ConfigGate.new(config_path, gate_url)
	title_label.text = c_gate.title
	desc_rich.text = c_gate.description
	
	var image_path = await FileDownloader.download(c_gate.image_url)
	image_texture.texture = FileTools.load_external_tex(image_path)
	
	on_info_set.emit()
