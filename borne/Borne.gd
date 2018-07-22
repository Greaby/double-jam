extends Node2D

enum TYPES {CIRCLE, TRIANGLE, SQUARE, HEXAGON}

signal turn_on
signal turn_off

export (TYPES) var type

var is_on = false

func toggle():
    $Activate.pitch_scale = randf() / 2.5 + 0.8
    $Activate.play()
    if is_on:
        turn_off()
    else:
        turn_on()


func turn_on():
    if not is_on:
        emit_signal("turn_on", type)
        is_on = true        
        var frame = 0
        if $AnimatedSprite.animation == "off":
            frame = $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation) - $AnimatedSprite.frame

        $AnimatedSprite.play("on")
        $AnimatedSprite.set_frame(frame)
        
func turn_off():
    if is_on:
        emit_signal("turn_off", type)
        is_on = false
        var frame = 0
        if $AnimatedSprite.animation == "on":
            frame = $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation) - $AnimatedSprite.frame

        $AnimatedSprite.play("off")
        $AnimatedSprite.set_frame(frame)

func _on_Detector_toggle():
    toggle()


func _on_AnimatedSprite_animation_finished():
    if $AnimatedSprite.animation == "on":
        match type:
            TYPES.CIRCLE:
                $AnimatedSprite.animation = "circle"
            TYPES.TRIANGLE:
                $AnimatedSprite.animation = "triangle"
            TYPES.SQUARE:
                $AnimatedSprite.animation = "square"
            TYPES.HEXAGON:
                $AnimatedSprite.animation = "hexagon"
