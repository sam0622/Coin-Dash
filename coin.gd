extends Area2D

var screensize = Vector2.ZERO

func pickup(): # Delete the coin when it gets yoinked
	queue_free()
