extends KinematicBody2D

enum OBJECTS {RECYCLED, LASER}

enum states {IDLE, WALK, JUMP, FALL}
var state

var speed = 400
var jump_speed = 600
const MAX_GRAVITY = 400
export (int) var gravity = 20

var velocity = Vector2()
var input_direction = Vector2()

var has_object = false

func _ready():
    $Pivot/Hand.texture = null
    _change_state(IDLE)

func _change_state(new_state):
    match new_state:
        IDLE:
            $Pivot/AnimatedSprite.play("idle")
        WALK:
            $Pivot/AnimatedSprite.play("walk")
        JUMP:
            $Pivot/AnimatedSprite.play("jump")
            velocity.y = -jump_speed
        FALL:
            $Pivot/AnimatedSprite.play("idle")
            
    state = new_state
    
func _input(event):
    if event.is_action_pressed("jump") and state in [IDLE, WALK]:
        return _change_state(JUMP)
        
    
func _physics_process(delta):
    if Input.is_action_just_pressed("grab"):
        toggle_borne()
        if not has_object:
            take_object()
        else:
            drop_object()
    
    update_direction()
    apply_gravity()
    
    
    
    match state:
        IDLE:
            if input_direction.x:
                _change_state(WALK)
        WALK:
            if not input_direction.x:
                _change_state(IDLE)
        JUMP:
            if velocity.y >= 0:
                _change_state(FALL)
        FALL:
            if is_on_floor():
                _change_state(IDLE)
    
    move()
    
func update_direction():
    input_direction = Vector2()
    
    input_direction.x = (int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")))

    if(input_direction.x < 0):
        $Pivot.scale = Vector2(-1, 1)
    else:
        $Pivot.scale = Vector2(1, 1)
        
func apply_gravity():
    velocity.y += gravity
    if velocity.y >= MAX_GRAVITY:
        velocity.y = MAX_GRAVITY

func move():
    velocity.x = input_direction.x * speed
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
    
func toggle_borne():
    var area = $Detector.get_overlapping_areas().pop_front()
    if area:
        area.toggle()


func _on_Detector_area_entered(area):
    pass
