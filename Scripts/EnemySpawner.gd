extends Node3D


@export var enemy_scenes: Array[PackedScene]

var wave_number: int = 0

func _ready():
    spawn_wave()

func spawn_enemy(idx):
    var enemy = enemy_scenes[idx].instantiate()
    enemy.position = global_position
    enemy.adjust_difficulty(wave_number)
    get_node("/root/Main").add_child(enemy)

func spawn_wave():
    var idx = randi_range(0, 1)

    var min_enemies = 5 + wave_number
    for i in range(randi_range(min_enemies, min_enemies + 5)):
        await $SpawnTimer.timeout
        spawn_enemy(idx)
    wave_number += 1



func _on_wave_timer_timeout():
    spawn_wave()
