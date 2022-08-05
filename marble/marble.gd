extends RigidBody

export(float) var max_speed

export(float, 100.0) var max_acceleration: float
export(float, 100.0) var max_air_acceleration: float

export(float, 10.0) var jump_height := 2.0
export(int, 5) var max_air_jumps := 0.0

export(float, 90.0) var max_ground_angle := 25.0

#onready var body

var velocity: Vector3
var target_velocity: Vector3

var contact_normal: Vector3

var desired_jump: bool

var ground_contact_count: int 
var on_ground: bool setget , _get_on_ground

var jump_phase: int


func _get_on_ground():
	pass
