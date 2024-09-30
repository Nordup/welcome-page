extends Node

@export var chat_events: ChatEvents


func _ready() -> void:
	chat_events.send_message.connect(send_message)


func send_message(username: String, text: String) -> void:
	if text.is_empty(): return
	print("sending: " + text)
	receive_message.rpc(multiplayer.get_unique_id(), username, text)


@rpc("any_peer", "call_local", "reliable")
func receive_message(id: int, username: String, text: String) -> void:
	print(username + ": " + text)
	if Connection.is_server(): return
	chat_events.receive_message_emit(id, username, text)
