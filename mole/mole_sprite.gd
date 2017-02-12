https://github.com/lulersoft/godot_mole_game
#Godot QQ Group: 302924317 
#Author:xiaolu (QQ2604904)
extends AnimatedSprite

var status=0
var live=0

var speed=0
var original
var to

var picked = false
var tween

func _ready():
	add_user_signal("hit on one mole",[TYPE_OBJECT])
	add_user_signal("missing one mole",[TYPE_OBJECT])	
	
	original= get_pos()	
	to=Vector2(original.x,original.y-60)	
	
	set_process_input(true)	
	
	tween=Tween.new()
	add_child(tween)
	tween.start()
	
func _input(e):
	if e.type == InputEvent.MOUSE_BUTTON || e.type == InputEvent.SCREEN_TOUCH:
		if e.pressed && get_bounding_box().has_point(e.pos):
			picked = true
		elif !e.pressed:
			picked = false

	if picked:
			onClick()

func get_bounding_box():
	var size =  get_sprite_frames().get_frame(get_animation(),0).get_size() * get_scale()
	var pos = get_global_pos()
	
	if is_centered():
		pos -= size * 0.5
	
	return Rect2(pos, size)

func gamestart():
	live=0
	status=0
	set_pos(original)
	tween.start()
	
func gameover():
	tween.stop_all()

func onClick():

	if live==0:
		return
	
	live=0
	
	tween.remove_all()
	tween.interpolate_callback(self, 0.5,"comIn")
	
	get_node("anim").play("die")
	emit_signal("hit on one mole", self)
	
	tween.start()
	
func comeOut():
	status=1
	live=1
	
	get_node("anim").play("run")
	var t=0.3
	tween.interpolate_method(self, "set_pos", get_pos(), to, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_callback(self,t, "onOutcomplete")	
	
func onOutcomplete():
	comIn()
	
func comIn():
	var t=0.3
	var delay=0.5
	tween.interpolate_method(self, "set_pos", get_pos(), original, t, Tween.TRANS_LINEAR, Tween.EASE_IN,delay)
	tween.interpolate_callback(self,t+delay,"onIncomplete")
	
func onIncomplete():
	status=0
	if live==1:
		emit_signal("missing one mole", self)
	
