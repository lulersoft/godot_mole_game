#https://github.com/lulersoft/godot_mole_game
#Godot QQ Group: 302924317 
#Author:xiaolu (QQ2604904)
extends AnimatedSprite

var status=0
var live=0

var speed=0
var original
var to

var tween

var mouse_in = false

func _ready():
	add_user_signal("hit on one mole",[TYPE_OBJECT])
	add_user_signal("missing one mole",[TYPE_OBJECT])	
	
	original=position
	to=Vector2(original.x,original.y-60)	
	
	set_process_input(true)	
	
	tween=Tween.new()
	add_child(tween)
	tween.start()

	
	
func _input(e):
	if mouse_in && (e is InputEventMouseButton):
		onClick()

func gamestart():
	live=0
	status=0
	position=original
	tween.start()	
	#position=to
	
func gameover():
	tween.stop_all()

func onClick():	
	if live==0:
		return	
	live=0	
	tween.remove_all()
	tween.interpolate_callback(self, 0.5,"comIn")
	tween.start()	
	
	get_node("anim").play("die")
	emit_signal("hit on one mole", self)	
	
func comeOut():
	status=1
	live=1
	
	get_node("anim").play("run")
	var t=0.3	
	
	tween.interpolate_property (self, "position", position, to, t, Tween.TRANS_LINEAR, Tween.EASE_IN,0)
	tween.interpolate_callback(self,t, "onOutcomplete")	
	
	tween.start()	
	
func onOutcomplete():	
	comIn()
	
func comIn():
	var t=0.3
	var delay=0.5
	
	tween.interpolate_property(self, "position", position, original, t, Tween.TRANS_LINEAR, Tween.EASE_IN,delay)
	tween.interpolate_callback(self,t+delay,"onIncomplete")	
	tween.start()	
	
func onIncomplete():	
	status=0
	if live==1:
		emit_signal("missing one mole", self)
		
func _on_Area2D_mouse_entered():
	mouse_in = true

func _on_Area2D_mouse_exited():
	mouse_in = false	
	