shader_type canvas_item;

uniform sampler2D dissolve_texture;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform vec4 custom_color : source_color;

void fragment(){
	// change to greyscale
	vec4 main_texture = texture(TEXTURE, UV);
	float brightness = (main_texture.r + main_texture.g + main_texture.b) / 3.0;
	main_texture = vec4(brightness, brightness, brightness, main_texture.a);
	
	// add custom color
	main_texture *= custom_color;
	
	// add noise
	vec4 noise_texture = texture(dissolve_texture, UV);
	main_texture.a *= floor(alpha + min(1, noise_texture.x));
	COLOR = main_texture;
}