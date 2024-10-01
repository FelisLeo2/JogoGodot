extends CharacterBody3D


const MIN_FLIGHT_SPEED=10
const MAX_FLIGHT_SPEED=30
const TURN_SPEED:float = 0.75
const PITCH_SPEED:float = 0.5
const LEVEL_SPEED:float = 3.0
const PLANE_ACCELERATION:float = 6.0
const THROTLE_DELTA = 30
const GRAVITY = 10

var forward_speed: float = 0.0
var target_speed:float = 0.0

var turn_input:float =0
var pitch_input = 0

func _ready() -> void:
	pass
	
func rotate_helice(delta: float) -> void:
	$Aviao_object/Body/helice.rotate(Vector3(1,0,0), PI*delta*forward_speed)
	#$Aviao_object/Boneco3D/helice.rotate(Vector3(1,0,0), PI*delta*10)
func _physics_process(delta: float) -> void:
	#print(velocity)
	handle_input(delta)
	
	transform.basis = transform.basis.rotated(transform.basis.x,pitch_input*PITCH_SPEED*delta)
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input*TURN_SPEED*delta)
	if is_on_floor():
		$Aviao_object/Body.rotation.x = 0		
		velocity = transform.basis.z *0.9
	else:
		$Aviao_object/Body.rotation.x = lerp($Aviao_object/Body.rotation.x,-turn_input,LEVEL_SPEED*delta)

	forward_speed = lerp(forward_speed, target_speed, PLANE_ACCELERATION*delta)
	velocity = -transform.basis.z * forward_speed
	velocity.y -= GRAVITY
	print(velocity)
	move_and_slide()
	rotate_helice(delta)
	

func handle_input(delta: float) -> void:
	
	if Input.is_action_pressed("Throttle_up"):  # W para acelerar
		target_speed = min(forward_speed+THROTLE_DELTA*delta,MAX_FLIGHT_SPEED)
	
	elif Input.is_action_pressed("Throttle_down"):  # W para acelerar
		var limit = 0 if is_on_floor() else MIN_FLIGHT_SPEED
		target_speed = min(forward_speed-THROTLE_DELTA*delta,limit)
	turn_input = 0
	if forward_speed >0.5:
		turn_input = Input.get_action_strength("Roll_left") - Input.get_action_strength("Roll_right")

	if forward_speed >= MIN_FLIGHT_SPEED:
		pitch_input = Input.get_action_strength("Pitch_up") - Input.get_action_strength("Pitch_down")
		




		
