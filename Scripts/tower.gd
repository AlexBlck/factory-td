extends CharacterBody3D

@export var projectile_scene: PackedScene
@export var cooldown: float = 0.5
@export var worth: int = 100
@export var range: float = 5
@export var damage: int = 25
@export var projectile_speed: int = 25
var visible_targets: Array[CharacterBody3D] = []
var current_target: CharacterBody3D
var ui_panel: Panel
var aim_strategy = AimStrategy.WEAKEST

var debug_line

enum AimStrategy {FIRST, LAST, STRONGEST, WEAKEST, CLOSEST}

func line(pos1: Vector3, pos2: Vector3, color = Color.ORANGE_RED) -> MeshInstance3D:
    var mesh_instance := MeshInstance3D.new()
    var immediate_mesh := ImmediateMesh.new()
    var material := ORMMaterial3D.new()

    mesh_instance.mesh = immediate_mesh
    mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

    immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
    immediate_mesh.surface_add_vertex(pos1)
    immediate_mesh.surface_add_vertex(pos2)
    immediate_mesh.surface_end()

    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    material.albedo_color = color

    get_tree().get_root().add_child(mesh_instance)

    return mesh_instance

# Called when the node enters the scene tree for the first time.
func _ready():
    $RangeArea/RangeCollider.shape.radius = range
    $RangeArea/RangeIndicator.mesh.radius = range
    $RangeArea/RangeIndicator.mesh.height = range * 2
    $Timer.wait_time = cooldown
    ui_panel = get_node("/root/Main/HUD/Panel")
    ui_panel.select_clicked(self)

func choose_target():
    if len(visible_targets) == 0:
        return

    var chosen_target_id: int = 0
    var choice_metric: float = -1
    var metric: float

    match aim_strategy:
        AimStrategy.CLOSEST:
            for i in range(len(visible_targets)):
                metric = global_position.distance_to(visible_targets[i].global_position)
                if choice_metric < 0 or metric < choice_metric:
                    chosen_target_id = i
                    choice_metric = metric
        AimStrategy.FIRST:
            for i in range(len(visible_targets)):
                metric = visible_targets[i].distance_travelled
                if choice_metric < 0 or metric > choice_metric:
                    chosen_target_id = i
                    choice_metric = metric
        AimStrategy.LAST:
            for i in range(len(visible_targets)):
                metric = visible_targets[i].distance_travelled
                if choice_metric < 0 or metric < choice_metric:
                    chosen_target_id = i
                    choice_metric = metric
        AimStrategy.STRONGEST:
            for i in range(len(visible_targets)):
                metric = visible_targets[i].health
                if choice_metric < 0 or metric > choice_metric:
                    chosen_target_id = i
                    choice_metric = metric
        AimStrategy.WEAKEST:
            for i in range(len(visible_targets)):
                metric = visible_targets[i].health
                if choice_metric < 0 or metric < choice_metric:
                    chosen_target_id = i
                    choice_metric = metric

    return visible_targets[chosen_target_id]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if debug_line != null:
        debug_line.queue_free()
    current_target = choose_target()
    if current_target != null:
        debug_line = line(position, current_target.position)

func _on_area_3d_body_entered(body):
    if len(visible_targets) == 0:
        $Timer.start()
    visible_targets.push_back(body)

func _on_area_3d_body_exited(body):
    visible_targets.erase(body)
    if len(visible_targets) == 0:
        $Timer.stop()

func _on_timer_timeout():
    fire()

func fire():
    var projectile = projectile_scene.instantiate()
    projectile.position = global_position
    get_node("/root/Main").add_child(projectile)
    projectile.fire_towards(current_target, damage, projectile_speed)

func select_turret():
    ui_panel.select_clicked(self)

func change_aim(strat: AimStrategy):
    aim_strategy = strat

func toggle_selected(selected: bool):
    $RangeArea/RangeIndicator.visible = selected

func upgrade_range():
    get_node("/root/Main/GameState").gold -= 50
    range += 1
    $RangeArea/RangeCollider.shape.radius = range
    $RangeArea/RangeIndicator.mesh.radius = range
    $RangeArea/RangeIndicator.mesh.height = range * 2

func _on_input_event(camera, event, position, normal, shape_idx):
    var lmb: bool = event is InputEventMouseButton and event.pressed and event.button_index == 1
    if lmb:
        select_turret()
