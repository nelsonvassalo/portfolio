
precision highp float;

const float squares = 140.;
// const float amt = .005;

uniform float uAmt;
uniform vec2 blurDirection;
uniform float uTime;
uniform vec2 uResolution;
uniform float uMouse;
uniform sampler2D tDiffuse;
uniform float alpha;

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


void main(){
    // vec2 pUv = vPos.xy / uResolution.xy;
      
    vec2 tc = vUv + uMouse *0.01;
    // tc.x = pow(tc.x, uResolution.x  / uResolution.y);
    
    vec2 tile = fract(tc * squares ) + .1;
    float line = smoothstep( 0.8, .2, tile.x);
    
    // tile.x += uTime * .2;
//    vec4 color = texture2D(tDiffuse, vUv+(tile.x*uAmt));
   vec4 color = blur(tDiffuse, vUv+(tile.x*uAmt), uResolution.xy, blurDirection);

    // vec4 color = texture2D(tDiffuse, vUv);
    
    vec3 tex = mix(vec3(line), vec3(color), alpha);


    // vec4 color = texture2D(tDiffuse, tc);
    // color.x = tc.x;
    // vec4 color = texture2D(tDiffuse, vUv);


    // gl_FragColor = vec4(vec3(tex), 1.0);
    // gl_FragColor = vec4(vec2(tile), 1., 1.);
    gl_FragColor=linearToOutputTexel(vec4(vec3(tex), 1.0));
}