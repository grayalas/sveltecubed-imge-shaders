<script context="module">
	export const prerender = true;
</script>

<script>
	import * as THREE from 'three';
	import * as SC from 'svelte-cubed';
	import testVertexShader from '$lib/shaders/vertex.glsl';
	import testFragmentShader from '$lib/shaders/fragment.glsl';
	import texture from '$lib/textures/perfume02.jpg';
	import { onMount } from 'svelte';

	// -- TEXTURE -- //
	const textureLoader = new THREE.TextureLoader();
	let watchTexture;
	onMount(async () => {
		watchTexture = await textureLoader.load(texture);
	});

	// -- MATERIAL -- //
	const material = new THREE.ShaderMaterial({
		uniforms: {
			uTime: { value: 0 },
			uColor: { value: new THREE.Color(1.0, 0.0, 0.0) },
			uTexture: { value: watchTexture }
		},
		vertexShader: testVertexShader,
		fragmentShader: testFragmentShader
	});

	// -- ANIMATION -- //
	const clock = new THREE.Clock();
	SC.onFrame(() => {
		const elapsedTime = clock.getElapsedTime();
		material.uniforms.uTime.value = elapsedTime;
		material.uniforms.uTexture.value = watchTexture;
	});
</script>

<section>
	<SC.Canvas antialias background={new THREE.Color('black')}>
		<SC.Mesh geometry={new THREE.PlaneGeometry(0.4, 0.6, 16, 16)} {material} />
		<SC.PerspectiveCamera fov={8} />
		<SC.AmbientLight intensity={0.6} />
		<SC.DirectionalLight intensity={0.6} position={[-2, 3, 2]} />
	</SC.Canvas>
</section>
<h1>il profumo di una scoreggia</h1>

<style>
	h1 {
		color: papayawhip;
		font-size: clamp(100%, 1rem + 8vw, 4rem);
		position: relative;
		z-index: 1;
		margin: 6rem 2rem;
	}
</style>
