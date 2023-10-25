
precision highp float;

const float squares = 140.;
// const float amt = .005;

uniform float uAmt;
uniform float uTime;
uniform vec2 uResolution;
uniform float uMouse;
uniform sampler2D tDiffuse;
uniform float alpha;
uniform float lod;

varying vec2 vUv;

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


void main(){
    // vec2 pUv = vPos.xy / uResolution.xy;
      
    vec2 tc = vUv + uMouse *0.01;
    // tc.x = pow(tc.x, uResolution.x  / uResolution.y);
    
    vec2 tile = fract(tc * squares ) + .1;
    float line = smoothstep( 0.8, .2, tile.x);
    
    // tile.x += uTime * .2;
//    vec4 color = texture2D(tDiffuse, vUv+(tile.x*uAmt));
  //  vec4 color = blur(tDiffuse, vUv+(tile.x*uAmt), uResolution.xy, blurDirection);

    // vec4 color = texture2D(tDiffuse, vUv);
       vec4 color = textureBicubic(tDiffuse, vUv+(tile.x*uAmt),lod);
    // vec4 color = textureBicubic(tDiffuse, vUv, lod);
    
    vec3 tex = mix(vec3(line), vec3(color), 1.0);


    // vec4 color = texture2D(tDiffuse, tc);
    // color.x = tc.x;
    // vec4 color = texture2D(tDiffuse, vUv);


    // gl_FragColor = vec4(vec3(tex), 1.0);
    // gl_FragColor = vec4(vec2(tile), 1., 1.);
    gl_FragColor=linearToOutputTexel(vec4(vec3(tex), 1.0));
}