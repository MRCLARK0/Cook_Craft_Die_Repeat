extends Area2D

@export var ingredient_name: String = "Mystery Meat"

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Picked up: ", ingredient_name)
		queue_free()
