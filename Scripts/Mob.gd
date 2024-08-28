extends RigidBody2D

@export var min_speed = 150  # Minimum speed range.
@export var max_speed = 250  # Maximum speed range.
var mob_types = ["walk", "swim", "fly"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Random value between min_speed and max_speed for how fast each mob will move
	$AnimatedSprite2D.animation = mob_types[randi() % mob_types.size()]

# Must use randomize() if you want your sequence of 
#   “random” numbers to be different every time you run the scene. 
# Going to use randomize() in Main scene, so we won’t need it here. 
#   randi() % n is the standard way to get a random integer between 0 and n-1.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Make the mobs delete themselves when they leave the screen. 
# Connect the screen_exited() signal of the Visibility node 

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Delete the mob in the scene
