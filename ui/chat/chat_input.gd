extends LineEdit

@export var chat_events: ChatEvents
@export var user_data_events: UserDataEvents
@export var connection_events: ConnectionEvents
@export var send_sound: AudioStreamPlayer

var username: String
var is_edit_name: bool
var is_writing: bool


func _ready() -> void:
	text_submitted.connect(on_text_submitted)
	text_changed.connect(on_text_changed)
	focus_entered.connect(start_edit)
	focus_exited.connect(stop_edit)
	connection_events.status_changed.connect(change_help_text)
	user_data_events.user_data_spawned.connect(on_user_data_spawned)


func on_user_data_spawned(id: int, user_data: UserData) -> void:
	if id != multiplayer.get_unique_id(): return
	
	username = user_data.nickname
	if not username.is_empty():
		placeholder_text = "'Enter' to chat, 'N' to change name"
		is_edit_name = false
		chat_events.set_username_emit(username)


func change_help_text(status : ConnectionEvents.Status) -> void:
	if status == ConnectionEvents.Status.CONNECTED:
		if username.is_empty(): edit_name()
		else: placeholder_text = "'Enter' to chat, 'N' to change name"
		editable = true
	else:
		placeholder_text = "Wait for connection to chat"
		editable = false


func edit_name() -> void:
	placeholder_text = "'Enter' your name"
	is_edit_name = true


func _input(event: InputEvent) -> void:
	if not editable: return
	if is_writing: return
	
	var is_chat = event.is_action_pressed("chat")
	var is_change_name = event.is_action_pressed("change_name")
	if not is_chat and not is_change_name: return
	
	if is_change_name or username.is_empty(): edit_name()
	
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


func on_text_changed(_text: String) -> void:
	if not is_edit_name: return
	text = text.replace(" ", "")
	text = text.replace('\t', "")
	caret_column = text.length()


func on_text_submitted(_text: String) -> void:
	is_writing = false
	EditMode.set_enabled(false)
	release_focus()
	
	if text.is_empty(): return
	
	if is_edit_name:
		if not username.is_empty() or not text.is_empty():
			is_edit_name = false
			placeholder_text = "'Enter' to chat, 'N' to change name"
		
		if not text.is_empty():
			username = text
			chat_events.set_username_emit(text)
			user_data_events.user_data_manager.my_user_data.nickname = text
	else:
		chat_events.send_message_emit(username, text)
	
	send_sound.play()
	text = ""
