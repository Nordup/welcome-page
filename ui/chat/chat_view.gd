extends VBoxContainer

@export var chat_events: ChatEvents
@export var chat_message: PackedScene
@export var scroll: ScrollContainer

var scroll_bar_max_value: int


func _ready() -> void:
	chat_events.receive_message.connect(receive_message)
	scroll.get_v_scroll_bar().changed.connect(on_scroll_bar_changed)
	scroll_bar_max_value = scroll.get_v_scroll_bar().max_value


func receive_message(id: int, text) -> void:
	var message = chat_message.instantiate() as Label
	add_child(message)
	
	var messages_count = get_child_count()
	if messages_count >= 9:
		remove_child(get_child(0))
	
	var my_id = multiplayer.get_unique_id()
	var user = "Me" if my_id == id else str(id)
	message.text = user + ": " + text


func on_scroll_bar_changed() -> void:
	if scroll_bar_max_value != scroll.get_v_scroll_bar().max_value:
		scroll_bar_max_value = scroll.get_v_scroll_bar().max_value
		scroll.scroll_vertical = int(scroll_bar_max_value)
