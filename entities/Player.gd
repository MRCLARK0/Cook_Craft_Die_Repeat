extends CharacterBody2D

@export var move_speed: float  = 200.0
@export var attack_range: float = 24.0
@export var attack_cooldown: float = 0.4

var can_attack: bool = true

func _process(_delta):
	if Input.is_action_just_pressed("attack") and can_attack:
		perform_attack()
		
func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * move_speed
	move_and_slide()

func perform_attack():
	can_attack = false
	print("Player attacked!")
	for body in get_tree().get_nodes_in_group("enemies"):
		if global_position.distance_to(body.global_position) < attack_range:
			body.take_damage(1)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
