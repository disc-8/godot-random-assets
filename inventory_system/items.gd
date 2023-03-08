extends Node

const PATH = "ui_elements/inventory/items/repo.json"
var ALL_ITEMS
var file_type
var file_path
var inventory = []

func _ready():
	ALL_ITEMS = load_json(PATH)
	file_type = ALL_ITEMS['filetype']
	file_path = ALL_ITEMS['path']

func get_item(item_key):
	var p = file_path + ALL_ITEMS['error']['item_name'] + file_type
	if ALL_ITEMS and ALL_ITEMS.has(item_key):
		p = file_path + ALL_ITEMS[item_key]['item_name'] + file_type
	return p

func load_json(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.READ)
		var d = parse_json(file.get_as_text())
		file.close()
		return d
	else:
		print("NIGGA. balls! :)")
		return
