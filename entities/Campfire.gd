extends Area2D

signal campfire_used

var player_in_range := false
@export var cooking_ui: NodePath

func _ready() -> void:
	add_to_group("campfire")
	
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	$Sprite2D.modulate = Color(1, 0.7, 0.2) # warm orange for debug
	visible = true
	
func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		var dungeon = get_tree().get_first_node_in_group("dungeon")
		if dungeon:
			print("Dungeon found, toggling campfire UI...")
			dungeon.toggle_campfire_ui(self)	

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		
