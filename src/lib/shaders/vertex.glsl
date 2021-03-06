precision mediump float;
varying vec2 vUv;
varying float vWave;

uniform float uTime;
uniform float uAnimate;

#pragma glslify: snoise3 = require(glsl-noise/simplex/3d);

void main() {
    vUv = uv;

    vec3 pos = position;
    float noiseFreq = 1.5;
    float noiseAmp = 0.25;
    vec3 noisePos = vec3(pos.x * noiseFreq + uTime, pos.y, pos.z);
    pos.z += snoise3(noisePos) * noiseAmp;

    vWave = pos.z * uAnimate;

    // Line below makes the bounding image borders wave
    // gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

    // Line below makes just the image inside the border wave
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}