extends Node2D

onready var fileDialogImport = $UI/FileDialogImport
onready var fileDialogExport = $UI/FileDialogExport
onready var importPreview = $UI/VBoxContainer/Preview
onready var previews = [$UI/BackgroundEmote/Preview28, $UI/BackgroundEmote/Preview56, $UI/BackgroundEmote/Preview112, $UI/BackgroundBadge/Preview18, $UI/BackgroundBadge/Preview36, $UI/BackgroundBadge/Preview72, $UI/BackgroundEdit/TextureRect]
onready var scalingMethod = $UI/OptionButton
onready var colorFrom = $UI/BackgroundEdit/BtnReplaceColor/ColorFrom
onready var colorTo = $UI/BackgroundEdit/BtnReplaceColor/ColorTo
onready var cropper = $UI/BackgroundEdit/TextureRect

var tex : ImageTexture = null
var format = 0 # 0 = emote, 1 = badge

func _ready():
	fileDialogImport.connect("file_selected", self, "import_file_selected")
	fileDialogExport.connect("file_selected", self, "export_file_selected")
	scalingMethod.add_item("Nearest")
	scalingMethod.add_item("Bilinear")
	scalingMethod.add_item("Cubic")
	scalingMethod.add_item("Trilinear")
	cropper.connect("on_crop", self, "_on_crop")

func import_file_selected(path):
	tex = ImageTexture.new()
	tex.load(path)
	importPreview.texture = tex.duplicate(true)
	_refresh_previews()

func export_file_selected(path):
	if tex != null:
		var image = tex.get_data()
		image.resize(112,112)
		var sizes = null
		if format == 0:
			sizes = [112, 56, 28]
		elif format == 1:
			sizes = [72, 36, 18]
		for size in sizes:
			image.resize(size, size, scalingMethod.selected)
			image.save_png(path.replace(".", String(size)+ "."))

func _on_Button_pressed():
	fileDialogImport.popup(Rect2(0,0,420,300))

func _on_ButtonExportEmote_pressed():
	fileDialogExport.popup(Rect2(0,0,420,300))
	format = 0


func _on_ButtonExportBadge_pressed():
	fileDialogExport.popup(Rect2(0,0,420,300))
	format = 1

func _refresh_previews():
	for preview in previews:
		preview.texture = tex

func _on_crop(newTex):
	tex = newTex
	_refresh_previews()

func _on_ButtonReplaceColor_pressed():
	var img : Image = tex.get_data()
	img.lock()
	for y in img.get_height():
		for x in img.get_width():
			var px = img.get_pixel(x, y)
			if px == colorFrom.color:
				img.set_pixel(x,y, colorTo.color)
	img.unlock()
	tex.set_data(img)
		
