extends Node2D

################################
#                              #
#           EXPORTS            #
#                              #
################################
@export var room_scene: PackedScene
@export var enemy_scene: PackedScene
@export var ingredient_scene: PackedScene
@export var campfire_scene: PackedScene
@export var cooking_ui_scene: PackedScene
@export var grid_size: int = 3 

################################
#                              #
#           ON_READY           #
#                              #
################################
@onready var room_container: Node2D = $RoomContainer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var cooking_ui = get_tree().get_first_node_in_group("cooking_ui")

################################
#                              #
#             VARS             #
#                              #
################################
const ROOM_SIZE: int = 512
var rooms: Array = []
var current_room_coords := Vector2.ZERO
var campfire_active := false

################################
#                              #
#            START             #
#                              #
################################
func _ready() -> void:
	add_to_group("dungeon")
	player = get_tree().get_first_node_in_group("player")
	cooking_ui = get_tree().get_first_node_in_group("cooking_ui")
	add_child(cooking_ui)

func _process(_delta: float) -> void:
	check_player_room_transition()
	
func _on_enter_room(x: int, y: int) -> void:
	print("Entered room: ", x, ", ", y)
	center_camera_on_room(x, y)
	spawn_enemies_in_room(x, y)
	
	if randf() < 0.2: # 20% chance per room
		var campfire = campfire_scene.instantiate()
		campfire.global_position = Vector2(
			x * ROOM_SIZE + ROOM_SIZE / 2,
			y * ROOM_SIZE + ROOM_SIZE / 2
		)
		campfire.connect("campfire_used", _on_campfire_used)
		room_container.add_child(campfire)

func _on_enemy_defeated(pos: Vector2) -> void:
	var drop = ingredient_scene.instantiate()
	drop.global_position = pos
	room_container.add_child(drop)
	
################################
#                              #
#           CAMPFIRE           #
#                              #
################################
func _on_campfire_used() -> void:
	if cooking_ui.visible:
		cooking_ui.close()
	else:
		print("Opening campfire with inventory:", player.inventory)
		cooking_ui.open(player.inventory)
	
func _on_cook_started(ingredients: Dictionary):
	print("Cooking completed! Ingredients used: ", ingredients)

################################
#                              #
#           HELPERS            #
#                              #
################################
func generate_dungeon() -> void:
	clear_dungeon()
	print("Generating dungeon...")
	
	for y in range(grid_size):
		for x in range(grid_size):
			var room_instance = room_scene.instantiate()
			room_container.add_child(room_instance)
			room_instance.position = Vector2(x * ROOM_SIZE, y * ROOM_SIZE)
			room_instance.name = "Room_%d_%d" % [x, y]
			room_instance.configure_walls(x, y, grid_size)
			rooms.append(room_instance)
			
	# Place player
	var center_index := int(grid_size / 2)
	var center_room := get_room(center_index, center_index)
	if center_room:
		player.global_position = center_room.position + Vector2(256, 256)
		
func get_room(x: int, y: int) -> Node2D:
	for r in rooms:
		if r.name == "Room_%d_%d" % [x, y]:
			return r
	return null
	
func clear_dungeon() -> void:
	for r in rooms:
		r.queue_free()
	rooms.clear()
	
func check_player_room_transition() -> void:
	var room_x := int(player.global_position.x / ROOM_SIZE)
	var room_y := int(player.global_position.y / ROOM_SIZE)

	# Clamp so we don't go outside the grid
	room_x = clamp(room_x, 0, grid_size - 1)
	room_y = clamp(room_y, 0, grid_size - 1)

	var new_coords := Vector2(room_x, room_y)

	if new_coords != current_room_coords:
		current_room_coords = new_coords
		_on_enter_room(room_x, room_y)

func spawn_enemies_in_room(x: int, y: int) -> void:
	var enemy_count := randi_range(1, 3)
	for i in range(enemy_count):
		var enemy = enemy_scene.instantiate()
		enemy.global_position = Vector2(
			x * ROOM_SIZE + randf_range(100, ROOM_SIZE - 100),
			y * ROOM_SIZE + randf_range(100, ROOM_SIZE - 100),
		)
		enemy.connect("enemy_defeated", _on_enemy_defeated)
		room_container.add_child(enemy)
		
func center_camera_on_room(x: int, y: int) -> void:
	var center_pos := Vector2(
		x * ROOM_SIZE + ROOM_SIZE / 2,
		y * ROOM_SIZE + ROOM_SIZE /2
	)

func toggle_campfire_ui(campfire: Node):
	if not player or not cooking_ui:
		print("Missing player or UI reference")
		return
	campfire_active = !campfire_active
	if campfire_active:
		cooking_ui.open(player.inventory)
	else:
		cooking_ui.close()
