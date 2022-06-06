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

	// -- SIZES -- //
	$: innerWidth = 0;
	$: innerHeight = 0;

	// -- TEXTURE -- //
	const textureLoader = new THREE.TextureLoader();
	let canvas;
	let camera;
	let watchTexture;
	let obj;
	onMount(async () => {
		camera = await canvas.$$.ctx[0].camera.object;
		obj = await canvas.$$.ctx[0].scene.children[0];
		watchTexture = await textureLoader.load(texture);
	});

	// -- GEOMETRY -- //
	const geometry = new THREE.PlaneGeometry(0.4, 0.6, 16, 16);

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

	const raycaster = new THREE.Raycaster();
	let currentIntersect = null;
	const rayOrigin = new THREE.Vector3(-3, 0, 0);
	const rayDirection = new THREE.Vector3(10, 0, 0);
	rayDirection.normalize();

	const mouse = new THREE.Vector2();
	function handleMousemove(event) {
		mouse.x = (event.clientX / innerWidth) * 2 - 1;
		mouse.y = -(event.clientY / innerHeight) * 2 + 1;
	}

	// -- ANIMATION -- //
	const clock = new THREE.Clock();
	SC.onFrame(() => {
		const elapsedTime = clock.getElapsedTime();
		material.uniforms.uTime.value = elapsedTime;
		material.uniforms.uTexture.value = watchTexture;
		camera = canvas.$$.ctx[0].camera.object;
		obj = canvas.$$.ctx[0].scene.children[0];

		// console.log(camera);

		// Cast a ray from the mouse and handle events
		raycaster.setFromCamera(mouse, camera);

		const objectsToTest = [obj];
		const intersects = raycaster.intersectObjects(objectsToTest);

		if (intersects.length) {
			if (!currentIntersect) {
				console.log('mouse enter');
			}

			currentIntersect = intersects[0];
		} else {
			if (currentIntersect) {
				console.log('mouse leave');
			}

			currentIntersect = null;
		}
	});
</script>

<svelte:window bind:innerWidth bind:innerHeight on:mousemove={handleMousemove} />
<p>The mouse position is {mouse.x} x {mouse.y}</p>
<section>
	<SC.Canvas bind:this={canvas} antialias background={new THREE.Color('black')}>
		<SC.Mesh {geometry} {material} />
		<SC.PerspectiveCamera fov={8} />
		<SC.AmbientLight intensity={0.6} />
		<SC.DirectionalLight intensity={0.6} position={[-2, 3, 2]} />
	</SC.Canvas>
</section>
<h1>il profumo di una scoreggia</h1>

<style>
	p {
		color: papayawhip;
		position: relative;
		z-index: 1;
	}

	h1 {
		color: papayawhip;
		font-size: clamp(100%, 1rem + 8vw, 4rem);
		position: relative;
		z-index: 1;
		margin: 6rem 2rem;
	}
</style>
