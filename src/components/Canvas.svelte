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
		PlaneGeometry,
		LinearMipMapLinearFilter
	} from 'three';

	import fragment from '../code/js/shaders/frag.glsl';
	import vertex from '../code/js/shaders/vertex.glsl';
	import blurFrag from '../code/js/shaders/blurFrag.glsl';
	import RoundedRect from '../code/js/RoundedRectangle';

	import { glScale, amplitude, blur, alpha } from '../code/js/store';

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
		const secondScene = new Scene();

		const cameraPosition = 800;
		const fov = (180 * (2 * Math.atan(window.innerHeight / 2 / cameraPosition))) / Math.PI;

		const camera = new PerspectiveCamera(fov, wW / wH, 0.01, 5000);

		const z = (wW / Math.tan((fov * Math.PI) / 360)) * 0.5;
		camera.position.set(0, 0, cameraPosition);

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
				lod: {
					value: 6
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

		// secondScene.add(blurPlane);

		window.addEventListener('resize', resize);

		window.addEventListener('mousemove', (e) => {
			shaderMaterial.uniforms.uMouse.value = e.x / wW;
		});

		const clock = new Clock();

		let fbo = new WebGLRenderTarget(wW * window.devicePixelRatio, wH * window.devicePixelRatio, {
			generateMipmaps: true,
			minFilter: LinearMipMapLinearFilter
		});

		// shaderMaterial.uniforms.blurDirection.value = new Vector2(10, 10);
		shaderMaterial.uniforms.tDiffuse.value = fbo.texture;

		const raf = (time) => {
			const newTime = clock.getElapsedTime();
			shaderMaterial.uniforms.uTime.value = newTime;
			shaderMaterial.uniforms.uAmt.value = $amplitude;
			shaderMaterial.uniforms.alpha.value = $alpha;
			shaderMaterial.uniforms.lod.value = $blur;

			renderer.setRenderTarget(fbo);
			renderer.render(scene, camera);
			renderer.setRenderTarget(null);
			renderer.render(blurPlane, camera);
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
