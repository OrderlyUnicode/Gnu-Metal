extends KinematicBody
export(Texture) onready var charSprite
export(Shape) onready var charCollision
export(float) onready var speed = 4

var target: Node
var _dir: Vector3 = Vector3.ZERO
var _vel: Vector3 = Vector3.ZERO
var _health: int = 6

func _ready() -> void:
	$ShotTimer.wait_time = rand_range(0.5, 2.0)
	$CollisionShape.shape = charCollision
	$CollisionShape/CharacterSprite.texture = charSprite

func _physics_process(_delta: float) -> void:
	if _health <= 0:
		queue_free()
	if target != null:
		self.look_at(target.global_transform.origin, Vector3.UP)
		_dir = (target.global_transform.origin - global_transform.origin).normalized()
	
	if Input.is_action_just_pressed("force_fire"):
		fire()
	
	_vel = (_dir * speed).normalized()
	_vel = move_and_slide(_vel)

func damage(damage: float) -> void:
	_health -= damage
	$CollisionShape/CharacterSprite.modulate += Color(1.0, 0.0, 0.0)

func _patrol() -> void:
	$CollisionShape/CharacterSprite/RayCast.enabled = false
	_dir = Vector3(rand_range(-1.0, 1.0), 0.0, rand_range(-1.0, 1.0))
	yield(get_tree().create_timer(rand_range(15.0, 30.0)), "timeout")
	_dir *= -1

func chase() -> void:
	$CollisionShape/CharacterSprite/RayCast.enabled = true
	$CollisionShape/CharacterSprite.frame = 1
	$ShotTimer.start()


func fire() -> void:
	$CollisionShape/CharacterSprite/RayCast.translation = Vector3(rand_range(-0.35, 0.35), rand_range(-0.35, 0.35), 0)
	$CollisionShape/CharacterSprite/MuzzleLight.visible = true
	if $CollisionShape/CharacterSprite/RayCast.is_colliding():
		target.damage()
	$CollisionShape/CharacterSprite/MuzzleLight.visible = false

func _on_FoV_body_entered(body: Node) -> void:
	if body.get_collision_layer_bit(1):
		target = body
		chase()

func _on_FoV_body_exited(body: Node) -> void:
	target = null
	$CollisionShape/CharacterSprite.frame = 0
	_patrol()

func _on_ShotTimer_timeout() -> void:
	fire()
	$ShotTimer.wait_time = rand_range(0.5, 2.0)
