extends StaticBody

export(Texture) onready var propTexture = $PropSprite.texture
export(Shape) onready var propCollision
export(bool) var pickup = false
export(int) var propType = 0

var interactor: Node

func _ready() -> void:
	propCollision = $CollisionShape.shape
	if pickup:
		$PickupDetection/CollisionShape.disabled = false

func _processPickup() -> void:
	if propType == 1:
		interactor.addHealth()
	if propType == 2:
		interactor.addAmmo(1)
	if propType == 3:
		interactor.addAmmo(2)

func _on_PickupDetection_body_entered(body: Node) -> void:
	interactor = body
	_processPickup()
	queue_free()
