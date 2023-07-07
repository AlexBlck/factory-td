extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _process(delta):
    if Input.is_action_just_released("quit"):
        get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
        get_tree().quit()
