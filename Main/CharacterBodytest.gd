extends CharacterBody3D
var floortemp = true
var velocityybefore = -20
var legtype = legset.treds
const sensetivity = .01
const SPEED = 9.0
var legspeed = 9
var legjump = 4.5
const JUMP_VELOCITY = 4.5
@onready var Head1 = $"head one"
@onready var Camra = $"head one/Camera3D"
@onready var body = $"."
var gravity = 12
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

func _input(event):
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
	if !is_on_floor():
		velocityybefore = velocity.y
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and legtype != legset.treds:
		velocity.y = legjump * 1.8
		velocity.x = 0
		velocity.z = 0
	if Input.is_action_just_pressed("abilitylegs") and is_on_floor():
		$"../legabilitytimer_one".start()
		
		
	if legtype == legset.legs:# leg abilitys
		if $"../legabilitytimer_one".time_left != 0 and Input.is_action_just_pressed("ui_accept") and is_on_floor():
			var input_dir2 = Input.get_vector("left", "right", "backword", "forword")
			var direction2 = (body.transform.basis * Vector3(input_dir2.x, 0, input_dir2.y)).normalized()
			velocity.y = JUMP_VELOCITY * 1.4
			velocity.x = direction2.x * legspeed * 20
			velocity.z = direction2.z * legspeed * 20
		if Input.is_action_pressed("abilitylegs") and is_on_floor():
			print("placeholderslide")
		if Input.is_action_just_pressed("abilitylegs2"):
			$"../legabilitytimer_one2".start()
		if Input.is_action_just_released("ui_accept"):
			if $"../legabilitytimer_one2".time_left >= 1:
				var timelefttimep = $"../legabilitytimer_one2".time_left
				$"../legabilitytimer_one2".stop()
				if is_on_floor():
					velocity.y = JUMP_VELOCITY * 6 * (2 - timelefttimep)
					$"../legabilitytimer_one2".stop()
		if Input.is_action_just_released("abilitylegs2"):
			if $"../legabilitytimer_one2".time_left >= 0.1:
				if is_on_floor():
					print($"../legabilitytimer_one2".time_left)
					velocity.y = JUMP_VELOCITY * 4 * (2 - $"../legabilitytimer_one2".time_left)
				else:
					velocity.y = JUMP_VELOCITY * 1.5 * (2 - $"../legabilitytimer_one2".time_left)
			
			
	if legtype == legset.roller:# roller abilitys
		if is_on_floor() and floortemp == true:
			$"../last_tuched_floor".start()
			floortemp = false
		if Input.is_action_just_pressed("abilitylegs") and !is_on_floor():
			
			floortemp = true
			if velocity.y >= 0:
				velocity.y = 0
			velocity.y -= 20
		if Input.is_action_just_pressed("abilitylegs") and is_on_floor():
			$"../legabilitytimer_one3".start()
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			if $"../legabilitytimer_one3".time_left >= 1.8:
				print("floomp")
		if Input.is_action_just_pressed("ui_accept") and $"../last_tuched_floor".time_left >= 0.1 and is_on_floor():
			print("stinky")
			print($"../last_tuched_floor".time_left)
			velocity.y = -velocityybefore/2
		if Input.is_action_just_pressed("abilitylegs2"):
			$"../legabilitytimer_one2".start()
		if Input.is_action_just_released("abilitylegs2"):
			if $"../legabilitytimer_one2".time_left >= 0.1:
				print($"../legabilitytimer_one2".time_left)
				$"../legabilitytimer_one2".stop()
				print("boom")
				if !Input.is_action_pressed("abilitylegs"):
					print("Kaboom")
			
	if legtype == legset.treds:# tred abiliteis
		pass

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

