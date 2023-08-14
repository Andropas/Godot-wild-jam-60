shader_type canvas_item;

uniform vec4 modulate: source_color; 

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a -= modulate.a;
	COLOR.rgb += modulate.rgb*modulate.a;
	COLOR.a = 1.0;
}
