attribute vec4 position;
attribute vec4 inputTextureCoordinate;
attribute vec4 inputTextureCoordinate2;
varying vec2 textureCoordinate;
void main() {
    gl_Position = position;
    textureCoordinate = inputTextureCoordinate.xy;
}
