shader_type spatial;
render_mode diffuse_toon, shadows_disabled;

const vec3 green = vec3(0, 1, 0);
const vec3 red = vec3(1, 0, 0);

uniform float hp = 150;
uniform float max_hp = 200;
varying smooth vec3 our_color;

varying float hp_slider;

void vertex() {

}

float current_hp_clumn(float pos){
    float ifrac;
    float one_hp_width = 1. / max_hp;
    modf(pos / one_hp_width, ifrac);
    return ifrac + 1.;
}

void fragment() {
    hp_slider = step(UV.y, hp / max_hp);

    float column = current_hp_clumn(UV.y);
    if (mod(column, 100.) < max_hp * 0.025 && column > max_hp * 0.025){
        ALBEDO = vec3(0.);
    //} else if (mod(column, 10.) < 5. && UV.x > 0.5){
     //   ALBEDO = vec3(0.);
    } else {
        ALBEDO = mix(red, green, hp_slider);
    }
}

