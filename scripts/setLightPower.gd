extends PointLight2D

@export var light_change_speed : float = 1

var current_light_level : Vector2 = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = scale.lerp(current_light_level, delta * light_change_speed)
	
func increasePower(amount: float):
	current_light_level.x += amount
	current_light_level.y += amount
