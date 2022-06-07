precision mediump float;
uniform vec3 uColor;
uniform float uTime;
uniform sampler2D uTexture;

varying vec2 vUv;
varying float vWave;

void main() {
    float wave = vWave * 0.5;
    vec3 texture = texture2D(uTexture, vUv + wave).rgb;
    // gl_FragColor = vec4(sin(vUv.x + uTime) * uColor, 1.0);
    gl_FragColor = vec4(texture, 1.0);
}