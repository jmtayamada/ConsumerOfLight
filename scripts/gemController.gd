extends Node2D

const gemResource = preload("res://scenes/gem.tscn")

@export var lightIncreaseSpeed : float = .5
@export var lightDecreaseSpeed : float = -.1
@export var gemSpawnPositionsParent: Node2D
@export var playerSpawnLocation: Node2D

var gemSpawnPositions : Array[Node2D]

var rng = RandomNumberGenerator.new()

var lightLevelToWin : float = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	for I in gemSpawnPositionsParent.get_children():
		gemSpawnPositions.append(I)
	var gemInstance = gemResource.instantiate()
	gemInstance.name = "gem"
	self.add_child(gemInstance)
	$gem.body_entered.connect(playerGrabGem)
	$gem.position = gemSpawnPositions[randi() % gemSpawnPositions.size()].position
	move_child($gem, 1)
	$Player/PlayerLight.scale = Vector2(0, 0)
	$Player/PlayerLight.current_light_level = Vector2(0, 0)
	$Player.position = playerSpawnLocation.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/PlayerLight.increasePower(lightDecreaseSpeed * delta)
	$Player/Pointer.rotation = $gem.global_position.angle_to_point($Player.global_position) + PI/2
	if $Player/PlayerLight.scale.x >= 15:
		$Player.paused = true
		$Player/deathScreen.scale = $Player/deathScreen.scale.lerp(Vector2(100, 100), .25*delta)
		$Player/GameOverText.visible = true
		$Player/Title.visible = true
		$Player/CongratsText.visible = true
		$Player/Pointer.visible = false
		if Input.is_action_just_pressed("enter"):
			reset()
	if $Player/PlayerLight.scale.x <= 0:
		$Player.paused = true
		$Player/deathScreen.scale = $Player/deathScreen.scale.lerp(Vector2(100, 100), .25*delta)
		$Player/GameOverText.visible = true
		$Player/Title.visible = true
		$Player/Pointer.visible = false
		if Input.is_action_just_pressed("enter"):
			reset()

func reset():
	$Player.position = playerSpawnLocation.position
	$Player.rolling = false
	$Player/CongratsText.visible = false
	$Player.climbing = false
	$Player.velocity = Vector2(0, 0)
	$Player.paused = false
	$Player/Title.visible = false
	$Player/Pointer.visible = true
	$Player/deathScreen.scale = Vector2(0, 0)
	$Player/PlayerLight.scale = Vector2(1, 1)
	$Player/GameOverText.visible = false
	$Player/PlayerLight.current_light_level = Vector2(1, 1)
	$Player/startingLight.scale = Vector2(100, 100)
	
func playerGrabGem(a):
	$Player/PlayerLight.increasePower(lightIncreaseSpeed)
	$gem.name = "Gem"
	$Gem.queue_free()
	var gemInstance = gemResource.instantiate()
	gemInstance.name = "gem"
	self.add_child(gemInstance)
	$gem.body_entered.connect(playerGrabGem)
	$gem.position = gemSpawnPositions[randi() % gemSpawnPositions.size()].position
	move_child($gem, 1)
