<script>
	import '../code/scss/main.scss';
	import { onMount } from 'svelte';
	import Lenis from '@studio-freight/lenis';
	import gsap from 'gsap';
	import { Renderer, TextureLoader, Mesh, Transform, Program, Box, Geometry } from 'ogl';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';
	import S from '../components/SwapWord.svelte';
	import Header from '../components/Header.svelte';

	let video;
	let canvas;
	let header;

	onMount(() => {
		gsap.registerPlugin(ScrollTrigger);
		const lenis = new Lenis({
			// duration: 2,
			// lerp: 1
			easing: (t) => {
				return t < 0.5 ? 16 * t * t * t * t * t : 1 - Math.pow(-2 * t + 2, 5) / 2;
			}
		});
		lenis.on('scroll', (e) => console.log(e));

		console.log({ header });
		const topLimit = header?.getBoundingClientRect().height;

		const panels = gsap.utils.toArray('.panel');
		// Pinning
		panels.forEach((panel) => {
			ScrollTrigger.create({
				// snap: {
				// 	snapTo: 0.5,
				// 	duration: 0.2
				// },
				trigger: panel,
				markers: true,
				pin: true, // pin the trigger element while active
				start: `top ${topLimit}`, // when the top of the trigger hits the top of the viewport // end after scrolling 500px beyond the start
				scrub: true, // smooth scrubbing, takes 1 second to "catch up" to the scrollbar
				pinSpacing: false,
				anticipatePin: 1,
				onUpdate: (self) => console.log(self.getVelocity())
				// snap: {
				// 	// snapTo: 'labels', // snap to the closest label in the timeline
				// 	duration: { min: 0.2, max: 4 }, // the snap animation should be at least 0.2 seconds, but no more than 3 seconds (determined by velocity)
				// 	delay: 0.1, // wait 0.2 seconds from the last scroll event before doing the snapping
				// 	ease: 'power1.inOut' // the ease of the snap animation ("power3" by default)
				// }
			});
		});

		const tl = gsap.timeline({
			paused: true
		});

		panels.forEach((panel) => {
			console.log(panel.clientHeight);
			tl.fromTo(
				panel,

				{
					scaleX: 0.5,
					scaleY: 0.5
					// y: '50%'
				},
				{
					scaleX: 1,
					scaleY: 1,
					// stagger: panel.clientHeight * 0.1,
					duration: 2,
					scrollTrigger: {
						markers: { startColor: 'black', endColor: 'blue' },
						trigger: panel,
						scrub: true,
						start: 'top center',
						end: "'+=1000"
					}
					// y: '-50%',
					// duration: 0.2
				}
			);
		});

		tl.to('main', {
			backdropFilter: 'blur(0px)',
			background: 'transparent'
		});

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
			vertex: /* glsl */ `
            attribute vec2 uv;
            attribute vec2 position;

            varying vec2 vUv;

            void main() {
                vUv = uv;
                gl_Position = vec4(position, 0, 1);
            }
        `,
			fragment: /* glsl */ `
            precision highp float;

            uniform float uTime;

            varying vec2 vUv;

            void main() {
                gl_FragColor.rgb = vec3(0.8, 0.7, 1.0) + 0.3 * cos(vUv.xyx + uTime);
                gl_FragColor.a = 1.0;
            }
        `,
			uniforms: {
				uTime: { value: 0 }
			}
		});

		const mesh = new Mesh(gl, { geometry, program });

		const raf = (time) => {
			lenis.raf(time);

			program.uniforms.uTime.value = time * 0.001;

			renderer.render({ scene: mesh });
			requestAnimationFrame(raf);
		};
		requestAnimationFrame(raf);
	});
</script>

<div bind:this={canvas} class="canvas" />

<Header bind:header />
<main>
	<section>
		<S tag="h1">Nelson Vassalo</S>
		<h2>
			<S tag="span">Designer</S>
			<S tag="span">& Developer</S>
		</h2>
		<small>&darr;</small>
	</section>
	<!-- <h1>Nelson Vassalo</h1>
	<h2>Designer & Developer</h2> -->
</main>
<aside class="panel">
	<video src="videos/summit.mp4" autoplay loop muted bind:this={video} />
</aside>
<aside class="panel">
	<video src="videos/summit.mp4" autoplay loop muted bind:this={video} />
</aside>
<aside class="panel">
	<video src="videos/summit.mp4" autoplay loop muted bind:this={video} />
</aside>
<article class="panel">
	<h3>
		One-man shop with 14 years of experience in digital experiences. Crafting culture-aware
		interactions with a crisp eye for engaging artistic, brand and ecommerce websites.
	</h3>
	<aside>
		<h4>Design + Technology since 2009</h4>
		<br />—<br />
		<ul>
			<li>Interaction Design</li>
			<li>Frontend Development</li>
			<li>Creative Coding with WebGL</li>
		</ul>
	</aside>
</article>

<style lang="scss">
	.panel {
		// position: fixed;
		width: 100%;
		height: 100%;
		top: 0;
		left: 0;
	}
	.canvas {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		z-index: -1;
	}

	aside {
		// transform: scale(0.7);
		transform-origin: 50% 100%;
		padding: 1rem;
		// position: fixed;
		width: 100vw;
		height: 100dvh;
		// top: 0;
		// left: 0;
		z-index: -1;
		video {
			width: 100%;
			border-radius: 0.5rem;
		}
	}
	article {
		display: grid;
		grid-template-columns: repeat(12, [col-start] 1fr);
		padding: 1rem;
		gap: 20px;
		aside {
			display: block;
			grid-column: 10 / span 3;
			width: auto;
		}
	}
	h3 {
		font-size: 3rem;
		text-indent: 2.7083333333em;
		font-weight: 300;
		grid-column: 1 / span 8;
		line-height: 1.2;
	}

	main {
		text-align: left;
		line-height: 1;
		width: 100%;
		display: flex;
		flex-direction: column;
		// align-items: end;
		justify-content: end;
		padding-block: 5.25rem;
		background: linear-gradient(to left, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0));
		background-size: 1rem 100%;
		background-repeat: repeat-x;
		backdrop-filter: blur(50px);
		section {
			display: flex;
			flex-wrap: wrap;
			justify-content: space-between;
		}

		small {
			font-size: 10.75rem;
			align-self: flex-end;
			font-weight: 500;
		}
	}
	:global(h1) {
		// font-family: /* 'Object Sans',  */ 'Nelson Mixed', 'NelsonMixed';
		font-weight: 600;
		font-size: 10rem;
		letter-spacing: -0.03em;
		// text-transform: uppercase;
		margin: 0;
		line-height: 1;
		// display: flex;
	}
	h2 {
		// font-family: /* 'Object Sans', */ 'Nelson Mixed', 'NelsonMixed';
		font-size: 10rem;
		letter-spacing: -0.03em;
		font-weight: 600;
		margin: 0;
		line-height: 1;
		display: flex;
		width: 7.022em;
		flex-direction: column;
		:global(> span:last-child) {
			align-self: flex-end;
		}
		// text-transform: uppercase;
	}
</style>
