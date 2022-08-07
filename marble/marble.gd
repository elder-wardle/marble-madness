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

onready var min_ground_dot_product := cos(deg2rad(max_ground_angle))

func _process():
	var player_input := Vector2.ZERO
	player_input.x = Input.GetAxis("Horizontal")
	player_input.y = Input.GetAxis("Vertical")
	player_input = Vector2.clamped(playerInput, 1.0)

	var desired_velocity := Vector3(player_input.x, 0.0, player_input.y) * maxSpeed;

	desired_jump |= Input.GetButtonDown("Jump");

func _integrate_forces():
	update_state()
	adjust_velocity()

	if (desiredJump):
		desiredJump = false
		jump()

	linear_velocity = velocity
	clear_state()


func clear_state() -> void:
		ground_contact_count = 0
		contact_normal = Vector3.ZERO


func update_state() -> void:
	velocity = body.velocity;
	if on_ground:
		jump_phase = 0;
		if (ground_contact_count > 1):
			contact_normal.normalize()
	else:
		contact_normal = Vector3.UP


func adjust_velocity():
		var x_axis := project_on_contact_plane(Vector3.RIGHT).normalized
		var z_axis := project_on_contact_plane(Vector3.FORWARD).normalized

		var current_x := velocity.dot(x_axis)
		var current_z := velocity.dot(z_axis)

		var acceleration := max_acceleration if on_ground else max_air_acceleration
		var max_speed_change = acceleration * delta

		var new_x := move_toward(current_x, desired_velocity.x, max_speed_change)
		var new_z := move_toward(currentZ, desiredVelocity.z, max_speed_change)

		velocity += x_axis * (new_x - current_x) + z_axis * (new_z - current_z)
		

func jump() -> void:
	if (on_ground or jump_phase < max_air_jumps):
		jump_phase += 1
		var jump_speed := sqrt(-2.0 * Physics.gravity.y * jump_height)
		var aligned_speed := velocity.dot(contactNormal)
		if (aligned_speed > 0.0):
			jump_speed = max(jump_speed - aligned_speed, 0.0);
		velocity += contact_normal * jump_speed


func on_collision_enter (Collision collision) -> void:
	evaluate_collision(collision)


func on_collision_stay (Collision collision) -> void:
	evaluate_collision(collision)


func evaluate_collision (Collision collision) -> void:
	for (int i = 0; i < collision.contactCount; i++):
		var normal := collision.GetContact(i).normal
		if (normal.y >= min_groun_dot_product):
			ground_contact_count += 1
			contactnormal += normal


func project_on_contact_plane (Vector3 vector) -> Vector3:
		return vector - contact_normal * vector.dot(contact_normal)


func _get_on_ground():
	pass
