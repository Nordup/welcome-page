extends Resource
class_name ChatEvents

signal send_message(username: String, text: String)
signal receive_message(id: int, username: String, text: String)
signal set_username(username: String)


func send_message_emit(username: String, text: String) -> void:
	send_message.emit(username, text)


func receive_message_emit(id: int, username: String, text: String) -> void:
	receive_message.emit(id, username, text)


func set_username_emit(username: String) -> void:
	set_username.emit(username)
