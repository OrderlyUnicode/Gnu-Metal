extends KinematicBody

#export variables
export(Texture) var gun
export(int) var weapon = 1
#variables
var _dir: Vector2
var _sp: Vector3= Vector3(10.0,-1.0,10.0)
var fireRate: float = 0.1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		_fire(weapon)
		
	if event.is_action_pressed("weapon_cycle"):
		weapon +=1
		if weapon > 2:
			weapon = 1

	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * 0.03)
		$Camera.rotate_x(-event.relative.y * 0.03)

func _physics_process(_delta: float) -> void:
	if weapon == 1:
		$UI/RifleSprite.visible = true
		$UI/PistolSprite.visible = false
	elif weapon == 2:
		$UI/RifleSprite.visible = false
		$UI/PistolSprite.visible = true

	var _vel: Vector3 = Vector3.ZERO	
	#really basic movement/look(controller) via get_action_strenght being set to a direction vector	
	_dir = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	_dir = _dir.normalized()
	self.rotate_y((Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	 * 0.25) * -1)
	$Camera.rotate_x((Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	 * 0.25) * -1)
	
	_vel += (global_transform.basis.x * _dir.x) * _sp.x
	_vel += (global_transform.basis.z * _dir.y) * _sp.z
	_vel = move_and_slide(_vel)


func _fire(weapon: int) -> void:
	var weponSel: Node
	if weapon == 1:
		weponSel = $UI/RifleSprite/WeaponFlash
		fireRate = 0.1
	elif weapon == 2:
		weponSel = $UI/PistolSprite/WeaponFlash
		fireRate = 0.25
	
	weponSel.visible = true
	$Camera/MuzzleLight.visible = true
	if $Camera/RayCast.is_colliding() and $Camera/RayCast.get_collider().get_collision_layer_bit(2):
		$Camera/RayCast.get_collider().damage()
	yield(get_tree().create_timer(fireRate), "timeout")
	weponSel.visible = false
	$Camera/MuzzleLight.visible = false
