#https://github.com/lulersoft/godot_mole_game
#Godot QQ Group: 302924317 
#Author:xiaolu (QQ2604904)
extends Node

var moleArr=[]
var timer
var hp=100
var point=0
var maxpoint=0
var gameOver=true
var save_file="user://savedata.bin"

func _ready():
	randomize()
	for i in range(3):
		moleArr.push_back(get_node("bg"+str(i)+"/mole0"))
		moleArr.push_back(get_node("bg"+str(i)+"/mole1"))
		moleArr.push_back(get_node("bg"+str(i)+"/mole2"))	
	
	for i in range(moleArr.size()):		
		moleArr[i].connect("hit on one mole",self,"onHit")
		moleArr[i].connect("missing one mole",self,"onMiss")
		
	maxpoint=read()
	get_node("score").set_text("score: "+str(point))
	get_node("maxscore").set_text("max score: "+str(maxpoint))
	
	timer=Timer.new()
	timer.connect("timeout",self,"onTimer")
	timer.set_one_shot(false)
	timer.set_wait_time(1)
	
	add_child(timer)	
	set_process(true)

func _process(delta):
	if(Input.is_action_pressed("ui_cancel")):		
		get_tree().quit()
	
func onHit(obj):
	point=point+1
	get_node("score").set_text("score: "+str(point))
	if maxpoint<point:
		maxpoint=point
		save()
	get_node("maxscore").set_text("max score: "+str(maxpoint))

func onMiss(obj):
	hp=hp-10
	if hp<0:
		hp=0
	get_node("hp").set_value(hp)	
	if hp==0:		
		gameOver=true
		get_node("Panel").show()
		timer.stop()	
	
func onTimer():
	if gameOver==false:
		moleComeOut()
	
func moleComeOut():
	var len=moleArr.size()
	var idx = randi() % len	
	var mole=moleArr[idx]
		
	if gameOver==false:
		if mole.status==1:
			OS.delay_msec(100)
			moleComeOut()
		else:
			mole.comeOut()

func _on_startButton_pressed():
	get_node("Panel").hide()
	gameOver=false
	
	for i in range(moleArr.size()):
		moleArr[i].reset()

	hp=100
	point=0
	
	get_node("hp").set_value(hp)	
	get_node("score").set_text("score: "+str(point))
	timer.start()
	
func save():
	var f = File.new()
	var err = f.open_encrypted_with_pass(save_file,File.WRITE,"godot")
	f.store_64(maxpoint)
	f.close()
	
func read():
	var v=0
	var f = File.new()
	if f.file_exists(save_file):
		var err = f.open_encrypted_with_pass(save_file,File.READ,"godot")
		v=f.get_64()
		f.close()	
	return v