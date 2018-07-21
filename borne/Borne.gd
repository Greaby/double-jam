extends Node2D

var is_on = false


func turn_on():
    if not is_on:
        is_on = true
        $AnimatedSprite.play("on")
        
func turn_off():
    if is_on:
        is_on = false
        $AnimatedSprite.play("off")