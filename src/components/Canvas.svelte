<script>
	import { onMount } from 'svelte';

	import {
		WebGLRenderer,
		Mesh,
		BufferGeometry,
		Vector2,
		Scene,
		PerspectiveCamera,
		MeshBasicMaterial,
		PlaneGeometry,
		DoubleSide,
		VideoTexture,
		LinearFilter,
		RGB_ETC1_Format,
		RGBAIntegerFormat,
		sRGBEncoding,
		Clock,
		SRGBColorSpace,
		ColorManagement
	} from 'three';
	import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer';
	import { RenderPass } from 'three/examples/jsm/postprocessing/RenderPass';
	import { ShaderPass } from 'three/examples/jsm/postprocessing/ShaderPass';

	import fragment from '../code/js/shaders/frag.glsl';
	import vertex from '../code/js/shaders/vertex.glsl';
	import RoundedRect from '../code/js/RoundedRectangle';

	import { scroll, glScale, glY, amplitude, blur } from '../code/js/store';
	import RoundedRectangle from '../code/js/RoundedRectangle';
	let canvas;

	$: console.log($scroll);

	onMount(() => {
		const wW = window.innerWidth;
		const wH = window.innerHeight;
		const renderer = new WebGLRenderer({
			antialias: true
		});
		console.log('🚀 ~ renderer:', renderer);
		renderer.setSize(wW, wH);

		renderer.outputColorSpace = SRGBColorSpace;

		let vec = new Vector2();

		canvas.appendChild(renderer.domElement);

		renderer.setClearColor(0xffffff, 1);
		ColorManagement.enabled = true;

		const scene = new Scene();
		const fov = 55;

		const camera = new PerspectiveCamera(fov, wW / wH, 0.01, 5000);

		const z = (wW / Math.tan((fov * Math.PI) / 360)) * 0.5;
		camera.position.set(0, 0, z);
		// camera.lookAt([0, 0, 0]);

		function resize() {
			renderer.setSize(wW, wH);
			// camera.perspective({ aspect: gl.canvas.width / gl.canvas.height });
		}

		resize();

		const shader = {
			uniforms: {
				uTime: {
					value: 0
				},
				tDiffuse: {
					value: null
				},
				uResolution: {
					value: new Vector2(wW, wH)
				},
				uAmt: {
					value: 0
				},
				uBlur: {
					value: 0
				}
			},
			vertexShader: vertex,
			fragmentShader: fragment
		};

		// Triangle that covers viewport, with UVs that still span 0 > 1 across viewport
		// const geometry = new BufferGeometry({
		// 	position: { size: 2, data: new Float32Array([-1, -1, 3, -1, -1, 3]) },
		// 	uv: { size: 2, data: new Float32Array([0, 0, 2, 0, 0, 2]) }
		// });
		// Alternatively, you could use the Triangle class.

		const video = document.querySelector('video');

		const videoTex = new VideoTexture(video);
		videoTex.colorSpace = SRGBColorSpace;
		videoTex.minFilter = LinearFilter;
		videoTex.magFilter = LinearFilter;
		// videoTex.format = SRGBColorSpace;

		const material = new MeshBasicMaterial({ map: videoTex });

		const rect = video?.getBoundingClientRect();

		// const planeGeom = new PlaneGeometry(1, 1);
		const planeGeom = new RoundedRect(rect.width * 1.366666, rect.height * 1.3666, 10, 64);
		console.log('🚀 ~ rect FIRST RENDER', rect.width);
		const plane = new Mesh(planeGeom, material);

		scene.add(plane);
		// plane.position.set(0, -rect.top, 0);
		// plane.scale.set(0.6, 0.6, 1.0);

		const composer = new EffectComposer(renderer);
		composer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
		composer.setSize(wW, wH);
		const renderPass = new RenderPass(scene, camera);
		const shaderPass = new ShaderPass(shader);

		shaderPass.enabled = false;

		composer.addPass(renderPass);
		composer.addPass(shaderPass);
		// shaderPass.enabled = false;

		window.addEventListener('resize', resize);

		const clock = new Clock();
		const raf = (time) => {
			const newTime = clock.getElapsedTime();
			shaderPass.uniforms.uTime.value = newTime;
			shaderPass.uniforms.uAmt.value = $amplitude;
			shaderPass.uniforms.uBlur.value = $blur;

			const rect = video?.getBoundingClientRect();
			console.log('🚀 ~ rect SUBSEQUENT', rect.width);

			// console.log($glY, $glScale);
			// const style = window.getComputedStyle(video);
			// let matrix = new WebKitCSSMatrix(style.transform);

			plane.position.set(
				rect.x + rect.width * 0.5 - renderer.getSize(vec).x * 0.5,
				-rect.y - rect.height + renderer.getSize(vec).y * 0.5 + $glY * -renderer.getSize(vec).y,
				1.0
			);
			// // console.log({ $glY, $glScale }, rect.width);
			plane.scale.set($glScale, $glScale, 1.0);

			// camera.position.set(0, -$scroll.value || 0, z);
			// plane.rotation.y += 0.02;

			composer.render(scene, camera);
			requestAnimationFrame(raf);
		};
		requestAnimationFrame(raf);
	});
</script>

<div bind:this={canvas} class="canvas" />

<style>
	.canvas {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		z-index: -1;
	}
</style>
