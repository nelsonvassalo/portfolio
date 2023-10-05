
precision highp float;

const float squares = 140.;
// const float amt = .005;

uniform float uAmt;
uniform float uBlur;
uniform float uTime;
uniform vec2 uResolution;
uniform float uMouse;
uniform sampler2D tDiffuse;

varying vec2 vUv;


void main(){
    // vec2 pUv = vPos.xy / uResolution.xy;
      
    vec2 tc = vUv + uMouse *0.01;
    // tc.x = pow(tc.x, uResolution.x  / uResolution.y);
    
    vec2 tile = fract(tc * squares ) + .1;
    float line = smoothstep( 0.8, .2, tile.x);
    
    // tile.x += uTime * .2;
   vec4 color = texture2D(tDiffuse, vUv+(tile.x*uAmt));

    // vec4 color = texture2D(tDiffuse, vUv);
    
    vec3 tex = mix(vec3(line), vec3(color), 1.);


    // vec4 color = texture2D(tDiffuse, tc);
    // color.x = tc.x;
    // vec4 color = texture2D(tDiffuse, vUv);


    // gl_FragColor = vec4(vec3(tex), 1.0);
    // gl_FragColor = vec4(vec2(tile), 1., 1.);
    gl_FragColor=linearToOutputTexel(vec4(vec3(tex), 1.0));
}