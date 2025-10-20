extends Node2D

@onready var background: ColorRect = $Background

func _ready() -> void:
	background.color = Color(0.2 + randf() * 0.8, 0.2 + randf() * 0.8, 0.2 + randf() * 0.8)
