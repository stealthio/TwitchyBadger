extends Node2D

onready var fileDialogImport = $UI/FileDialogImport
onready var fileDialogExport = $UI/FileDialogExport
onready var previews = [$UI/VBoxContainer/Preview, $UI/BackgroundEmote/Preview28, $UI/BackgroundEmote/Preview56, $UI/BackgroundEmote/Preview112, $UI/BackgroundBadge/Preview18, $UI/BackgroundBadge/Preview36, $UI/BackgroundBadge/Preview72]
onready var scalingMethod = $UI/OptionButton

var tex : ImageTexture = null
var format = 0 # 0 = emote, 1 = badge

func _ready():
	fileDialogImport.connect("file_selected", self, "import_file_selected")
	fileDialogExport.connect("file_selected", self, "export_file_selected")
	scalingMethod.add_item("Nearest")
	scalingMethod.add_item("Bilinear")
	scalingMethod.add_item("Cubic")
	scalingMethod.add_item("Trilinear")

func import_file_selected(path):
	tex = ImageTexture.new()
	tex.load(path)
	for preview in previews:
		preview.texture = tex

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
