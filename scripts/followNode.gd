extends Sprite2D

@export var Follow_Speed : float = 4.0
@export var Follow_Node : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	position = Follow_Node.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position.lerp(Follow_Node.position, delta * Follow_Speed)
