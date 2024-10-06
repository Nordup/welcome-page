extends Resource
class_name TerminalEvents

signal on_entered(interactable: InteractableTerminal)
signal on_exited(interactable: InteractableTerminal)


func on_entered_emit(interactable: InteractableTerminal) -> void:
	on_entered.emit(interactable)


func on_exited_emit(interactable: InteractableTerminal) -> void:
	on_exited.emit(interactable)
