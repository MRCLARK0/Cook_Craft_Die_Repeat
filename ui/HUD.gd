extends CanvasLayer

@onready var label: Label = $Label

var _player_ref: Player

func _process(_delta: float) -> void:
	_player_ref = get_tree().get_first_node_in_group("player")
	
	var display := ""
	for name in _player_ref.inventory:
		display += "%s x%d\n" % [name, _player_ref.inventory[name]]
	label.text = display
