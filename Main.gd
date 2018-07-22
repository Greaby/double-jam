extends Node2D

signal game_over

var score = 0
var energy = 50

var laser = null

var sas_open = false

enum TYPES {CIRCLE, TRIANGLE, SQUARE, HEXAGON}

const objects = [
    "res://waste/Square.tscn",
    "res://waste/Circle.tscn",
    "res://waste/Triangle.tscn",
    "res://waste/Hexagon.tscn",
]

func _ready():
    randomize()
    
func _process(delta):
    if(energy <= 0):
        emit_signal("game_over", score)
    elif(energy <= 10):
        $Light.position.x = 816
    elif(energy <= 20):
        $Light.position.x = 1056
    elif(energy <= 30):
        $Light.position.x = 1232
    elif(energy <= 40):
        $Light.position.x = 1440
    else:
        $Light.position.x = 1792


func _on_SpawnTimer_timeout():
    var item = objects[randi() % objects.size()];
    var instance = load(item).instance()
    instance.rotation = randf() * 2 * PI
    instance.position = Vector2(1310, 220)
    $Garbage.add_child(instance)
    $SpawnTimer.wait_time = randi() % 5 + 3
    energy -= 1
    
    

func _on_Area2D_body_entered(body):
    print(body.linear_velocity)
    
    var recycled = null
    if(body.type == laser): 
        recycled = load("res://waste/Recycled.tscn").instance()
    else:
        recycled = load("res://waste/Pollutant.tscn").instance()
        
    recycled.position = body.position
    $Garbage.add_child(recycled)
    recycled.set_axis_velocity(body.linear_velocity)
    
    body.queue_free()


func _on_Borne_turn_on(type):
    for borne in $Bornes.get_children():
        if borne.is_on:
            borne.turn_off()

    match type:
        TYPES.CIRCLE:
            $Cables/CableCircle.visible = true
        TYPES.SQUARE:
            $Cables/CableSquare.visible = true
        TYPES.TRIANGLE:
            $Cables/CableTriangle.visible = true
        TYPES.HEXAGON:
            $Cables/CableHexagon.visible = true
    
    laser = type


func _on_Borne_turn_off(type):
    match type:
        TYPES.CIRCLE:
            $Cables/CableCircle.visible = false
        TYPES.SQUARE:
            $Cables/CableSquare.visible = false
        TYPES.TRIANGLE:
            $Cables/CableTriangle.visible = false
        TYPES.HEXAGON:
            $Cables/CableHexagon.visible = false
    
    if type == laser:
        laser = null


func _on_SasButton_toggle():
    $SasButton/AnimatedSprite.play("on")
    $SasButton/AnimatedSprite.frame = 0
    if sas_open:
        $AnimationPlayer.play("close_sas")
    else:
        $AnimationPlayer.play("open_sas")
        
    sas_open = !sas_open


func _on_Trash_body_entered(body):
    if(body == $Player):
        emit_signal("game_over", score)
    
    body.queue_free()


func _on_Receptacle_body_entered(body):
    score += 5
    if(energy < 50):
        energy += 2
    $Conveyor/StaticBody2D2.constant_linear_velocity = Vector2(-100 - score, 0)
    $Conveyor/StaticBody2D.constant_linear_velocity = Vector2(-100 - score, 0)
    $Score/Label.text = str(score) + " AL"
    body.queue_free()
