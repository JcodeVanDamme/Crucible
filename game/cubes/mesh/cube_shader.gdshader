shader_type spatial;

uniform vec4 cube_color : source_color;
uniform vec4 lane_color : source_color;

uniform float lane_strength = 0.4;

uniform bool active = false;
uniform bool in_lane;

void fragment() {
	vec4 color = cube_color;
	if (in_lane) {
		color.rgb = mix(
		color.rgb,
		lane_color.rgb,
		lane_color.a * lane_strength
		);
	}
	ALBEDO = color.rgb;
}
	