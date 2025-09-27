extends Control
class_name PlayerPanel

@export var nickname_label: Label
@export var volume_slider: HSlider
@export var hints: RichTextLabel
@export var speaking_indicator: Control
@export var user_data_events: UserDataEvents

var user_data: UserData


func _ready() -> void:
	speaking_indicator.visible = false
	nickname_changed(user_data.nickname)
	
	volume_slider.value_changed.connect(volume_changed)


func volume_changed(volume: float) -> void:
	user_data_events.user_volume_changed_emit(user_data.id, volume)


func set_user_data(_user_data: UserData) -> void:
	user_data = _user_data
	if user_data.is_my_data: my_panel()
	
	user_data.nickname_changed.connect(nickname_changed)
	user_data.speaking_changed.connect(speaking_changed)


func my_panel() -> void:
	volume_slider.visible = false
	hints.visible = true


func nickname_changed(nickname: String) -> void:
	if user_data.nickname.is_empty(): nickname_label.text = "Me" if user_data.is_my_data else "Player One"
	else: nickname_label.text = user_data.nickname


func speaking_changed(speaking: bool) -> void:
	speaking_indicator.visible = speaking
