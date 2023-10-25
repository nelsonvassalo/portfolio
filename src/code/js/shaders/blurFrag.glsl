precision highp float;

uniform vec2 blurDirection;
uniform sampler2D tDiffuse;
uniform vec2 uResolution;
uniform float lod;
uniform float uTime;

varying vec2 vUv;

vec4 blur(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.411764705882353) * direction;
  vec2 off2 = vec2(3.2941176470588234) * direction;
  vec2 off3 = vec2(5.176470588235294) * direction;
  color += texture2D(image, uv) * 0.1964825501511404;
  color += texture2D(image, uv + (off1 / resolution)) * 0.2969069646728344;
  color += texture2D(image, uv - (off1 / resolution)) * 0.2969069646728344;
  color += texture2D(image, uv + (off2 / resolution)) * 0.09447039785044732;
  color += texture2D(image, uv - (off2 / resolution)) * 0.09447039785044732;
  color += texture2D(image, uv + (off3 / resolution)) * 0.010381362401148057;
  color += texture2D(image, uv - (off3 / resolution)) * 0.010381362401148057;
  return color;
}

float w0(float a)
{
    return (1.0/6.0)*(a*(a*(-a + 3.0) - 3.0) + 1.0);
}

float w1(float a)
{
    return (1.0/6.0)*(a*a*(3.0*a - 6.0) + 4.0);
}

float w2(float a)
{
    return (1.0/6.0)*(a*(a*(-3.0*a + 3.0) + 3.0) + 1.0);
}

float w3(float a)
{
    return (1.0/6.0)*(a*a*a);
}

// g0 and g1 are the two amplitude functions
float g0(float a)
{
    return w0(a) + w1(a);
}

float g1(float a)
{
    return w2(a) + w3(a);
}

// h0 and h1 are the two offset functions
float h0(float a)
{
    return -1.0 + w1(a) / (w0(a) + w1(a));
}

float h1(float a)
{
    return 1.0 + w3(a) / (w2(a) + w3(a));
}


vec4 texture_bicubic(sampler2D tex, vec2 uv, vec4 texelSize, vec2 fullSize, float lod)
{
	uv = uv*texelSize.zw + 0.5;
	vec2 iuv = floor( uv );
	vec2 fuv = fract( uv );

    float g0x = g0(fuv.x);
    float g1x = g1(fuv.x);
    float h0x = h0(fuv.x);
    float h1x = h1(fuv.x);
    float h0y = h0(fuv.y);
    float h1y = h1(fuv.y);

	vec2 p0 = (vec2(iuv.x + h0x, iuv.y + h0y) - 0.5) * texelSize.xy;
	vec2 p1 = (vec2(iuv.x + h1x, iuv.y + h0y) - 0.5) * texelSize.xy;
	vec2 p2 = (vec2(iuv.x + h0x, iuv.y + h1y) - 0.5) * texelSize.xy;
	vec2 p3 = (vec2(iuv.x + h1x, iuv.y + h1y) - 0.5) * texelSize.xy;
	
    vec2 lodFudge = pow(1.95, lod) / fullSize;
    return g0(fuv.y) * (g0x * 
        textureLod(tex, p0, lod)  +
                        
        g1x * textureLod(tex, p1, lod)
                    ) +
           g1(fuv.y) * (
            g0x * textureLod(tex, p2, lod)  +
                        g1x * textureLod(tex, p3, lod));
}

vec4 textureBicubic(sampler2D s, vec2 uv, float lod) {
 vec2 lodSizeFloor = vec2(textureSize(s, int(lod)));
 vec2 lodSizeCeil = vec2(textureSize(s, int(lod + 1.0)));
 vec2 fullSize = vec2(textureSize(s, 0));
 vec4 floorSample = texture_bicubic( s, uv, vec4(1.0 / lodSizeFloor.x, 1.0 / lodSizeFloor.y, lodSizeFloor.x, lodSizeFloor.y), fullSize, floor(lod));
 vec4 ceilSample = texture_bicubic( s, uv, vec4(1.0 / lodSizeCeil.x, 1.0 / lodSizeCeil.y, lodSizeCeil.x, lodSizeCeil.y), fullSize, ceil(lod));
 return mix(floorSample, ceilSample, fract(lod));
}


void main() {
    // float lod = 10.0 * (0.5 + 0.5 * (-cos(0.5 * uTime)));
    vec4 color = textureBicubic(tDiffuse, vUv, lod);
    
    // gl_FragColor = vec4(1.,0.,0.,1.);
    gl_FragColor = linearToOutputTexel(color);
}
