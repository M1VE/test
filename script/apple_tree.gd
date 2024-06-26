extends Node2D

var state = "no_apples" 
var player_in_area = false

var apple = preload("res://scene/apple_collectable.tscn")

@export var item: InvItem
var player = null

func _ready():
	if state == "no_apples":
		$growth_timer.start()

func _process(_delta):
	if state == "no_apples":
		$AnimatedSprite2D.play("no_apples")
	if state == "apples":
		$AnimatedSprite2D.play("apples")
		if player_in_area:
			if Input.is_action_just_pressed("e"):
				state = "no_apples"
				drop_apple()


func _on_pickable_area_body_entered(body):
	if body.is_in_group("player"): 
		player_in_area = true
		player = body
	
	
func _on_pickable_area_body_exited(body):
	if body.is_in_group("player"): 
		player_in_area = false


func _on_growth_timer_timeout():
	if state == "no_apples":
		state = "apples"
		
func drop_apple():
	var apple_instance = apple.instantiate()
	apple_instance.global_position = $Marker2D.global_position
	get_parent().add_child(apple_instance)
	player.collect(item)
	await get_tree().create_timer(2).timeout
	$growth_timer.start()
