extends Area2D

@export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

# Run as soon as the object/scene is ready in the game, done before everything else
func _ready():
	screen_size = get_viewport_rect().size

# For the player, we need to do the following:
	# Check for input.
	# Move in the given direction.
	# Play the appropriate animation.

#For example, if you hold right and down at the same time, 
	# the resulting velocity vector will be (1, 1). 
#In this case, since we’re adding a horizontal and a vertical movement, 
	# the player would move faster than if it just moved horizontally.

# Detect whether a key is pressed using Input.is_action_pressed(),
	# which returns true if it is pressed or false if it isn’t.
func _process(delta):
	# Start by setting the velocity to (0, 0)- player should not be moving
	var velocity = Vector2()  # The player's movement vector.

	# is_action_pressed is a function that maps to the key 
		# (This has been set in Project Settings => Input Map)
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		
	# Top Left of the screen is the Orgin! Thus 'y' gets bigger going down
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		# Normalize the velocity, which means we set its length to 1,
		# and multiply by the desired speed, thus no more fast diagonal movement.
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

#Clamping a value means restricting it to a given range.
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x !=0:
		$AnimatedSprite2D.animation = "right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0