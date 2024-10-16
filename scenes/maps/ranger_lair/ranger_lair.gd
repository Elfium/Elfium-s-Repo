class_name RangerLair
extends Node2D


var _pawn_scene : PackedScene = preload("res://scenes/characters/pawn/pawn.tscn")


var _pawn_spawn_points : Array[Vector2i] = [
	Vector2i(-5, -2),
	Vector2i(-9, -2),
]


func _ready() -> void :
	PawnManager.ref.farmers_updated.connect(_on_farmers_updated)


func fire_pawn() -> void :
	var pawns : Array[Node] = %Pawns.get_children()
	
	if pawns.size() > 0 :
		(pawns.back() as Node).queue_free()


func spawn_pawn() -> void : 
	var pawn_count : int = 0 + %Pawns.get_children().size()
	
	var node : Node2D = _pawn_scene.instantiate() as Node2D
	
	node.position = _pawn_spawn_points[int(pawn_count)] * 8
	%Pawns.add_child(node)


func synchronise_pawns(remote_farmers : int) -> void : 
	var local_farmers : int = %Pawns.get_children().size()
	var difference : int = remote_farmers - local_farmers
	
	if difference > 0 : 
		for i : int in range(0, difference) : 
			spawn_pawn()
	
	if difference < 0 : 
		for i : int in range(0, abs(difference)) : 
			fire_pawn()


func _on_farmers_updated(new_value : int) -> void :
	synchronise_pawns(new_value)
