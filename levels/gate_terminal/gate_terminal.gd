extends Node3D

@export var start_url: String
@export var interactable: InteractableTerminal
@export var terminal_info: TerminalInfo
@export var stand: StandBase
@export var portal: Portal
@export var synchronizer: MultiplayerSynchronizer

## Sync property
@export var synced_url: String

var current_url: String


func _ready() -> void:
	if Connection.is_server():
		portal.url = start_url
		synced_url = start_url
		return
	
	synchronizer.delta_synchronized.connect(on_synchronized)
	synchronizer.synchronized.connect(on_synchronized)
	
	interactable.on_load_gate.connect(on_load_gate)
	on_load_gate(start_url, false)


func on_synchronized() -> void:
	if synced_url == current_url: return
	Debug.log_msg("Synchronized %s: %s" % [name, synced_url])
	on_load_gate(synced_url, false)


func on_load_gate(url: String, sync: bool = true) -> void:
	if url.is_empty(): return
	if current_url == url: return
	
	Debug.log_msg("Loading gate: " + url)
	var success = await terminal_info.set_info(url)
	if not success: return
	
	if sync: synchronize_url.rpc(url)
	current_url = url
	portal.url = url
	
	stand.render()


@rpc("any_peer", "call_remote", "reliable")
func synchronize_url(url: String) -> void:
	if not Connection.is_server(): return
	if synced_url == url: return
	
	Debug.log_msg("Setting %s url to %s" % [name, url])
	portal.url = url
	synced_url = url
