extends Control
class_name TerminalPanel

@export var root: TextureButton
@export var interactable_events: InteractableEvents
@export var mouse_pos: Control
@export var mouse_mode: MouseMode

var current: InteractableTerminal


func _ready() -> void:
	interactable_events.on_entered.connect(on_interactable_entered)
	interactable_events.on_exited.connect(on_interactable_exited)
	root.pressed.connect(hide_panel)
	
	visible = true
	root.hide()


func on_interactable_entered(_text: String, interactable: InteractableBase) -> void:
	if not interactable is InteractableTerminal: return
	
	current = interactable
	current.on_interact.connect(show_panel)
	
	show_panel()


func on_interactable_exited(interactable: InteractableBase) -> void:
	if interactable != current: return
	
	current.on_interact.disconnect(show_panel)
	current = null
	
	hide_panel()


func show_panel() -> void:
	if root.visible: return
	
	root.show()
	EditMode.set_show_mouse(true)
	if is_instance_valid(mouse_mode):
		mouse_mode.set_captured(false)
		var viewport_scale = Vector2(get_viewport().size) / size
		Input.warp_mouse(mouse_pos.global_position * viewport_scale)
	
	interactable_events.on_blocked_emit(current)


func hide_panel() -> void:
	if not root.visible: return
	
	root.hide()
	EditMode.set_show_mouse(false)
	if is_instance_valid(mouse_mode): mouse_mode.set_captured(true)
	
	interactable_events.on_unblocked_emit(current)


func load_gate(url: String) -> void:
	current.load_gate(url)
