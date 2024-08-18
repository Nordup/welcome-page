@tool
extends Node3D

@export var viewport: Viewport
@export var mesh: MeshInstance3D
@export var print_log: bool

var mesh_copy: MeshInstance3D


func _enter_tree() -> void:
	start()


func _exit_tree() -> void:
	stop()


func start() -> void:
	if not is_instance_valid(viewport): return
	if viewport == null: return
	
	mesh.visible = false
	
	mesh_copy = mesh.duplicate() as MeshInstance3D
	mesh_copy.visible = true
	add_child(mesh_copy)
	
	mesh_copy.material_override = mesh_copy.material_override.duplicate(true)
	(mesh_copy.material_override as StandardMaterial3D).albedo_texture = viewport.get_texture()
	try_print(name + " mesh copy displayed")


func stop() -> void:
	mesh.visible = true
	
	if is_instance_valid(mesh_copy):
		remove_child(mesh_copy)
		mesh_copy.queue_free()
		try_print(name + " mesh copy removed")


func try_print(text: Variant) -> void:
	if print_log: print(text)
