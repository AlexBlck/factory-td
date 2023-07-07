extends Node3D

@export var hp = 100
@export var gold = 100

signal updated

# Called when the node enters the scene tree for the first time.
func _ready():
    updated.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func get_hp():
    return hp

func deal_damage(dmg):
    hp -= dmg
    updated.emit()
