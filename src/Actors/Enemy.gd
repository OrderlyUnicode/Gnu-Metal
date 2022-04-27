extends KinematicBody
export(Texture) onready var charSprite
export(Shape) onready var charCollision
export(float) onready var speed = 4

var _dir: Vector3 = Vector3.ZERO
var _vel: Vector3 = Vector3.ZERO
var _health: int = 6

func _ready() -> void:
	$CollisionShape.shape = charCollision
	$CollisionShape/CharacterSprite.texture = charSprite

func _physics_process(_delta: float) -> void:
	if _health <= 0:
		queue_free()
	_dir = Vector3(1.0, 0, 1.0)
	_vel = (_dir * speed).normalized()
	_vel = move_and_slide(_vel)

func damage(damage: float) -> void:
	_health -= damage
	$CollisionShape/CharacterSprite.modulate += Color(1.0, 0.0, 0.0, 1.0)

func patrol() -> void:
	pass

func chase(player: Node) -> void:
	self.look_at(player.global_transform, Vector3.UP)
	
func fire() -> void:
	$CollisionShape/CharacterSprite/MuzzleLight.visible = true
	$CollisionShape/CharacterSprite/RayCast.enabled = true
	if $CollisionShape/CharacterSprite/RayCast.is_colliding() and $CollisionShape/CharacterSprite/RayCast.get_collider().get_collision_mask_bit(1):
		print("lolwut")
	
	yield(get_tree().create_timer(0.1), "timeout")
	$CollisionShape/CharacterSprite/MuzzleLight.visible = false
	$CollisionShape/CharacterSprite/RayCast.enabled = false


func _on_FoV_body_entered(body: Node) -> void:
	if body == KinematicBody:
		chase(body)
	pass # Replace with function body.
