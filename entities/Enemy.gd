extends CharacterBody2D

signal enemy_defeated

@export var move_speed: float = 100.0
@export var detection_radius: float = 150.0
@export var health: int = 3

var target: Node2D = null
var wander_direction: Vector2 = Vector2.RIGHT.rotated(randf() * TAU)
var wander_timer: float = 0.0

func _ready() -> void:
	$Area2D/CollisionShape2D.shape.radius = detection_radius
	$Area2D.connect("body_entered", _on_body_entered)
	$Area2D.connect("body_exited", _on_body_exited)
	
func _physics_process(delta: float) -> void:
	if target:
		var direction := (target.global_position - global_position).normalized()
		velocity = direction * move_speed
	else:
		wander_timer -= delta
		if wander_timer <= 0.0:
			wander_timer = randf_range(1.5, 3.0)
			wander_direction = Vector2.RIGHT.rotated(randf() * TAU)
		velocity = wander_direction * move_speed * 0.4
		
	move_and_slide()
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		target = body
		
func _on_body_exited(body: Node) -> void:
	if body == target:
		target = null
		
func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		emit_signal("enemy_defeated", self)
		queue_free()
		
