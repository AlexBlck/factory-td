extends CharacterBody3D

@export var speed = 5
@export var damage = 20

func fire_towards(target):
    var flight_dir = position.direction_to(target.position).normalized()
    velocity = flight_dir * speed

func _physics_process(delta):
    # Iterate through all collisions that occurred this frame
    for index in range(get_slide_collision_count()):
        # We get one of the collisions with the player
        var collision = get_slide_collision(index)
        if collision.get_collider() == null:
            continue
        if collision.get_collider().is_in_group("enemy"):
            collision.get_collider().receive_damage(damage)
        queue_free()

    move_and_slide()
