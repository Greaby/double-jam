extends Node2D

signal play

func _ready():
    $AnimationPlayer.play("blink")

func _process(delta):
    if Input.is_action_pressed("start"):
        emit_signal("play")