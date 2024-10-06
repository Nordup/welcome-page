extends Node3D

@export var url: String
@export var portal: Portal
@export var terminal_info: TerminalInfo
@export var stand: StandBase


func _ready() -> void:
	set_gate_run()


func set_gate_run() -> void:
	terminal_info.set_info(url)
	await terminal_info.on_info_set
	
	portal.url = url
	stand.render()
