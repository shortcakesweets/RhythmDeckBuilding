shader_type canvas_item;

uniform float alpha : hint_range(0.0, 1.0, 0.001) = 1.0;

void fragment(){
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = pixelColor;
	COLOR.a *= alpha;
}