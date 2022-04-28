extends KinematicBody
export(Texture) onready var charSprite
export(Shape) onready var charCollision
export(float) onready var speed = 4

var target: Node
var _dir: Vector3 = Vector3.ZERO
var _vel: Vector3 = Vector3.ZERO
var _health: int = 6

func _ready() -> void:
	$CollisionShape.shape = charCollision
	$CollisionShape/CharacterSprite.texture = charSprite

func _physics_process(_delta: float) -> void:
	if _health <= 0:
		queue_free()
	if target != null:
		chase()
	
	_vel = (_dir * speed).normalized()
	_vel = move_and_slide(_vel)

func damage(damage: float) -> void:
	_health -= damage
	$CollisionShape/CharacterSprite.modulate += Color(1.0, 0.0, 0.0)

func patrol() -> void:
	_dir = Vector3(rand_range(-1.0, 1.0), 0.0, rand_range(-1.0, 1.0))

func chase() -> void:
	self.look_at(target.global_transform.origin, Vector3.UP)
	_dir = (target.global_transform.origin - global_transform.origin).normalized()

func fire() -> void:
	$CollisionShape/CharacterSprite/MuzzleLight.visible = true
	$CollisionShape/CharacterSprite/RayCast.enabled = true
	if $CollisionShape/CharacterSprite/RayCast.is_colliding() and $CollisionShape/CharacterSprite/RayCast.get_collider().get_collision_mask_bit(1):
		print("lolwut")
	
	yield(get_tree().create_timer(0.1), "timeout")
	$CollisionShape/CharacterSprite/MuzzleLight.visible = false
	$CollisionShape/CharacterSprite/RayCast.enabled = false

func _on_FoV_body_entered(body: Node) -> void:
	if body.get_collision_layer_bit(1):
		target = body

func _on_FoV_body_exited(body: Node) -> void:
	target = null
	patrol()
