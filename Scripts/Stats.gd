extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_game_state_updated():
    var gs = get_node("/root/Main/GameState")
    text = "Hp: %s\nGold: %s" % [gs.hp, gs.gold]
