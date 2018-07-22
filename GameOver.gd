extends Node2D

var score = 0

signal play

func _ready():
    $Score.text = "Vous avez parcouru " + str(score) + " AL"
    $AnimationPlayer.play("blink")
    
func _process(delta):
    if Input.is_action_pressed("start"):
        emit_signal("play")
        
    if Input.is_action_pressed("quit"):
        get_tree().quit()