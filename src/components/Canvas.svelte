<script>
	import { Renderer, TextureLoader, Mesh, Transform, Program, Box, Geometry, Vec2 } from 'ogl';
	import fragment from '../code/js/shaders/frag.glsl';
	import vertex from '../code/js/shaders/vertex.glsl';
	import { onMount } from 'svelte';
	let canvas;

	onMount(() => {
		const renderer = new Renderer({
			width: window.innerWidth,
			height: window.innerHeight
		});
		const gl = renderer.gl;
		canvas.appendChild(gl.canvas);

		// Triangle that covers viewport, with UVs that still span 0 > 1 across viewport
		const geometry = new Geometry(gl, {
			position: { size: 2, data: new Float32Array([-1, -1, 3, -1, -1, 3]) },
			uv: { size: 2, data: new Float32Array([0, 0, 2, 0, 0, 2]) }
		});
		// Alternatively, you could use the Triangle class.

		const program = new Program(gl, {
			vertex,
			fragment,
			uniforms: {
				uTime: { value: 0 },
				uResolution: { value: new Vec2(window.innerWidth, window.innerHeight) }
			}
		});

		const mesh = new Mesh(gl, { geometry, program });

		const raf = (time) => {
			program.uniforms.uTime.value = time * 0.001;

			renderer.render({ scene: mesh });
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
