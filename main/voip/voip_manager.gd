extends Node

@export var user_scn: PackedScene
@export var player_spawner: PlayerSpawner
@export var denoise_mic_input: bool = true

var opuschunked: AudioEffectOpusChunked
var denoiser_available: bool
var prepend: PackedByteArray = PackedByteArray()

var users = {} # {Peer ID: VoipUser}


func _ready() -> void:
	var mic_bus = AudioServer.get_bus_index("Record")
	opuschunked = AudioServer.get_bus_effect(mic_bus, 0)
	
	denoiser_available = opuschunked.denoiser_available()
	Debug.log_msg("Denoiser available: " + str(denoiser_available))
	print_audio_server_info()
	
	if Connection.is_server():
		AudioServer.remove_bus_effect(mic_bus, 0)
		AudioServer.remove_bus(mic_bus)
		return
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	player_spawner.player_spawned.connect(player_spawned)


func peer_connected(id: int) -> void:
	if id == 1: return
	
	var user = user_scn.instantiate() as VoipUser
	user.set_user_id(id)
	users[id] = user
	add_child(user, true)
	Debug.log_msg("Voip user added " + str(id))
	
	var player = player_spawner.get_player_or_null(id)
	if is_instance_valid(player): user.set_anchor(player)


func peer_disconnected(id: int) -> void:
	if id == 1: return
	
	users[id].queue_free()
	users.erase(id)
	Debug.log_msg("Voip user removed " + str(id))


func player_spawned(id: int, player: Player) -> void:
	if users.has(id): users[id].set_anchor(player)


func _physics_process(_delta: float) -> void:
	if Connection.is_server(): return
	
	var accumulated_opusdata: Array[PackedByteArray] = []
	while opuschunked.chunk_available():
		if not should_send_opus_data():
			opuschunked.drop_chunk()
			continue
		
		if denoiser_available and denoise_mic_input:
			opuschunked.denoise_resampled_chunk()
		
		var opusdata: PackedByteArray = opuschunked.read_opus_packet(prepend)
		opuschunked.drop_chunk()
		accumulated_opusdata.append(opusdata)
	
	if should_send_opus_data() and accumulated_opusdata.size() > 0:
		rpc("opus_data_received", accumulated_opusdata)


func should_send_opus_data() -> bool:
	return Microphone.is_speaking and Connection.is_peer_connected


@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func opus_data_received(opusdata_array: Array[PackedByteArray]) -> void:
	if Connection.is_server(): return
	
	var sender_id = multiplayer.get_remote_sender_id()
	users[sender_id].opuspacketsbuffer.append_array(opusdata_array)


func print_audio_server_info() -> void:
	# For debugging sample rate issues
	Debug.log_msg("AudioServer:")
	Debug.log_msg("Input device list: " + str(AudioServer.get_input_device_list()))
	Debug.log_msg("Output device list: " + str(AudioServer.get_output_device_list()))
	Debug.log_msg("Input mix rate: " + str(AudioServer.get_input_mix_rate()))
	Debug.log_msg("Output mix rate: " + str(AudioServer.get_mix_rate()))
