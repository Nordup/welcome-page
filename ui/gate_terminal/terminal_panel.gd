extends Control

@export var root: Control
@export var events: InteractableEvents
@export var mouse_pos: Control
@export var mouse_mode: MouseMode

var current: InteractableBase


func _ready() -> void:
	events.on_entered.connect(on_interactable_entered)
	events.on_exited.connect(on_interactable_exited)
	
	visible = true
	root.hide()


func on_interactable_entered(_text: String, interactable: InteractableBase) -> void:
	if not interactable is InteractableTerminal: return
	current = interactable
	
	root.show()
	if is_instance_valid(mouse_mode):
		mouse_mode.set_captured(false)
		var viewport_scale = Vector2(get_viewport().size) / size
		Input.warp_mouse(mouse_pos.global_position * viewport_scale)


func on_interactable_exited(interactable: InteractableBase) -> void:
	if interactable != current: return
	current = null
	
	root.hide()
	if is_instance_valid(mouse_mode): mouse_mode.set_captured(true)
