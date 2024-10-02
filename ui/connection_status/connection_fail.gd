extends Control

@export var wait_connection: float = 15
@export var connection_events: ConnectionEvents
@export var root: Control

var was_connected: bool


func _ready() -> void:
	connection_events.status_changed.connect(status_changed)
	show_message_after_delay()


func status_changed(status : ConnectionEvents.Status) -> void:
	if status == ConnectionEvents.Status.CONNECTED:
		was_connected = true
		hide_message()


func show_message_after_delay() -> void:
	root.hide()
	await get_tree().create_timer(wait_connection).timeout
	if was_connected: return
	
	show_message()


func _input(event: InputEvent) -> void:
	if not root.visible: return
	if not event.is_action_pressed("skip"): return
	
	hide_message()


func show_message() -> void:
	if root.visible: return
	
	root.show()
	EditMode.set_enabled(true)
	EditMode.set_connection_msg(true)


func hide_message() -> void:
	if not root.visible: return
	
	root.hide()
	EditMode.set_enabled(false)
	EditMode.set_connection_msg(false)
