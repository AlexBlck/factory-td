extends CharacterBody3D

@export var health = 100
@export var movement_speed: float = 2.0
@export var dmg = 100
@export var worth = 10

@export var death_particles_scene: PackedScene

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var distance_travelled: float = 0.0
signal enemy_died(worth: int)

func _ready():
    # These values need to be adjusted for the actor's speed
    # and the navigation layout.
    navigation_agent.path_desired_distance = 0.5
    navigation_agent.target_desired_distance = 0.5

    # Make sure to not await during _ready.
    call_deferred("actor_setup")


func actor_setup():
    # Wait for the first physics frame so the NavigationServer can sync.
    await get_tree().physics_frame

    position = get_node("/root/Main/EnemySpawner").global_position
    var movement_target_position = get_node("/root/Main/Base").global_position
    navigation_agent.set_target_position(movement_target_position)

func reach_base():
    var gs = get_node("/root/Main/GameState")
    gs.deal_damage(dmg)
    queue_free()

func die():
    var gs = get_node("/root/Main/GameState")
    gs.on_enemy_died(worth)
    var death_particles = death_particles_scene.instantiate()
    death_particles.position = position
    get_node("/root/Main").add_child(death_particles)
    queue_free()

func receive_damage(dmg):
    health = max(0, health - dmg)
    $HpBar.mesh.material.set_shader_parameter("hp", health)
    if health == 0:
        die()

func adjust_difficulty(wave_num):
    var step = wave_num / 1
    health *= 1 + step / 10.0
    $HpBar.mesh.material.set_shader_parameter("max_hp", health)
    $HpBar.mesh.material.set_shader_parameter("hp", health)


func _physics_process(delta):
    $HpBar.rotation_degrees = Vector3(0,90,0)

    if navigation_agent.is_navigation_finished():
        return

    var current_agent_position: Vector3 = global_position
    var next_path_position: Vector3 = navigation_agent.get_next_path_position()
    var new_velocity: Vector3 = next_path_position - current_agent_position
    new_velocity = new_velocity.normalized()
    new_velocity = new_velocity * movement_speed

    # Iterate through all collisions that occurred this frame
    for index in range(get_slide_collision_count()):
        # We get one of the collisions with the player
        var collision = get_slide_collision(index)
        if collision.get_collider().is_in_group("base"):
            reach_base()

    velocity = new_velocity
    distance_travelled += velocity.length()
    move_and_slide()
