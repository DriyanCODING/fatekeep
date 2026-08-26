extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0
var jumpcount = 0
var soul = 0
@onready var grass: AudioStreamPlayer2D = $GRASS
@onready var jumped: AudioStreamPlayer2D = $JUMPED

func _physics_process(delta: float) -> void:

		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumpcount = 0
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jumpcount < 2:
		jumped.play()
		velocity.y = JUMP_VELOCITY
		jumpcount += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		

	move_and_slide()
	

var health = 100
func _ready():
	add_to_group("player")
	
func take_damage(amount):
	health -= amount
	print("Player Health: ", health)
	if health <= 0:
		print("Died")
		get_tree().reload_current_scene()
	
	
	
