shader_type canvas_item;

uniform vec4 modulate: source_color; 

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR.a != 0.0) {
		COLOR.rgb *=  1.0 - modulate.a;
		COLOR.rgb += modulate.rgb*modulate.a;
	}
	
	
}
