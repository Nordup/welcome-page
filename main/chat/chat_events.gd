extends Resource
class_name ChatEvents

signal send_message(text: String)
signal receive_message(id: int, text: String)


func send_message_emit(text: String) -> void:
	send_message.emit(text)


func receive_message_emit(id: int, text: String) -> void:
	receive_message.emit(id, text)
