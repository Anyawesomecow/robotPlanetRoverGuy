extends CharacterBody3D
var legtype
const sensetivity = .01
const SPEED = 8.0
const JUMP_VELOCITY = 4.5
@onready var Head1 = $"head one"
@onready var Camra = $"head one/Camera3D"
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
	if event is InputEventMouseMotion:
		Head1.rotate_y(-event.relative.x * sensetivity)
		Camra.rotate_x(event.relative.y * sensetivity)
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * 2
		print("bob")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "backword", "forword")
	var direction = (Head1.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
