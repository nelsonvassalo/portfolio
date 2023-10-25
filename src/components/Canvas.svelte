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
		ShaderMaterial,
		Plane,
		PlaneGeometry
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

	import { glScale, amplitude, hblur, vblur, kernel, alpha } from '../code/js/store';
	import RoundedRectangle from '../code/js/RoundedRectangle';
	import AnimatedWord from './AnimatedWord.svelte';
	import { FullScreenQuad } from 'three/examples/jsm/postprocessing/Pass';
	let canvas;

	onMount(() => {
		let wW, wH;
		const renderer = new WebGLRenderer({
			antialias: true
		});

		function resize() {
			wW = window.innerWidth;
			wH = window.innerHeight;
			renderer.setSize(wW, wH);
			// camera.perspective({ aspect: gl.canvas.width / gl.canvas.height });
		}

		resize();

		window.addEventListener('resize', resize);

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

		// const blurShader = {
		// 	uniforms: {
		// 		uResolution: {
		// 			value: new Vector2(wW, wH)
		// 		},
		// 		direction: {
		// 			value: new Vector2(10, 10)
		// 		},
		// 		tDiffuse: {
		// 			value: null
		// 		}
		// 	},
		// 	vertexShader: vertex,
		// 	fragmentShader: blurFrag
		// };

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
				blurDirection: {
					value: new Vector2(0, 0)
				},
				alpha: {
					value: 0
				},
				uMouse: {
					value: 0
				}
			},
			vertexShader: vertex,
			fragmentShader: fragment
		};

		const shaderMaterial = new ShaderMaterial(shader);

		const planeGeom = new RoundedRect(video?.offsetWidth, video?.offsetHeight, 10, 64);

		const plane = new Mesh(planeGeom, material);

		scene.add(plane);
		const blurPlaneGeom = new PlaneGeometry(wW, wH);
		const blurPlane = new Mesh(blurPlaneGeom, shaderMaterial);

		scene.add(blurPlane);

		window.addEventListener('resize', resize);

		window.addEventListener('mousemove', (e) => {
			shaderMaterial.uniforms.uMouse.value = e.x / wW;
		});

		const clock = new Clock();

		const iterations = 12;
		let writeBuffer = new WebGLRenderTarget(
			wW * window.devicePixelRatio,
			wH * window.devicePixelRatio
		);
		let readBuffer = new WebGLRenderTarget(
			wW * window.devicePixelRatio,
			wH * window.devicePixelRatio
		);
		// shaderMaterial.uniforms.blurDirection.value = new Vector2(10, 10);
		renderer.render(scene, camera);

		const raf = (time) => {
			const newTime = clock.getElapsedTime();
			shaderMaterial.uniforms.uTime.value = newTime;
			shaderMaterial.uniforms.uAmt.value = $amplitude;
			shaderMaterial.uniforms.alpha.value = $alpha;

			// blurPlane.render();

			//  FS Quad

			// renderer.setRenderTarget(readBuffer);

			// for (let i = 0; i < iterations; i++) {
			// 	let radius = iterations - i - 1;

			// shaderMaterial.uniforms.tDiffuse.value = readBuffer.texture;

			// renderer.setRenderTarget(writeBuffer);
			// // renderer.autoClear = false;
			// // renderer.setRenderTarget(null);

			// //
			// renderer.setRenderTarget(null);
			// renderer.render(scene, camera);
			// blurPlane.render(renderer);

			const rt = new WebGLRenderTarget(wW, wH);
			renderer.setRenderTarget(rt);

			for (let i = 0; i < iterations; i++) {
				let radius = iterations - i - 1 * 10;
				// let radius = iterations;
				renderer.render(blurPlane, camera);

				// renderer.render(scene, camera);
				// renderer.autoClear = true;

				// if (i == 0) {
				shaderMaterial.uniforms.tDiffuse.value = rt.texture;
				renderer.setRenderTarget(writeBuffer);
				renderer.render(blurPlane, camera);

				// }
				if (i % 2 === 0) {
					shaderMaterial.uniforms.tDiffuse.value = readBuffer.texture;
					shaderMaterial.uniforms.blurDirection.value = new Vector2(radius, 0);
					renderer.setRenderTarget(writeBuffer);
				} else {
					shaderMaterial.uniforms.tDiffuse.value = writeBuffer.texture;
					shaderMaterial.uniforms.blurDirection.value = new Vector2(0, radius);
					renderer.setRenderTarget(readBuffer);
				}
				renderer.render(blurPlane, camera);

				// blurPlane.render(renderer);

				// renderer.setRenderTarget(null);
				// blurPlane.render(renderer);
				// renderer.render(scene, camera);

				let t = writeBuffer;
				writeBuffer = readBuffer;
				readBuffer = t;
			}
			// renderer.setRenderTarget(rt);
			renderer.setRenderTarget(rt);
			renderer.render(scene, camera);
			renderer.setRenderTarget(null);
			renderer.render(scene, camera);
			// renderer.render(scene, camera);

			const rect = video?.getBoundingClientRect();

			plane.position.set(
				rect.x + rect.width * 0.5 - renderer.getSize(vec).x * 0.5,

				-rect.y - rect.height * 0.5 + renderer.getSize(vec).y * 0.5,
				1.0
			);
			// // console.log({ $glY, $glScale }, rect.width);
			plane.scale.set($glScale, $glScale, 1.0);

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
