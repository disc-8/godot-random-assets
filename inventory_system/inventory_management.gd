extends Control

var grid_size = Vector2()
var grid_space = {}
var cell_size = 32
var slots
var offset = Vector2()
var last_pos = Vector2()
var holding = null

var items = []

onready var bpbase = $BPBase
onready var grid = $BPBase/Grid
var grid_pos
onready var eqslots = $BPBase/EqSlots

onready var item_base = preload("res://ui_elements/inventory/ItemBase.tscn")

func _ready():
	grid_size = calc_grid()
	for x in range(grid_size.x):
		grid_space[x] = {}
		for y in range(grid_size.y):
			grid_space[x][y] = false
	grid_pos = Vector2(grid.rect_global_position.x, grid.rect_global_position.y)
	
	add_item("gasmask")
	add_item("ENPSI")
	add_item("dildux")
	add_item("dildux")
	add_item("whallta wyt")
	for i in items:
		place_item(i, get_fap(get_item_size(i)))
	

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	for i in items:
		if intersects(mouse_pos, i) and Input.is_action_pressed("click") and not holding:
			offset = Vector2(i.get_rect().size.x /2, i.get_rect().size.y /2)
			last_pos = i.rect_global_position
			move_child(i, get_child_count())
			holding = i
		if Input.is_action_just_released("click") and holding:
			place_item_at(holding, mouse_pos)
		if holding:
			holding.rect_global_position = mouse_pos - offset

func calc_grid():
	var gs = grid.get_rect().size
	gs.x = int(gs.x / cell_size)
	gs.y = int(gs.y / cell_size)
	return gs

func add_item(key):
	var i = item_base.instance()
	i.set_item(load(item_db.get_item(key)))
	items.append(i)
	add_child(i)

func get_item_size(item):
	var s = item.get_rect().size
	s.x /= cell_size
	s.y /= cell_size
	return s

func intersects(position, item):
	if item.get_rect().has_point(position):
		return true
	return false

func get_grid_pos(position):
	var gpos = Vector2()
	gpos.x = position.x - grid_pos.x
	gpos.y =position.y - grid_pos.y
	gpos.x = int(gpos.x / cell_size)
	gpos.y = int(gpos.y / cell_size)
	return gpos

func get_grid_size(item):
	var gsize = Vector2()
	gsize.x = int(item.rect_size.x / cell_size)
	gsize.y = int(item.rect_size.y / cell_size)
	return gsize

func is_space_avail(x, y, w, h):
	if x<0 or x + w> grid_size.x or y<0 or y+h>grid_size.y:
		return false
	for i in range(x, x+w):
		for j in range(y, y+h):
			if grid_space[i][j]:
				return false
				
	return true

func get_fap(size):
	for i in range(grid_size.x):
		for j in range(grid_size.y):
			if is_space_avail(i, j, size.x, size.y):
				return Vector2(i, j)
	return Vector2()

func place_item_at(item, mouse_pos):
	var fp = Vector2()
	var isg = get_grid_size(item)
	mouse_pos.x -= grid_pos.x
	mouse_pos.y -= grid_pos.y
	mouse_pos -= offset/2
	var mouse_grid = Vector2(int(mouse_pos.x/cell_size), int(mouse_pos.y/cell_size))
	
	var lastpos_g = Vector2()
	lastpos_g.x = (last_pos.x-grid_pos.x)/cell_size
	lastpos_g.y = (last_pos.y-grid_pos.y)/cell_size
	if lastpos_g.x >= 0 and lastpos_g.y >= 0:
		for i in range(lastpos_g.x,lastpos_g.x + isg.x):
			for j in range(lastpos_g.y, lastpos_g.y + isg.y):
				grid_space[i][j] = false
	
	if is_space_avail(mouse_grid.x, mouse_grid.y, isg.x, isg.y):
		fp.x = mouse_grid.x*cell_size + grid_pos.x
		fp.y = mouse_grid.y * cell_size + grid_pos.y
		fp = Vector2(floor(fp.x), floor(fp.y))
		for i in range(mouse_grid.x,mouse_grid.x + isg.x):
			for j in range(mouse_grid.y, mouse_grid.y + isg.y):
				grid_space[i][j] = true
	else:
		fp = last_pos
		for i in range(lastpos_g.x,lastpos_g.y + isg.x):
			for j in range(lastpos_g.y, lastpos_g.y + isg.y):
				grid_space[i][j] = true
	item.rect_global_position = fp
	holding=null

func place_item(item, pos):
	var fp = Vector2()
	var isg = get_grid_size(item)
	fp.x = pos.x*cell_size + grid_pos.x
	fp.y = pos.y * cell_size + grid_pos.y
	fp = Vector2(floor(fp.x), floor(fp.y))
	for i in range(pos.x,pos.x + isg.x):
		for j in range(pos.y, pos.y + isg.y):
			grid_space[i][j] = true
	item.rect_global_position = fp
