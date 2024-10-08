extends Node3D

@export var start_url: String
@export var interactable: InteractableTerminal
@export var terminal_info: TerminalInfo
@export var stand: StandBase
@export var portal: Portal
@export var synchronizer: MultiplayerSynchronizer

## Sync property
@export var _url: String

var current_url: String


func _ready() -> void:
	if Connection.is_server():
		_url = start_url
		return
	
	synchronizer.delta_synchronized.connect(on_synchronized)
	synchronizer.synchronized.connect(on_synchronized)
	
	interactable.on_load_gate.connect(on_load_gate)
	on_load_gate(start_url)


func on_synchronized() -> void:
	if _url == current_url: return
	print("Synchronized %s: %s" % [name, _url])
	on_load_gate(_url)


func on_load_gate(url: String) -> void:
	print("Loading gate: " + url)
	if url.is_empty(): return
	
	terminal_info.set_info(url)
	var success = await terminal_info.on_info_set
	if not success: return
	
	set_server_url.rpc(url)
	current_url = url
	portal.url = url
	
	stand.render()


@rpc("any_peer", "call_remote", "reliable")
func set_server_url(url: String) -> void:
	if not multiplayer.is_server(): return
	if _url == url: return
	
	print("Setting %s url to %s" % [name, url])
	_url = url
