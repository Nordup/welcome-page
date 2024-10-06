extends InteractableBase
class_name InteractableTerminal

signal on_load_gate(url: String)

@export var terminal_events: TerminalEvents


func entered() -> void:
	terminal_events.on_entered_emit(self)


func exited() -> void:
	terminal_events.on_exited_emit(self)


func load_gate(url: String) -> void:
	on_load_gate.emit(url)
