extends Area2D


#@export var Template: Resource

@onready var template = $Template

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		template.get_node("AnimationPlayer").play("show_news")
		#get_parent().add_child(Template.instantiate())
		#queue_free()




func _on_body_exited(body):
	if body.is_in_group("player"):
		template.get_node("AnimationPlayer").play("hide_news")
