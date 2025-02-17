extends Area2D


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "anim":
		queue_free()
