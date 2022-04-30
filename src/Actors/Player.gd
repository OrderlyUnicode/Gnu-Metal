extends KinematicBody

#export variables
export(Texture) var gun
export(int) var weapon = 1
#variables
var _dir: Vector2
var _sp: Vector3= Vector3(10.0,-1.0,10.0)
var health: int = 10.0
var magAmmountAR: int
var magAmmountFN: int
var magTotalAR: int = 30
var magTotalFN: int = 12
var backAmmoAR: int = 60
var backAmmoFN: int = 24
var fireRate: float = 0.1
var weaponDamage: float = 2.0
var reloading: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	magAmmountAR = magTotalAR
	magAmmountFN = magTotalFN
	backAmmoAR -= magAmmountAR
	backAmmoFN -= magAmmountFN

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		if weapon == 1 and magAmmountAR > 0 and not reloading:
			_fire(weapon)
		elif weapon == 2 and magAmmountFN > 0 and not reloading:
			_fire(weapon)
		if weapon == 1 and magAmmountAR == 0 and backAmmoAR > 0:
			_reload()
		elif weapon == 2 and magAmmountFN == 0 and backAmmoFN > 0:
			_reload()

	if event.is_action_pressed("weapon_cycle"):
		weapon +=1
		if weapon > 2:
			weapon = 1

	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * 0.03)
		$Camera.rotate_x(-event.relative.y * 0.03)

func _physics_process(_delta: float) -> void:
	$UI/GameUI/HBoxContainer/HealthLabel.text = "Health: " + health as String
	
	if weapon == 1:
		$UI/RifleSprite.visible = true
		$UI/PistolSprite.visible = false
		$UI/GameUI/HBoxContainer/AmmoLabel.text = "Ammo: " + magAmmountAR as String + "/" + backAmmoAR as String
	elif weapon == 2:
		$UI/RifleSprite.visible = false
		$UI/PistolSprite.visible = true
		$UI/GameUI/HBoxContainer/AmmoLabel.text = "Ammo: " + magAmmountFN as String + "/" + backAmmoFN as String

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
		weaponDamage = 2.0
		magAmmountAR -= 1
	elif weapon == 2:
		weponSel = $UI/PistolSprite/WeaponFlash
		fireRate = 0.25
		weaponDamage = 1.0
		magAmmountFN -=1

	weponSel.visible = true
	$Camera/MuzzleLight.visible = true
	
	if $Camera/RayCast.is_colliding() and $Camera/RayCast.get_collider().get_collision_layer_bit(2):
		$Camera/RayCast.get_collider().damage(weaponDamage)
	yield(get_tree().create_timer(fireRate), "timeout")
	weponSel.visible = false
	$Camera/MuzzleLight.visible = false

func _reload() -> void:
	reloading = true
	yield(get_tree().create_timer(0.5), "timeout")
	if weapon == 1:
		magAmmountAR = magTotalAR
		backAmmoAR -= magAmmountAR
	if weapon == 2:
		magAmmountFN = magTotalFN
		backAmmoFN -= magAmmountFN
	reloading = false

func damage() -> void:
	health -= 2
	print(health)
	if health <= 0:
		get_tree().change_scene("res://scn/UI/MainMenu.tscn")

func addHealth():
	health += 2
	if health > 10:
		health = 10
	print("health added, health is now" + health as String)
	
func addAmmo(gunType: int):
	if gunType == 1:
		backAmmoAR += 30
	if gunType == 2:
		backAmmoFN += 12
