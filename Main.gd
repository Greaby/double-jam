extends Node2D

const objects = [
    "res://waste/Square.tscn",
    "res://waste/Circle.tscn",
    "res://waste/Triangle.tscn",
    "res://waste/Hexagon.tscn",
]

func _ready():
    randomize()


func _on_SpawnTimer_timeout():
    var item = objects[randi() % objects.size()];
    var instance = load(item).instance()
    instance.rotation = randf() * 2 * PI
    instance.position = Vector2(1310, 220)
    $Garbage.add_child(instance)
    $SpawnTimer.wait_time = randi() % 5 + 3
    
    

func _on_Area2D_body_entered(body):
    print(body.linear_velocity)
    
    $AnimationPlayer.play("flash")

    var recycled = load("res://waste/Recycled.tscn").instance()
    
    recycled.position = body.position
    $Garbage.add_child(recycled)
    recycled.set_axis_velocity(body.linear_velocity)
    
    body.queue_free()
