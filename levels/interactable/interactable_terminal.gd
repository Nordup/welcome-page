extends InteractableBase
class_name InteractableTerminal

signal on_load_gate(url: String)
signal on_interact()


func interact() -> void:
	on_interact.emit()


func load_gate(url: String) -> void:
	on_load_gate.emit(url)
