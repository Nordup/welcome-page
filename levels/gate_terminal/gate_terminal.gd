extends Node3D

@export var interactable: InteractableTerminal
@export var terminal_info: TerminalInfo
@export var stand: StandBase
@export var portal: Portal


func _ready() -> void:
	interactable.on_load_gate.connect(on_load_gate)


func on_load_gate(url: String) -> void:
	print("Loading gate: " + url)
	
	terminal_info.set_info(url)
	var success = await terminal_info.on_info_set
	if not success: return
	
	portal.url = url
	stand.render()
