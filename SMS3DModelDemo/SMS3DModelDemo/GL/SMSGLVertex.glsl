#version 300 core

precision highp float;

layout (location = 0) in vec2 position;
layout (location = 1) in vec2 inputFragCoord;

out vec2 textureCoordinate;

void main() {
    gl_Position =  vec4(position, 1.0, 1.0);
    fragCoord = inputTextureCoordinate;
}

