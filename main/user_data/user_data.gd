extends Node
class_name UserData

signal speaking_changed(speaking: bool)
signal nickname_changed(nickname: String)

const user_data_config = "user://user_data.cfg"

@export var speaking: bool:
	set(value):
		speaking = value
		speaking_changed.emit(value)

@export var nickname: String:
	set(value):
		nickname = value
		nickname_changed.emit(value)
		save_nickname()

var is_my_data: bool
var id: int


func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	if speaking == Microphone.is_speaking: return
	
	speaking = Microphone.is_speaking


func save_nickname() -> void:
	if not is_my_data: return
	
	var config = ConfigFile.new()
	config.load(user_data_config)
	config.set_value("user_data", "nickname", nickname)
	config.save(user_data_config)
	print("save_nickname: ", nickname)


func load_nickname() -> void:
	if not is_my_data: return

	var config = ConfigFile.new()
	config.load(user_data_config)
	nickname = config.get_value("user_data", "nickname")
	print("load_nickname: ", nickname)
