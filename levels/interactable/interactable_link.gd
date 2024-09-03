extends InteractableBase

@export var link: String


func interact() -> void:
	OS.shell_open(link)
