attribute vec2 uv;
attribute vec2 position;

varying vec2 vUv;
varying vec2 vPos;

void main(){
    vUv=uv;
    vPos = position;
    gl_Position=vec4(position,0,1);
}