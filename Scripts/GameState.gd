extends Node3D

@export var hp = 100
@export var gold = 100

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
