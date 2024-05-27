extends CharacterBody3D
var legtype = legset.treds
const sensetivity = .01
const SPEED = 9.0
var legspeed = 9
var legjump = 4.5
const JUMP_VELOCITY = 4.5
@onready var Head1 = $"head one"
@onready var Camra = $"head one/Camera3D"
@onready var body = $"."
var gravity = 9.8
enum legset {legs, roller, treds,}
var temphold = 2
func bodypartphys():
	if legtype == legset.legs:
		legspeed = SPEED * 1.5
		legjump = JUMP_VELOCITY * 1.3
	if legtype == legset.roller:
		legspeed = SPEED
		legjump = JUMP_VELOCITY * 0.7
	if legtype == legset.treds:
		legspeed = SPEED * 0.5
		print(legspeed)
func add(num1, num2):
	var result = num1 + num2
	return result

func _input(event):
	if event.is_action_pressed("abilitylegs") and !is_on_floor() and legtype == legset.roller:
		velocity.y = lerp(velocity.y,-SPEED *2,2)
		print("lerp")
	if event.is_action_pressed("esc"):
		get_tree().quit()
	if event.is_action_pressed("switchLegs1"):# temp leg swap
		if temphold == 3:
			print("roller")
			legtype = legset.roller
		if temphold == 2:
			print("legs")
			legtype = legset.legs
		if temphold == 4:
			print("treds")
			legtype = legset.treds
		if temphold ==4 or temphold > 4:
			temphold = 1
		temphold += 1
		print(temphold)
		bodypartphys()




func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	bodypartphys()
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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and legtype != legset.treds:
		velocity.y = legjump * 1.8
		velocity.x = 0
		velocity.z = 0
	if Input.is_action_just_pressed("abilitylegs") and is_on_floor() and legtype == legset.legs:
		$"../legabilitytimer".start()
	if $"../legabilitytimer".time_left != 0 and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var input_dir2 = Input.get_vector("left", "right", "backword", "forword")
		var direction2 = (body.transform.basis * Vector3(input_dir2.x, 0, input_dir2.y)).normalized()
		velocity.y = JUMP_VELOCITY * 1.4
		velocity.x = direction2.x * legspeed * 20
		velocity.z = direction2.z * legspeed * 20

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "backword", "forword")
	var direction = (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * legspeed, delta * 20)
			velocity.z = lerp(velocity.z, direction.z * legspeed, delta * 20)
		else:
		
			velocity.x = lerp(velocity.x, direction.x * legspeed, delta * 10)
			velocity.z = lerp(velocity.z, direction.z * legspeed, delta * 10)
	else:
		velocity.x = lerp(velocity.x, direction.x * legspeed, delta * 5)
		velocity.z = lerp(velocity.z, direction.z * legspeed, delta * 5)

