extends Node2D


func load_main():
    for child in get_children():
        child.queue_free()
    
    var scene = load("res://Main.tscn").instance()
    
    scene.connect("game_over", self, "load_game_over")
    
    add_child(scene)
    
    
func load_game_over(score):
    for child in get_children():
        child.queue_free()
    
    var scene = load("res://GameOver.tscn").instance()
    scene.connect("play", self, "_on_Menu_play")
    scene.score = score 
    add_child(scene)

func _on_Menu_play():
    load_main()
