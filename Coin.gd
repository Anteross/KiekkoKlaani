extends Area2D

func _on_Coin_body_entered(body):
	$AnimationPlayer.play("Bounce")
	body.add_coin()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Bounce":
		queue_free()
