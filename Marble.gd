# pass
# tool
# class_name
# extends
extends KinematicBody
# # docstring

# signals
# enums
# constants
# exported variables
export var speed = 14
export var fall_acceleration = 75
# public variables
var velocity = Vector3.ZERO
# private variables
# onready variables

# optional built-in virtual _init method
# built-in virtual _ready method
# remaining built-in virtual methods
func _physics_process(delta):
	var direction = Vector3.ZERO
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("back"):
		direction.z += 1
	if Input.is_action_pressed("forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		# Vertical velocity
		velocity.y -= fall_acceleration * delta
		# Moving the character
		velocity = move_and_slide(velocity, Vector3.UP)

# public methods
# private methods
