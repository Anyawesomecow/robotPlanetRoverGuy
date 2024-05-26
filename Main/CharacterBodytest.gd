extends CharacterBody3D
var legtype
const sensetivity = .01
const SPEED = 8.0
const JUMP_VELOCITY = 4.5
@onready var Head1 = $"head one"
@onready var Camra = $"head one/Camera3D"
@onready var body = $"."
var gravity = 9.8
enum legset {legs, roller, treds,}
var temphold = 0
func add(num1, num2):
	var result = num1 + num2
	return result

func _input(event):
	if event.is_action_pressed("abilitylegs"):
		velocity.y = -20
	if event.is_action_pressed("esc"):
		get_tree().quit()
	if event.is_action_pressed("switchLegs1"):# temp leg swap
		temphold += 1
		if temphold == 0:
			print(legset.legs)
			legtype = legset.legs
		if temphold == 1:
			print(legset.roller)
			legtype = legset.roller
		if temphold == 2:
			print(legset.treds)
			legtype = legset.treds
		if temphold ==4 or temphold > 4:
			temphold = 0
		print("bob")
		print(temphold)




func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		body.rotate_y(-event.relative.x * sensetivity)
		Head1.rotate_x(event.relative.y * sensetivity)

func _physics_process(delta):
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * 1.8
		velocity.x = 0
		velocity.z = 0
	if Input.is_action_just_pressed("abilitylegs") and is_on_floor():
		$"../legabilitytimer".start()
		print($"../legabilitytimer".time_left)
	if $"../legabilitytimer".time_left != 0 and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var input_dir2 = Input.get_vector("left", "right", "backword", "forword")
		var direction2 = (body.transform.basis * Vector3(input_dir2.x, 0, input_dir2.y)).normalized()
		velocity.y = JUMP_VELOCITY * 1.4
		velocity.x = direction2.x * SPEED * 20
		velocity.z = direction2.z * SPEED * 20

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "backword", "forword")
	var direction = (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 10)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 10)
		else:
		
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7)
			print(velocity.z)
			print(velocity.x)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2)

