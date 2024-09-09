extends Node
class_name InteractableInputHandler

@export var events: InteractableEvents

var current: InteractableBase


func _ready() -> void:
	events.on_entered.connect(on_interactable_entered)
	events.on_exited.connect(on_interactable_exited)


func on_interactable_entered(_text: String, interactable: InteractableBase) -> void:
	current = interactable


func on_interactable_exited(interactable: InteractableBase) -> void:
	if interactable != current: return
	current = null


func _input(event: InputEvent) -> void:
	if not is_instance_valid(current): return
	
	if event.is_action_pressed("interact"):
		print("pressed interact " + current.name)
		current.interact()
