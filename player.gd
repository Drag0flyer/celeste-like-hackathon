extends CharacterBody2D

const SPEED: float = 120.0
const JUMP_VELOCITY: float = -150.0
const GRAVITY: float = 700.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var jump_sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var death_sound: AudioStreamPlayer = $DeathSound
var is_dead: bool = false

func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.pitch_scale = randf_range(0.95, 1.05)
		jump_sound.play()

	# Déplacement gauche / droite
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func die() -> void:
		if is_dead:
				return
		is_dead = true
		death_sound.play()
		# Attend la fin du son (ou 0.4s) puis recharge la scène actuelle
		await get_tree().create_timer(0.4).timeout
		get_tree().reload_current_scene()
