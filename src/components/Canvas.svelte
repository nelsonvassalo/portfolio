<script>
	import {
		Renderer,
		TextureLoader,
		Mesh,
		Transform,
		Program,
		Box,
		Geometry,
		Vec2,
		Plane,
		Camera
	} from 'ogl';
	import fragment from '../code/js/shaders/frag.glsl';
	import vertex from '../code/js/shaders/vertex.glsl';
	import { onMount } from 'svelte';

	import { scroll, glScale, glY } from '../code/js/store';
	let canvas;

	$: console.log($scroll);

	onMount(() => {
		const wW = window.innerWidth;
		const wH = window.innerHeight;
		const renderer = new Renderer({
			width: wW,
			height: wH
		});
		const gl = renderer.gl;
		canvas.appendChild(gl.canvas);

		gl.clearColor(1, 1, 1, 0);

		const scene = new Transform();
		const fov = 45;

		const camera = new Camera(gl, { fov, far: 5000 });
		camera.perspective({ aspect: gl.canvas.width / gl.canvas.height });

		const z = (gl.canvas.height / Math.tan((fov * Math.PI) / 360)) * 0.5;

		camera.position.set(0, 0, z);
		// camera.lookAt([0, 0, 0]);

		function resize() {
			renderer.setSize(wW, wH);
			camera.perspective({ aspect: gl.canvas.width / gl.canvas.height });
		}

		resize();

		// Triangle that covers viewport, with UVs that still span 0 > 1 across viewport
		const geometry = new Geometry(gl, {
			position: { size: 2, data: new Float32Array([-1, -1, 3, -1, -1, 3]) },
			uv: { size: 2, data: new Float32Array([0, 0, 2, 0, 0, 2]) }
		});
		// Alternatively, you could use the Triangle class.

		const program = new Program(gl, {
			vertex,
			fragment: /* glsl */ `
                precision highp float;

                varying vec3 vNormal;

                void main() {
                    vec3 normal = normalize(vNormal);
                    float lighting = dot(normal, normalize(vec3(-0.3, 0.8, 0.6)));
                    gl_FragColor.rgb = vec3(0., 0., 1.0) + lighting * 0.1;
                    gl_FragColor.a = 1.0;
                }
            `,

			cullFace: null,
			uniforms: {
				uTime: { value: 0 },
				uResolution: { value: new Vec2(wW, wH) }
			}
		});

		const planeGeom = new Plane(gl);

		const video = document.querySelector('video');
		const rect = video?.getBoundingClientRect();
		console.log('🚀 ~ rect:', rect);
		const plane = new Mesh(gl, { geometry: planeGeom, program });
		plane.position.set(0, rect.top, 0);
		plane.scale.set(rect.width, rect.height);
		plane.setParent(scene);

		const mesh = new Mesh(gl, { geometry, program });

		window.addEventListener('resize', resize);

		const raf = (time) => {
			program.uniforms.uTime.value = time * 0.001;
			// plane.position.set(0, $scroll.value * 0.1 || 0, 0);
			const rect = video?.getBoundingClientRect();

			console.log($glY, $glScale);
			// const style = window.getComputedStyle(video);
			// let matrix = new WebKitCSSMatrix(style.transform);

			plane.position.set(
				rect.x + rect.width * 0.5 - gl?.canvas.width * 0.5,
				-rect.y - rect.height * 0.5 + gl?.canvas.height * 0.5 + $glY * wH,
				1.0
			);
			console.log({ $glY, $glScale }, rect.width);
			plane.scale.set(rect?.width * $glScale, rect?.height * $glScale, 1.0);

			camera.position.set(0, -$scroll.value || 0, z);
			// plane.rotation.y += 0.02;

			renderer.render({ scene, camera });
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
