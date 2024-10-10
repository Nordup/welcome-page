extends Control
class_name SearchResult

@export var title: Label
@export var image: TextureRect

var terminal_panel: TerminalPanel
var url: String


func fill(gate: Dictionary, panel: TerminalPanel) -> void:
	terminal_panel = panel
	if gate == null: return
	
	url = gate["url"]
	title.text = "Unnamed" if gate["title"].is_empty() else gate["title"]
	
	var image_path = await FileDownloader.download(gate["image"])
	image.texture = FileTools.load_external_tex(image_path)
	image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS


func _on_button_pressed() -> void:
	if url.is_empty(): return
	terminal_panel.load_gate(url)
