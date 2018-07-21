extends KinematicBody2D

var speed = 400
var jump_speed = 600
var gravity = 20

var velocity = Vector2()

enum OBJECTS {RECYCLED, LASER}

var has_object = false

func _ready():
    $Pivot/Hand.texture = null

func _physics_process(delta):
    
    if Input.is_action_just_pressed("grab"):
        if not has_object:
            take_object()
        else:
            drop_object()
    
    velocity.x = (int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))) * speed
    
    if is_on_floor() and Input.is_action_pressed("jump"):
        velocity.y = -jump_speed
        
    if(velocity.x < 0):
        $Pivot.scale = Vector2(-1, 1)
    else:
        $Pivot.scale = Vector2(1, 1)
    
    
    velocity.y += gravity
    
    velocity = move_and_slide(velocity, Vector2(0, -1))
    
func take_object():
    var body = $Detector.get_overlapping_bodies().pop_front()
    if body:
        has_object = true
        $Pivot/Hand.texture = load("res://waste/assets/plaque_texture_05.png")
        body.queue_free()

func drop_object():
    has_object = false
    var instance = load("res://waste/Recycled.tscn").instance()
    $Pivot/Hand.texture = null

    get_node("../Garbage").add_child(instance)
    instance.position = position
