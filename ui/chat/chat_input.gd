extends LineEdit

@export var chat_events: ChatEvents

var is_writing: bool


func _ready() -> void:
	text_submitted.connect(on_text_submitted)
	focus_entered.connect(start_edit)
	focus_exited.connect(stop_edit)


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("chat"): return
	if is_writing: return
	
	start_edit.call_deferred()


func start_edit() -> void:
	is_writing = true
	EditMode.set_enabled(true)
	grab_click_focus()
	grab_focus()
	caret_column = text.length()


func stop_edit() -> void:
	is_writing = false
	EditMode.set_enabled(false)


func on_text_submitted(_text: String) -> void:
	is_writing = false
	EditMode.set_enabled(false)
	release_focus()
	
	chat_events.send_message_emit(text)
	text = ""
