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
	import { dragMe } from '$lib/helpers/dragMe.js';

	let canvas;
	let camera;
	let watchTexture;
	let image;

	/////////////////
	// -- SIZES -- //
	/////////////////
	$: innerWidth = 0;
	$: innerHeight = 0;

	/////////////////////
	// -- RAYCASTER -- //
	/////////////////////
	const raycaster = new THREE.Raycaster();
	let currentIntersect = null;

	/////////////////
	// -- MOUSE -- //
	/////////////////
	const mouse = new THREE.Vector2(-1, -1);
	function handleMousemove(event) {
		mouse.x = (event.clientX / innerWidth) * 2 - 1;
		mouse.y = -(event.clientY / innerHeight) * 2 + 1;
	}

	///////////////////
	// -- TEXTURE -- //
	///////////////////
	const textureLoader = new THREE.TextureLoader();
	// Load the texture when the document is ready
	onMount(async () => {
		watchTexture = await textureLoader.load(texture);
	});

	////////////////////
	// -- GEOMETRY -- //
	////////////////////
	const geometry = new THREE.PlaneGeometry(0.4, 0.6, 16, 16);

	////////////////////
	// -- MATERIAL -- //
	////////////////////
	const material = new THREE.ShaderMaterial({
		uniforms: {
			uTime: { value: 0 },
			uColor: { value: new THREE.Color(1.0, 0.0, 0.0) },
			uTexture: { value: watchTexture },
			uAnimate: { value: 0.1 }
		},
		vertexShader: testVertexShader,
		fragmentShader: testFragmentShader
	});

	/////////////////////
	// -- ANIMATION -- //
	/////////////////////
	const clock = new THREE.Clock();
	let previousTime = 0;
	SC.onFrame(() => {
		const elapsedTime = clock.getElapsedTime();
		const deltaTime = elapsedTime - previousTime;
		previousTime = elapsedTime;

		// Set the clock on the time uniform to animate it in shaders
		material.uniforms.uTime.value = elapsedTime;

		// Set the image in the shader as a texture
		material.uniforms.uTexture.value = watchTexture;

		// Get the camera and image object3D from svelte canvas: `bind:this={canvas}`
		camera = canvas.$$.ctx[0].camera.object;
		image = canvas.$$.ctx[0].scene.children[0];

		// Cast a ray from the mouse and handle events
		raycaster.setFromCamera(mouse, camera);

		// When the cursor gets close to the middle; slow the wave down
		let lerpAnimation = 0;
		let animationTarget = mouse.x;
		lerpAnimation += (animationTarget - lerpAnimation) * 5 * deltaTime;
		material.uniforms.uAnimate.value = lerpAnimation;

		// Mouse enter and leave events when hovering image
		const objectsToTest = [image];
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
<svelte:body style="cursor: pointer" />
<p use:dragMe>The mouse position is {mouse.x} x {mouse.y}</p>
<section>
	<SC.Canvas bind:this={canvas} antialias background={new THREE.Color('black')}>
		<SC.Mesh {geometry} {material} />
		<SC.PerspectiveCamera fov={8} />
		<SC.AmbientLight intensity={0.6} />
		<SC.DirectionalLight intensity={0.6} position={[-2, 3, 2]} />
	</SC.Canvas>
</section>

<style>
	p {
		color: red;
		position: relative;
		z-index: 1;
	}
</style>
