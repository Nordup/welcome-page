extends Button

@export var panel: TerminalPanel
@export var line_edit: LineEdit


func _ready() -> void:
	pressed.connect(load_gate)


func load_gate() -> void:
	panel.load_gate(line_edit.text)
