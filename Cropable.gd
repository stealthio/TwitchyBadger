extends TextureRect

var rectangle = Rect2(0,0,15,15)
var drawing = false

signal on_crop(tex)

func _input(event):
	if event is InputEventMouseButton:
		var m = get_global_mouse_position()
		if m.x > rect_global_position.x and m.y > rect_global_position.y and m.x < rect_global_position.x + rect_size.x and m.y < rect_global_position.y + rect_size.y:
			drawing = !drawing
			if drawing:
				rectangle = Rect2(get_global_mouse_position() - rect_global_position, Vector2(1,1))
				update()
	if event is InputEventMouseMotion:
		if drawing:
			rectangle.size = (get_global_mouse_position() - rect_global_position) - rectangle.position
			update()

func _draw():
	draw_rect(rectangle, Color.antiquewhite, false)

func _on_Crop_pressed():
	if rectangle.size.length() <= 0:
		return
	var data : Image = texture.get_data()
	var x = data.get_rect(rectangle)
	var imageTexture = ImageTexture.new()
	imageTexture.create_from_image(x)
	rectangle = Rect2(0,0,0,0)
	update()
	emit_signal("on_crop", imageTexture.duplicate(true))
