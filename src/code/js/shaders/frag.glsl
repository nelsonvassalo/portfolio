
precision highp float;

const float squares = 80.0;
const float amt = .03;

uniform float uTime;
uniform vec2 uResolution;

varying vec2 vUv;
varying vec2 vPos;


void main(){
    vec2 uv = vPos / uResolution;

    vec2 tc = uv;
    tc.x = pow(tc.x, uResolution.x   / uResolution.y);

    vec2 tile = fract(tc * squares + uTime ) + .1;

    tile.x += uTime * 0.2;

    float line = smoothstep( 0.8, .2, tile.x);

    vec3 color = 0.5 + 0.3 * cos(vUv.xyx + uTime) + vec3(vPos.x, vPos.y, vPos.y);

    vec3 tex = mix(vec3(line), vec3(color), 0.9);
    
    gl_FragColor = vec4(line,1.0,1.0, 1.);
    // gl_FragColor=vec4(vPos.x,vPos.y,.5,1.);
}