extends Label


func _on_game_state_updated():
    var gs = get_node("/root/Main/GameState")
    text = "Hp: %s\nGold: %s" % [gs.hp, gs.gold]

