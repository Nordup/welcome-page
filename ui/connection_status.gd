extends Control
class_name ConnectionStatus

enum Status { CONNECTING, FAILED_TO_CONNECT, CONNECTED, DISCONNECTED}

@export var label: Label


func set_status(status : Status) -> void:
	match status:
		Status.CONNECTING:
			label.text = "Connecting..."
		Status.FAILED_TO_CONNECT:
			label.text = "Failed to connect!"
		Status.CONNECTED:
			label.text = "Connected"
		Status.DISCONNECTED:
			label.text = "Disconnected"
		_:
			push_error("Invalid connection status")
