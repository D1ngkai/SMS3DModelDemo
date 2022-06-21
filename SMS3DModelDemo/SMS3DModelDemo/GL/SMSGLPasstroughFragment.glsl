#version 300 core

precision highp float;

out vec4 fragColor;
in vec2 fragCoord;

uniform sampler2D iChannel0;
uniform vec2 iChannelResolution0;

uniform vec2 iResolution;

void main() {
    vec2 uv = fragCoord;
    fragColor = texture(iChannel0, uv);
}

