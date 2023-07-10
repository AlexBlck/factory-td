shader_type spatial;
render_mode diffuse_toon, shadows_disabled;

const vec3 green = vec3(0, 1, 0);
const vec3 red = vec3(1, 0, 0);
uniform float hp = 0.1;
varying smooth vec3 our_color;

varying float hp_slider;

void vertex() {
    hp_slider = step(UV.y, hp);
    our_color = mix(red, green, hp_slider);
}

void fragment() {
    ALBEDO = our_color;
}

