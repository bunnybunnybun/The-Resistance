extends Label

@onready var label: = $"."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween_speed: float = text.length()*0.05 
	visible_ratio = 0.0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(label, "visible_ratio", 1.0, tween_speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
