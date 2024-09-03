extends Node3D

@export var url: String


func _on_portal_entered(body):
	if not body is Player: return
	play_enter_audio()
	
	if body.get_multiplayer_authority() != multiplayer.get_unique_id(): return
	
	print("Portal_entered: " + url)
	await get_tree().create_timer(0.3).timeout
	
	if get_tree().has_method("send_command"):
		get_tree().send_command("open_link", [url])
	else:
		push_warning("Tree doesn't have method send_command. Do nothing")


func play_enter_audio():
	$AudioStreamPlayer3D.play()
