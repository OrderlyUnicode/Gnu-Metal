extends KinematicBody

#variables
var _dir: Vector2
var _lookDir: Vector2
var _sp: Vector3= Vector3(10.0,-1.0,10.0)
var inMenu: bool = false


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	#simplistic code to make sure menus can be navigated on pause
	if event.is_action_pressed("ui_cancel"):
		inMenu = not inMenu
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) if inMenu == false else Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * 0.03)
		$Camera.rotate_x(-event.relative.y * 0.03)
		pass
	
func _physics_process(_delta: float) -> void:
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
