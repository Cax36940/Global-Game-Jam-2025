extends Control


const X = 200
const Y = 30
const W = 2.0
var quantity = 1.0

func _draw() -> void:
	draw_rect(Rect2(Vector2(0, 0), Vector2(X, Y)), Color("ffffff"), false, W)
	draw_rect(Rect2(Vector2(W, W), Vector2(quantity*(X-2*W), Y-2*W)), Color("ff0000"), true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
