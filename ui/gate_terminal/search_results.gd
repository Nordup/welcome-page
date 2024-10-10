extends VBoxContainer

const NEW_COUNT = 3

@export var exclude_url: String
@export var api: ApiSettings
@export var panel: TerminalPanel
@export var result_scene: PackedScene

var result_str: String = "{}"
var new_id_max: int


func _ready() -> void:
	if Connection.is_server(): return
	search(".")


func search(query: String) -> void:
	await search_request(query)
	
	var gates = JSON.parse_string(result_str)
	if gates == null or gates.is_empty():
		print("No gates found")
		return
	
	var new_gates = find_new_gates(gates)
	for gate in gates:
		if gate["url"] == exclude_url: continue
		print(gate["url"])
		
		var result: SearchResult = result_scene.instantiate()
		result.fill(gate, panel, gate in new_gates)
		add_child(result)


func search_request(query: String) -> void:
	var url = api.search + query.uri_encode()
	var callback = func(_result, code, _headers, body):
		if code == 200:
			result_str = body.get_string_from_utf8()
		else: print("Request search failed. Code " + str(code))
	
	var err = await Backend.request(url, callback)
	if err != HTTPRequest.RESULT_SUCCESS: print("Cannot send request search")


func find_new_gates(gates: Array) -> Array:
	var ids = []
	for gate in gates:
		var id = int(gate["id"])
		ids.append(id)
	ids.sort()
	
	var new_ids = []
	if ids.size() > NEW_COUNT:
		for i in range(NEW_COUNT):
			new_ids.append(ids.pop_back())
	else:
		new_ids = ids
	
	var new_gates = []
	for gate in gates:
		var id = int(gate["id"])
		if id in new_ids:
			new_gates.append(gate)
	
	return new_gates
