extends CharacterBody2D

@export var basic_move_speed : float = 960
@export var roll_speedup : float = 15
@export var roll_slowdown : float = 20
@export var time_to_peak : float = .4
@export var time_to_fall : float = .3
@export var jump_height : float = 160

@onready var jump_velocity : float = ((2.0 * jump_height) / time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (time_to_peak * time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (time_to_fall * time_to_fall)) * -1.0

var rolling : bool = false
var rolling_direction : float = 1

var double_jump_available : bool = true

var stored_horizontal_speed : float = 0
var climbing : bool = false
var previous_speed : float = 0
var other_previous_speed : float = 0
var climbing_time = 0

var paused = false


func _physics_process(delta):
	velocity.y += get_gravity() * delta
	var horizontal_direction = Input.get_axis("left", "right")
	
	if is_on_floor():
		climbing = false
		double_jump_available = true
		if Input.is_action_pressed("down") and !rolling:
			rolling = true
			rolling_direction = horizontal_direction
		if Input.is_action_just_pressed("up"):
			jump()
	else:
		if climbing:
			if !Input.is_action_pressed("up"):
				climbing = false
				velocity.x = -stored_horizontal_speed/2
				rolling = true
			if Input.is_action_pressed("up"):
				if climbing_time > 0:
					velocity.y -= get_gravity() * delta
					velocity.y = -abs(stored_horizontal_speed)
					climbing_time -= delta
				else:
					climbing = false
		if !climbing:
			if Input.is_action_just_pressed("up") and double_jump_available:
				jump()
				double_jump_available = false
				velocity.x = rolling_direction * horizontal_direction * velocity.x
				rolling_direction = horizontal_direction
			if Input.is_action_just_pressed("down"):
				velocity.y += fall_gravity * delta * 4
	
	if !Input.is_action_pressed("down") and rolling and abs(velocity.x) <= basic_move_speed:
		rolling = false
	if !rolling:
		velocity.x = basic_move_speed * horizontal_direction
	else:
		if is_on_wall() and !is_on_floor():
			rolling_direction *= -1
			rolling = false
			stored_horizontal_speed = other_previous_speed
			velocity.x = 0
			climbing = true
			climbing_time = abs(stored_horizontal_speed) / 10000
		if !Input.is_action_pressed("down") and (rolling_direction == horizontal_direction or horizontal_direction == 0):
			velocity.x = velocity.x
		elif Input.is_action_pressed("down") and (rolling_direction == horizontal_direction or horizontal_direction == 0):
			velocity.x += roll_speedup * rolling_direction
		else:
			if is_on_floor():
				velocity.x -= roll_slowdown * rolling_direction
			else:
				velocity.x -= roll_slowdown * rolling_direction
	if !paused:
		move_and_slide()
	
	other_previous_speed = previous_speed
	previous_speed = velocity.x

	
func get_gravity() -> float:

	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity - abs(velocity.x/2)
	
