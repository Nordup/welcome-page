extends Resource
class_name InteractableEvents

signal on_entered(text: String, interactable: InteractableBase)
signal on_exited(interactable: InteractableBase)


func on_entered_emit(text: String, interactable: InteractableBase) -> void:
	on_entered.emit(text, interactable)


func on_exited_emit(interactable: InteractableBase) -> void:
	on_exited.emit(interactable)
