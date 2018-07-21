extends Node2D

enum TYPES {CIRCLE, TRIANGLE, SQUARE, HEXAGON}

export (TYPES) var type

var is_on = false

func toggle():
    if is_on:
        turn_off()
    else:
        turn_on()


func turn_on():
    if not is_on:
        is_on = true
        $AnimatedSprite.play("on")
        
func turn_off():
    if is_on:
        is_on = false
        $AnimatedSprite.play("off")

func _on_Detector_toggle():
    toggle()


func _on_AnimatedSprite_animation_finished():
    if $AnimatedSprite.animation == "on":
        $AnimatedSprite.animation = "square"
