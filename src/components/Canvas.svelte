<script>
	import { onMount } from 'svelte';

	import {
		WebGLRenderer,
		Mesh,
		Vector2,
		Scene,
		PerspectiveCamera,
		MeshBasicMaterial,
		VideoTexture,
		LinearFilter,
		sRGBEncoding,
		Clock,
		SRGBColorSpace,
		ColorManagement,
		WebGLRenderTarget,
		ShaderMaterial
	} from 'three';
	// import {
	// 	EffectComposer,
	// 	KawaseBlurPass,
	// 	ShaderPass,
	// 	RenderPass,
	// 	GaussianBlurPass
	// } from 'postprocessing';

	import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer.js';
	import { RenderPass } from 'three/examples/jsm/postprocessing/RenderPass.js';
	import { ShaderPass } from 'three/examples/jsm/postprocessing/ShaderPass.js';
	import { HorizontalBlurShader } from 'three/examples/jsm/shaders/HorizontalBlurShader.js';
	import { VerticalBlurShader } from 'three/examples/jsm/shaders/VerticalBlurShader.js';

	import fragment from '../code/js/shaders/frag.glsl';
	import vertex from '../code/js/shaders/vertex.glsl';
	import blurFrag from '../code/js/shaders/blurFrag.glsl';
	import RoundedRect from '../code/js/RoundedRectangle';

	import { glScale, amplitude, hblur, vblur, kernel } from '../code/js/store';
	import RoundedRectangle from '../code/js/RoundedRectangle';
	let canvas;

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

		const cameraPosition = 800;
		const fov = (180 * (2 * Math.atan(window.innerHeight / 2 / cameraPosition))) / Math.PI;

		const camera = new PerspectiveCamera(fov, wW / wH, 0.01, 5000);

		const z = (wW / Math.tan((fov * Math.PI) / 360)) * 0.5;
		camera.position.set(0, 0, cameraPosition);
		// camera.lookAt([0, 0, 0]);

		function resize() {
			renderer.setSize(wW, wH);
			// camera.perspective({ aspect: gl.canvas.width / gl.canvas.height });
		}

		resize();

		const shader = {
			defines: { LABEL: 'value' },
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
				},
				uMouse: {
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

		const shaderMaterial = new ShaderMaterial(shader);

		const rect = video?.getBoundingClientRect();

		// const planeGeom = new PlaneGeometry(1, 1);
		const planeGeom = new RoundedRect(rect.width * 1.666666, rect.height * 1.66666, 10, 64);

		const plane = new Mesh(planeGeom, material);

		scene.add(plane);
		// plane.position.set(0, -rect.top, 0);
		// plane.scale.set(0.6, 0.6, 1.0);

		const composer = new EffectComposer(renderer);
		// const composer = new TEC(renderer);
		composer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
		composer.setSize(wW, wH);
		const renderPass = new RenderPass(scene, camera);
		// const blurPass = new GaussianBlurPass({
		// 	iterations: 12,
		// 	kernelSize: 24,
		// 	resolutionX: wW * 2
		// });
		const HBlurPass = new ShaderPass({
			...HorizontalBlurShader,
			uniforms: {
				...HorizontalBlurShader.uniforms,
				h: {
					value: (2.0 / wW) * window.devicePixelRatio
				}
			}
		});
		const VBlurPass = new ShaderPass({
			...VerticalBlurShader,
			uniforms: {
				...VerticalBlurShader.uniforms,
				v: {
					value: (2.0 / wW) * window.devicePixelRatio
				}
			}
		});
		const shaderPass = new ShaderPass(shaderMaterial, 'tDiffuse');

		// shaderPass.enabled = false;

		composer.addPass(renderPass);
		composer.addPass(HBlurPass);
		composer.addPass(VBlurPass);
		composer.addPass(shaderPass);
		// shaderPass.enabled = false;

		window.addEventListener('resize', resize);
		console.log({ canvas });
		window.addEventListener('mousemove', (e) => {
			shaderMaterial.uniforms.uMouse.value = e.x / wW;
		});

		const clock = new Clock();

		const iterations = 8;
		const fbo1 = new WebGLRenderTarget(wW, wH);
		const fbo2 = new WebGLRenderTarget(wW, wH);

		const raf = (time) => {
			const newTime = clock.getElapsedTime();
			shaderMaterial.uniforms.uTime.value = newTime;
			shaderMaterial.uniforms.uAmt.value = $amplitude;

			HBlurPass.uniforms.h.value = $hblur;
			VBlurPass.uniforms.v.value = $vblur;
			// blurPass.iterations = $blur;
			// blurPass.kernelSize = $kernel;

			const rect = video?.getBoundingClientRect();
			// console.log('🚀 ~ rect SUBSEQUENT', rect.width);

			// console.log($glY, $glScale);
			// const style = window.getComputedStyle(video);
			// let matrix = new WebKitCSSMatrix(style.transform);

			plane.position.set(
				rect.x + rect.width * 0.5 - renderer.getSize(vec).x * 0.5,

				-rect.y - rect.height * 0.5 + renderer.getSize(vec).y * 0.5,
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
