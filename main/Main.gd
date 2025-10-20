extends Node

@onready var dungeon: Node = $Dungeon

func _ready() -> void:
	print("Game started.")
	dungeon.generate_dungeon()
