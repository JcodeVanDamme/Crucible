shader_type spatial;
render_mode unshaded, wireframe, depth_test_disabled;

uniform vec3 outline_color : source_color = vec3(1.0, 1.0, 0.0);

void fragment() {
    ALBEDO = outline_color
}
