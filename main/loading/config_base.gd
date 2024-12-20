extends Node
class_name ConfigBase

var config: ConfigFile
var config_path: String


func _init(path: String) -> void:
	config = ConfigFile.new()
	config.load(path)
	config_path = path


func get_string(section: String, key: String) -> String:
	var value: String
	if config.has_section_key(section, key):
		value = config.get_value(section, key)
#		Debug.log_msg(key + "=" + value)
	else: Debug.log_msg("don't have section " + section + ", key " + key)
	return value


func get_value(section: String, key: String) -> Variant:
	var value: Variant
	if config.has_section_key(section, key):
		value = config.get_value(section, key)
#		Debug.log_msg(key + "=" + str(value))
	else: Debug.log_msg("don't have section " + section + ", key " + key)
	return value


func get_sections() -> PackedStringArray:
	return config.get_sections()


func get_section_keys(section: String) -> PackedStringArray:
	var keys: PackedStringArray
	if config.has_section(section):
		keys = config.get_section_keys(section)
#		Debug.log_msg(keys)
	else: Debug.log_msg("don't have section " + section)
	return keys


func set_value(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value)
