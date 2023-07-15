extends Panel

var selected_element

func update_tower_info(tower: CharacterBody3D):
    print("Click!")
    $MarginContainer/TurretInfo.visible = true
    for child in $MarginContainer/TurretInfo.get_children():
        child.visible = true
    $MarginContainer/TurretInfo/TurretName.text = "Tower"
    $MarginContainer/TurretInfo/Range/Label.text = "Range: %s" % tower.range
    $MarginContainer/TurretInfo/Damage.text = "Damage: %s" % tower.damage
    $MarginContainer/TurretInfo/AttackSpeed.text = "Attack speed: %s" % (1 / tower.cooldown)
    $MarginContainer/TurretInfo/AimOptions.select(tower.aim_strategy)

func select_clicked(clicked_object: CharacterBody3D):
    if selected_element != null:
        selected_element.toggle_selected(false)
    for child in $MarginContainer.get_children():
        child.visible = false
    selected_element = clicked_object
    selected_element.toggle_selected(true)
    if selected_element.is_in_group("Tower"):
        update_tower_info(selected_element)


func _on_aim_options_item_selected(index):
    selected_element.change_aim(index)

func _on_upgrade_range_pressed():
    selected_element.upgrade_range()
    update_tower_info(selected_element)
