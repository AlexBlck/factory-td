extends CharacterBody3D

@export var projectile_scene: PackedScene
@export var cooldown: float = 0.5
var visible_targets: Array[CharacterBody3D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
    $Timer.wait_time = cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _on_area_3d_body_entered(body):
    if len(visible_targets) == 0:
        $Timer.start()
    visible_targets.push_back(body)

func _on_area_3d_body_exited(body):
    visible_targets.erase(body)
    if len(visible_targets) == 0:
        $Timer.stop()

func _on_timer_timeout():
    fire()

func fire():
    var projectile = projectile_scene.instantiate()
    projectile.position = global_position
    get_node("/root/Main").add_child(projectile)
    projectile.fire_towards(visible_targets.front())
