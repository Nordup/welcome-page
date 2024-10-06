extends Control
class_name TerminalPanel

@export var root: TextureButton
@export var events: TerminalEvents
@export var mouse_pos: Control
@export var mouse_mode: MouseMode
#@export var finder: Control

var current: InteractableTerminal


func _ready() -> void:
	events.on_entered.connect(on_terminal_entered)
	events.on_exited.connect(on_terminal_exited)
	root.pressed.connect(hide_panel)
	
	visible = true
	root.hide()


func on_terminal_entered(terminal: InteractableTerminal) -> void:
	current = terminal
	show_panel()


func on_terminal_exited(terminal: InteractableTerminal) -> void:
	if terminal != current: return
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


func hide_panel() -> void:
	if not root.visible: return
	
	root.hide()
	EditMode.set_show_mouse(false)
	if is_instance_valid(mouse_mode): mouse_mode.set_captured(true)


func load_gate(url: String) -> void:
	current.load_gate(url)
