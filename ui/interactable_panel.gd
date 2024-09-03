extends Node

@export var label: Label
@export var hint_root: Control
@export var events: InteractableEvents

var current: InteractableBase
var current_text: String


func _ready() -> void:
	events.on_entered.connect(on_interactable_entered)
	events.on_exited.connect(on_interactable_exited)
	hint_root.hide()


func on_interactable_entered(text: String, interactable: InteractableBase) -> void:
	current = interactable
	
	label.text = text
	hint_root.show()


func on_interactable_exited(interactable: InteractableBase) -> void:
	if interactable != current: return
	current = null
	
	hint_root.hide()
