extends StaticBody

export(Mesh) var propMesh
export(Shape) var propShape

func _ready() -> void:
	propMesh = $MeshInstance.mesh
	propShape = $CollisionShape.shape
