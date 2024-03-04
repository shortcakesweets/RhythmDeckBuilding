shader_type canvas_item;

uniform float speed : hint_range(0.0, 0.5, 0.005) = 0.005;

void vertex() {
	UV.x += TIME * speed;
	UV.y += TIME * speed;
}