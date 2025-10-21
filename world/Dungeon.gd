extends Node2D

@export var room_scene: PackedScene
@export var grid_size: int = 3 # simple 3x3 grid
@onready var room_container: Node2D = $RoomContainer
@onready var player: Node2D = $Player

const ROOM_SIZE: int = 512

var rooms: Array = []

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
	
var current_room_coords := Vector2.ZERO

func _process(_delta: float) -> void:
	check_player_room_transition()

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

func _on_enter_room(x: int, y: int) -> void:
	print("Entered room: ", x, ", ", y)
