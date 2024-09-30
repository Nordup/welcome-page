extends Node

@export var chat_events: ChatEvents
@export var chat_message: PackedScene
@export var scroll: ScrollContainer
@export var container: VBoxContainer
@export var help_text: Label

var scroll_bar_max_value: int


func _ready() -> void:
	chat_events.set_username.connect(set_username)
	chat_events.receive_message.connect(receive_message)
	scroll.get_v_scroll_bar().changed.connect(on_scroll_bar_changed)
	
	scroll_bar_max_value = int(scroll.get_v_scroll_bar().max_value)
	call_deferred("set_help_text_position")


func set_username(username: String) -> void:
	create_message("Your name is " + username, Color.GREEN)


func receive_message(id: int, username: String, text: String) -> void:
	var my_id = multiplayer.get_unique_id()
	var user = "Me" if my_id == id else username
	create_message(user + ": " + text, Color.WHITE)


func create_message(text: String, color: Color) -> void:
	var messages_count = container.get_child_count()
	if messages_count >= 8:
		container.remove_child(container.get_child(0))
	
	var message = chat_message.instantiate() as Label
	container.add_child(message)
	
	message.text = text
	message.self_modulate = color
	
	call_deferred("set_help_text_position")


func on_scroll_bar_changed() -> void:
	if scroll_bar_max_value != scroll.get_v_scroll_bar().max_value:
		scroll_bar_max_value = int(scroll.get_v_scroll_bar().max_value)
		scroll.scroll_vertical = scroll_bar_max_value


func set_help_text_position() -> void:
	var lowest_pos = (container.get_child(0) as Control).global_position.y
	if lowest_pos < scroll.global_position.y:
		lowest_pos = scroll.global_position.y
	
	help_text.global_position.y = lowest_pos - 36
