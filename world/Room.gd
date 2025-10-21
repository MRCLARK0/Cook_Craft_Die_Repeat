extends Node2D

@onready var background: ColorRect = $Background
@onready var wall_top: StaticBody2D = $Walls/WallTop
@onready var wall_bottom: StaticBody2D = $Walls/WallBottom
@onready var wall_left: StaticBody2D = $Walls/WallLeft
@onready var wall_right: StaticBody2D = $Walls/WallRight

func _ready() -> void:
	background.color = random_color()
	
# call from dungeon.gd after room creation
func configure_walls(x: int, y: int, grid_size: int) -> void:
	wall_top.visible = y == 0
	wall_bottom.visible = y == grid_size - 1
	wall_left.visible = x == 0
	wall_right.visible = x == grid_size - 1
	
	# disable collisions for hidden walls
	wall_top.get_node("CollisionShape2D").disabled = not wall_top.visible
	wall_bottom.get_node("CollisionShape2D").disabled = not wall_bottom.visible
	wall_left.get_node("CollisionShape2D").disabled = not wall_left.visible
	wall_right.get_node("CollisionShape2D").disabled = not wall_right.visible

func random_color() -> Color:
	return Color(randf(), randf(), randf())
