extends VBoxContainer

@export var exclude_url: String
@export var api: ApiSettings
@export var panel: TerminalPanel
@export var result_scene: PackedScene

var result_str: String = "{}"


func _ready() -> void:
	if Connection.is_server(): return
	search(".")


func search(query: String) -> void:
	await search_request(query)
	
	var gates = JSON.parse_string(result_str)
	if gates == null or gates.is_empty():
		print("No gates found")
		return
	
	for gate in gates:
		if gate["url"] == exclude_url: continue
		print(gate["url"])
		
		var result: SearchResult = result_scene.instantiate()
		result.fill(gate, panel)
		add_child(result)


func search_request(query: String) -> void:
	var url = api.search + query.uri_encode()
	var callback = func(_result, code, _headers, body):
		if code == 200:
			result_str = body.get_string_from_utf8()
		else: print("Request search failed. Code " + str(code))
	
	var err = await Backend.request(url, callback)
	if err != HTTPRequest.RESULT_SUCCESS: print("Cannot send request search")
