extends Node3D

@export var sniper_tower_scene: PackedScene
@export var average_tower_scene: PackedScene

@export var hp = 100
@export var gold = 1000

signal updated
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
    updated.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func get_hp():
    return hp

func deal_damage(dmg):
    hp = max(0, hp - dmg)
    updated.emit()

    if hp == 0:
        game_over.emit()


func on_enemy_died(worth):
    gold += worth
    updated.emit()

func build_tower(position: Vector3, idx):
    var tower
    if idx == 0:
        tower = average_tower_scene.instantiate()
    else:
        tower = sniper_tower_scene.instantiate()
    tower.position = position
    get_node("/root/Main").add_child(tower)
    gold -= tower.worth
    updated.emit()


func _on_floor_input_event(camera, event, position, normal, shape_idx):
    var lmb: bool = event is InputEventMouseButton and event.pressed and event.button_index == 1
    var rmb: bool = event is InputEventMouseButton and event.pressed and event.button_index == 2
    if lmb and gold >= 100:
        build_tower(position, 0)
    if rmb and gold >= 150:
        build_tower(position, 1)



