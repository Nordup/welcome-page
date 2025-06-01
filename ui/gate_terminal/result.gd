extends Control
class_name SearchResult

@export var button: Button
@export var title: Label
@export var image: TextureRect
@export var stats: Label
@export var new_root: Control
@export var click_sound: AudioStreamPlayer

var terminal_panel: TerminalPanel
var url: String


func _ready() -> void:
	button.pressed.connect(on_button_pressed)


func fill(gate: Dictionary, panel: TerminalPanel, is_new: bool = false) -> void:
	terminal_panel = panel
	if gate == null: return
	
	url = gate["url"]
	title.text = "Unnamed" if gate["title"].is_empty() else gate["title"]
	stats.text = str(int(gate["number_of_entries"]))
	new_root.visible = true if is_new else false
	
	var image_path = await FileDownloader.download(gate["image"])
	image.texture = await FileTools.load_external_tex(image_path, true)
	image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS


func on_button_pressed() -> void:
	if url.is_empty(): return
	terminal_panel.load_gate(url)
	click_sound.play()
