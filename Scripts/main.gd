extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
    $HUD/Retry.hide()

func _process(delta):
    if Input.is_action_just_released("quit"):
        get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
        get_tree().quit()


# Press enter to retry
func _unhandled_input(event):
    if event.is_action_pressed("ui_accept") and $HUD/Retry.visible:
        # This restarts the current scene.
        get_tree().reload_current_scene()


func _on_game_state_game_over():
    $HUD/Retry.show()
