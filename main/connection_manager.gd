extends Node

@export var connection: Connection
@export var connection_status: ConnectionStatus

const RECONNECT_DELAY = 15

var connected: bool


func _ready():
	if Connection.is_server(): return
	
	connection.connected.connect(on_connected)
	connection.disconnected.connect(on_disconnected)
	start_connection()


func start_connection() -> void:
	# wait for local player
	await get_tree().create_timer(1).timeout
	connection.start_client()
	
	connection_status.set_status(ConnectionStatus.Status.CONNECTING)


func on_connected() -> void:
	connected = true
	connection_status.set_status(ConnectionStatus.Status.CONNECTED)


func on_disconnected() -> void:
	if connected: connection_status.set_status(ConnectionStatus.Status.DISCONNECTED)
	else: connection_status.set_status(ConnectionStatus.Status.FAILED_TO_CONNECT)
	connected = false
	
	print("Wait %d seconds and try connecting again" % [RECONNECT_DELAY])
	await get_tree().create_timer(RECONNECT_DELAY).timeout
	connection.start_client()
	
	connection_status.set_status(ConnectionStatus.Status.CONNECTING)
