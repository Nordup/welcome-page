extends Control
class_name ConnectionStatus

enum Status { CONNECTING, CONNECTED, DISCONNECTED}

@export var label: Label


func set_status(status : Status) -> void:
	match status:
		Status.CONNECTING:
			label.text = "Connecting ..."
		Status.CONNECTED:
			label.text = "Connected to server"
		Status.DISCONNECTED:
			label.text = "Disconnected from server"
		_:
			push_error("Invalid connection status")
