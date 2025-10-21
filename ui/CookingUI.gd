extends CanvasLayer

signal cook_started(ingredients: Dictionary)
signal closed

@onready var panel := ColorRect.new()
@onready var label := RichTextLabel.new()
var _inventory_ref: Dictionary = {}

func _ready() -> void:
	add_to_group("cooking_ui")
	
	panel.color = Color(0.1, 0.1, 0.1, 0.85)
	panel.size = Vector2(300, 400)
	panel.position = Vector2(20, 20)
	add_child(panel)
	
	label.bbcode_enabled = true
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.position = Vector2(10, 10)
	label.size = Vector2(280, 380)
	panel.add_child(label)
	
	visible = false
	
func open(inventory: Dictionary):
	_inventory_ref = inventory
	visible = true
	_update_text()
	
func close(inventory: Dictionary):
	_inventory_ref = inventory
	visible = false
		
func _update_text():
	if !_inventory_ref:
		label.text = "(no inventory reference)"
		return
	
	label.clear()
	label.push_bold()
	label.add_text("Available Ingredients:\n\n")
	label.pop()
	
	if _inventory_ref.is_empty():
		label.add_text("(None)")
	else:
		for name in _inventory_ref:
			label.add_text("- %s × %d\n" % [name, _inventory_ref[name]])

func _on_cook_pressed():
	print("Cooking something...")
	emit_signal("cook_started", {"Mystery Meat": 1})
	
func _on_close_pressed():
	visible = false
	emit_signal("closed")
