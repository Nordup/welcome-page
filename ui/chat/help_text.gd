extends Label

@export var connection_events: ConnectionEvents
@export var help_link: String


func _ready() -> void:
	connection_events.status_changed.connect(change_help_text)


func change_help_text(status : ConnectionEvents.Status) -> void:
	if status == ConnectionEvents.Status.CONNECTED:
		text = "Press 'H' to leave a feedback or get help!"
	else:
		text = "If you cannot connect press 'H' to get help!"


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("help"): return
	if EditMode.is_enabled and not EditMode.is_connection_msg: return
	
	if get_tree().has_method("send_command"):
		get_tree().send_command("open_link", [help_link])
	else:
		OS.shell_open(help_link)
