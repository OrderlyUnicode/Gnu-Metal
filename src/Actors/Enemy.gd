extends KinematicBody
export(Texture) onready var charSprite
export(Shape) onready var charCollision

var _dir: Vector3 = Vector3.ZERO
var _health: int = 6

func _ready() -> void:
	$CollisionShape.shape = charCollision
	$CollisionShape/CharacterSprite.texture = charSprite

func _physics_process(_delta: float) -> void:
	if _health <= 0:
		queue_free()

func damage():
	_health -=2
	$CollisionShape/CharacterSprite.modulate += Color(1.0, 0.0, 0.0, 1.0)
