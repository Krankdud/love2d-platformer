varying vec4 _fogColor;
varying float _fogDensity;
varying float _elapsed;
varying vec2 _scroll;

#ifdef VERTEX

uniform mat4 projection;
uniform float elapsed;
uniform vec4 fogColor;
uniform float fogDensity;
uniform vec2 scroll;

vec4 position(mat4 _, vec4 vertex_position)
{
    _fogColor = fogColor;
    _fogDensity = fogDensity;
    _elapsed = elapsed;
    _scroll = scroll;

    return projection * vertex_position;
}

#endif

#ifdef PIXEL

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    const float LOG2 = 1.442695;
    float z = gl_FragCoord.z / gl_FragCoord.w;
    float fogFactor = exp2(-_fogDensity * _fogDensity * z * z * LOG2);
    fogFactor = clamp(fogFactor, 0.0, 1.0);

    vec4 texcolor = Texel(texture, vec2(texture_coords.x + _elapsed * _scroll.x, texture_coords.y + _elapsed * _scroll.y));
    return mix(_fogColor, texcolor * color, fogFactor);
}

#endif
