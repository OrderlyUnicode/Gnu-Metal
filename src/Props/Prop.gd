extends StaticBody

export(Texture) onready var propTexture = $PropSprite.texture
export(Shape) onready var propCollision = $CollisionShape.shape
export(bool) onready var pickup = false

func _ready() -> void:
	pass
