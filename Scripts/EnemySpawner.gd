extends Node3D


@export var enemy_scene: PackedScene

func spawn_enemy():
    var enemy = enemy_scene.instantiate()
    enemy.position = global_position
    get_node("/root/Main").add_child(enemy)

func _on_timer_timeout():
    spawn_enemy() # Replace with function body.
