extends RigidBody

export(float) var maxSpeed := 10.0;

export(float, 100.0) var maxAcceleration := 10.0
export(float, 100.0) var maxAirAcceleration := 1.0

export(float, 10.0) var jumpHeight := 2.0
export(int, 5) var maxAirJumps := 0

export(float, 90.0) var maxGroundAngle := 25.0

onready var body;

var velocity: Vector3
var desiredVelocity: Vector3

var contactNormal: Vector3

var desiredJump: bool

var groundContactCount: int

varOnGround: bool
  get:
      groundContactCount > 0;

	  var jumpPhase: int

	  @onready var minGroundDotProduct := cos(deg2rad(maxGroundAngle))

	  	void Update () {
				Vector2 playerInput;
						playerInput.x = Input.GetAxis("Horizontal");
								playerInput.y = Input.GetAxis("Vertical");
										playerInput = Vector2.ClampMagnitude(playerInput, 1f);

												desiredVelocity =
															new Vector3(playerInput.x, 0f, playerInput.y) * maxSpeed;

																	desiredJump |= Input.GetButtonDown("Jump");
																		}

																		func _process() {
																				UpdateState();
																						AdjustVelocity();

																								if (desiredJump) {
																											desiredJump = false;
																														Jump();
																																}

																																		body.velocity = velocity;
																																				ClearState();
																																					}

																																						void ClearState () {
																																								groundContactCount = 0;
																																										contactNormal = Vector3.zero;
																																											}

																																												void UpdateState () {
																																														velocity = body.velocity;
																																																if (OnGround) {
																																																			jumpPhase = 0;
																																																						if (groundContactCount > 1) {
																																																										contactNormal.Normalize();
																																																													}
																																																															}
																																																																	else {
																																																																				contactNormal = Vector3.up;
																																																																						}
																																																																							}

																																																																								void AdjustVelocity () {
																																																																										Vector3 xAxis = ProjectOnContactPlane(Vector3.right).normalized;
																																																																												Vector3 zAxis = ProjectOnContactPlane(Vector3.forward).normalized;

																																																																														float currentX = Vector3.Dot(velocity, xAxis);
																																																																																float currentZ = Vector3.Dot(velocity, zAxis);

																																																																																		float acceleration = OnGround ? maxAcceleration : maxAirAcceleration;
																																																																																				float maxSpeedChange = acceleration * Time.deltaTime;

																																																																																						float newX =
																																																																																									Mathf.MoveTowards(currentX, desiredVelocity.x, maxSpeedChange);
																																																																																											float newZ =
																																																																																														Mathf.MoveTowards(currentZ, desiredVelocity.z, maxSpeedChange);

																																																																																																velocity += xAxis * (newX - currentX) + zAxis * (newZ - currentZ);
																																																																																																	}

																																																																																																		void Jump () {
																																																																																																				if (OnGround || jumpPhase < maxAirJumps) {
																																																																																																							jumpPhase += 1;
																																																																																																										float jumpSpeed = Mathf.Sqrt(-2f * Physics.gravity.y * jumpHeight);
																																																																																																													float alignedSpeed = Vector3.Dot(velocity, contactNormal);
																																																																																																																if (alignedSpeed > 0f) {
																																																																																																																				jumpSpeed = Mathf.Max(jumpSpeed - alignedSpeed, 0f);
																																																																																																																							}
																																																																																																																										velocity += contactNormal * jumpSpeed;
																																																																																																																												}
																																																																																																																													}

																																																																																																																														void OnCollisionEnter (Collision collision) {
																																																																																																																																EvaluateCollision(collision);
																																																																																																																																	}

																																																																																																																																		void OnCollisionStay (Collision collision) {
																																																																																																																																				EvaluateCollision(collision);
																																																																																																																																					}

																																																																																																																																					func EvaluateCollision (Collision collision) -> void:
																																																																																																																																						for (int i = 0; i < collision.contactCount; i++):
																																																																																																																																								var normal := collision.GetContact(i).normal
																																																																																																																																										if (normal.y >= minGroundDotProduct):
																																																																																																																																													groundContactCount += 1;
																																																																																																																																																contactNormal += normal;

																																																																																																																																																	Vector3 ProjectOnContactPlane (Vector3 vector) {
																																																																																																																																																			return vector - contactNormal * Vector3.Dot(vector, contactNormal);
																																																																																																																																																				}
																																																																																																																																																				}

																																																																																																																																																				signals
																																																																																																																																																				06. enums
																																																																																																																																																				07. constants
																																																																																																																																																				08. exported variables
																																																																																																																																																				09. public variables
																																																																																																																																																				10. private variables
																																																																																																																																																				11. onready variables

																																																																																																																																																				12. optional built-in virtual _init method
																																																																																																																																																				13. built-in virtual _ready method
																																																																																																																																																				14. remaining built-in virtual methods
																																																																																																																																																				15. public methods
																																																																																																																																																				16. private methods