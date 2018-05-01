varying highp vec2 textureCoordinate;
varying highp vec2 textureCoordinate2;
uniform sampler2D inputImageTexture;
uniform sampler2D mt_tempData1;
uniform highp float gridsize;
uniform highp float texwidth;
uniform highp float alpha;//alpha
uniform lowp mat4 colorMatrix;
uniform int isBnW;
void main()
{
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    highp float slice = textureColor.b * (32.0 - 1.0);
    highp float islice0 = floor(slice);
    highp float islice1 = min(31.0, islice0 + 1.0);
    highp float fslice = fract(slice);//fract返回x-floor(x)，即返回x的小数部分
    highp float x = textureColor.r * (32.0 - 1.0);
    highp float x1 = x + islice0*32.0 + 0.5;
    highp float x2 = x + islice1*32.0 + 0.5;
    highp float y = textureColor.g * (32.0 - 1.0) + 0.5;
    highp vec2 texPos1 = vec2(x1 / 1024.0, y/32.0);
    highp vec2 texPos2 = vec2(x2 / 1024.0, y/32.0);
    highp vec4 newColor1 = texture2D(mt_tempData1, texPos1);
    highp vec4 newColor2 = texture2D(mt_tempData1, texPos2);
    highp vec4 newColor = mix(newColor1, newColor2, fslice);
    highp vec4 minColor = textureColor;
    newColor = mix(minColor, newColor, alpha);
    gl_FragColor = newColor;
}
