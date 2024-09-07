extends Control

signal start_server
signal connect_client

@export var hide_ui_and_connect: bool


func _ready():
	if Connection.is_server(): return
	
	if hide_ui_and_connect:
		# wait for local player
		await get_tree().create_timer(1).timeout
		connect_client_emit()
	else:
		show_ui()


func start_server_emit() -> void:
	start_server.emit()
	$MainMenu.visible = false


func connect_client_emit() -> void:
	connect_client.emit()
	hide_ui()


func disconnected() -> void:
	print("Wait 10 seconds and try connecting again")
	await get_tree().create_timer(10).timeout
	connect_client.emit()


func hide_ui() -> void:
	$MainMenu.visible = false
	$InGameUI.visible = true


func show_ui() -> void:
	$MainMenu.visible = true
	$InGameUI.visible = false
