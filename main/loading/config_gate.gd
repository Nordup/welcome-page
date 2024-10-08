extends ConfigBase
class_name ConfigGate

var title: String
var description: String
var image_url: String
var resource_pack_url: String
var libraries: PackedStringArray

const section = "gate"
const libs_section = "libraries"


func _init(path: String, base_url: String) -> void:
	super._init(path)
	title = get_string(section, "title")
	description = get_string(section, "description")
	image_url = Url.join(base_url, get_string(section, "image"))
	#resource_pack_url = Url.join(base_url, get_string(section, "resource_pack"))
	#libraries = get_libraries(base_url)
