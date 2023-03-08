tool
extends TextureRect

export (Resource) var ITEM setget set_item

func set_item(item):
	ITEM = item
	self.texture = item.ITEM_TEXTURE
	self.rect_size = item.ITEM_TEXTURE.get_size()
