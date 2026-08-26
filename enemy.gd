extends CharacterBody2D

@export var speed: float = 120.0
@export var gravity: float = 1000.0
@export var attack_range: float = 50.0
@export var damage: int = 10
@export var attack_cooldown: float = 1.0

var player: Node2D = null
var cooldown: float = 0.0
var soul = 0
@export var soul_1: AudioStreamMP3


func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0


	# Reduce attack cooldown
	if cooldown > 0:
		cooldown -= delta


	# Find player if we don't have one
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		return


	# Distance between enemy and player
	var distance = global_position.distance_to(player.global_position)


	# Player is outside attack range
	if distance > attack_range:

		# Move LEFT or RIGHT toward player
		if player.global_position.x < global_position.x:
			velocity.x = -speed
			$AnimatedSprite2D.flip_h = true

		else:
			velocity.x = speed
			$AnimatedSprite2D.flip_h = false


	# Player is inside attack range
	else:
		velocity.x = 0

		if cooldown <= 0:
			attack()


	# Move the enemy
	move_and_slide()


func attack():
	cooldown = attack_cooldown

	if player.has_method("take_damage"):
		player.take_damage(damage)

	print("Enemy attacked! Damage: ", damage)
	
# PLAYER HEALTH
var player_health: int = 100


func take_damage(amount):
	player_health -= amount
	print("Player Health: ", player_health)

	if player_health <= 0:
		print("PLAYER DIED")
		get_tree().reload_current_scene()
