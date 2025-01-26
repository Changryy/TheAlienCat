shader_type canvas_item;

uniform float white : hint_range(0.0, 1.0, 0.001) = 0.;


void fragment() {
	COLOR.rgb += white;
}

