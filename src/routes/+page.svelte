<script>
	import '../code/scss/main.scss';
	import { SvelteComponent, onMount } from 'svelte';
	import Lenis from '@studio-freight/lenis';

	import html2canvas from 'html2canvas';
	import S from '../components/SwapWord.svelte';
	import Header from '../components/Header.svelte';
	import ScrollScene from '../components/ScrollScene.svelte';
	import Canvas from '../components/Canvas.svelte';

	let video;
	let header;
	let title;
	let loading = true;
	let main;

	onMount(() => {
		setTimeout(() => {
			loading = false;
		}, 300);
		// html2canvas(title, {
		// 	backgroundColor: null
		// }).then((canvas) => {
		// 	loading = false;
		// 	console.log({ canvas });
		// 	title.prepend(canvas);
		// 	title.querySelector('h1').style.display = 'none';
		// 	title.querySelector('h2').style.display = 'none';
		// 	title.querySelector('small').style.display = 'none';
		// });

		const lenis = new Lenis({
			// duration: 2,
			// lerp: 1
			easing: (t) => {
				return t < 0.5 ? 16 * t * t * t * t * t : 1 - Math.pow(-2 * t + 2, 5) / 2;
			}
		});
		lenis.on('scroll', (e) => console.log(e.animate.from, e.animate.to, e.animate.value));

		const raf = (time) => {
			lenis.raf(time);

			requestAnimationFrame(raf);
		};
		requestAnimationFrame(raf);

		// Cleanup
		return () => {
			lenis.destroy();
		};
	});
</script>

<Header bind:header />

<Canvas />
<main bind:this={main}>
	{#if loading}
		<section style="background: black; position: fixed; width: 100%; height: 100%; top: 0; left: 0">
			Loading
		</section>
	{/if}
	<!-- <h1>Nelson Vassalo</h1>
	<h2>Designer & Developer</h2> -->

	<ScrollScene {header}>
		<section bind:this={title} class="panel intro">
			<article>
				<S tag="h1">Nelson Vassalo</S>
				<h2>
					<S>Designer</S>
					<S>& Developer</S>
				</h2>
				<small>&darr;</small>
			</article>

			<video src="videos/summit.mp4" autoplay loop muted bind:this={video} />
		</section>
		<section class="about">
			<article style="background: #fff">
				<div class="text">
					<h3>
						One-man shop with 14 years of experience in digital experiences. Crafting culture-aware
						interactions with a crisp eye for engaging artistic, brand and ecommerce websites.
					</h3>
					<h4>Currently available.<br /> Freelance and select roles.</h4>
				</div>
				<aside>
					<p>Design + Technology since 2009</p>
					<br />—<br />
					<ul>
						<li>Interaction Design</li>
						<li>Frontend Development</li>
						<li>Creative Coding with WebGL</li>
					</ul>
				</aside>
			</article>
			<article class="projects">
				<h2>Sample projects</h2>
				<small>&darr;</small>
			</article>
		</section>

		<section class="panel">
			<article class="content">
				<h4 class="text"><S tag="span">Multiply</S></h4>

				<div class="sidebar">
					<h5>A sleek, fast website for a PR agency moving at the speed of culture.</h5>
					<p>Front-end developer. <br />Made with Zero Studios.</p>
					<ul class="tags">
						<li class="pill">Sveltekit</li>
						<li class="pill">Prismic</li>
						<li class="pill">GSAP</li>
					</ul>
				</div>
			</article>
			<video src="videos/summit.mp4" autoplay loop muted bind:this={video} />
		</section>
		<section class="panel">
			<article class="content">
				<h4 class="text"><S>WOO</S></h4>

				<div class="sidebar">
					<h5>A sleek, fast website for a PR agency moving at the speed of culture.</h5>
					<p>Front-end developer. <br />Made with Zero Studios.</p>
					<ul class="tags">
						<li class="pill">Sveltekit</li>
						<li class="pill">Prismic</li>
						<li class="pill">GSAP</li>
					</ul>
				</div>
			</article>
			<video src="videos/summit.mp4" autoplay loop muted bind:this={video} />
		</section>
	</ScrollScene>
</main>

<style lang="scss">
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

	h3 {
		font-size: 3rem;
		text-indent: 2.7083333333em;
		font-weight: 300;
		line-height: 1.2;
	}

	h4 {
		letter-spacing: -0.05em;
		font-size: 12rem;
		font-weight: 500;
	}

	.intro {
		display: flex;
		justify-content: end;
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
		small {
			font-size: 10.75rem;
			align-self: flex-end;
			font-weight: 500;
		}
		.text {
			grid-column: 1 / span 8;
		}
		article {
			// flex-wrap: wrap;
			position: relative;
			text-align: left;
			line-height: 1;
			width: 100%;
			height: 100%;
			display: flex;
			flex-wrap: wrap;
			// flex-direction: column;
			position: relative;
			// align-items: end;
			justify-content: space-between;
			padding-block: 5.25rem;
			background: rgba(255, 255, 255, 0.1);
			backdrop-filter: blur(50px);
			// position: absolute;
			align-items: end;
			align-content: end;
			z-index: 10;
		}
	}

	.panel {
		position: relative;
		width: 100%;
		height: 100dvh;
		overflow: hidden;
		// min-height: 100%;
		// top: 0;
		// left: 0;
		z-index: 2;
		// position: absolute;

		// backg§round: #fff;
		video {
			width: 100%;
			border-radius: 0.5rem;
			// transform: scale(0.6);
			transform-origin: 50% 100%;
			position: absolute;
			bottom: 0;
			// position: sticky;
			// margin-bottom: -2rem;
		}
	}

	.projects {
		justify-content: space-between;
		text-align: center;
		display: flex;
		font-size: 7.5rem;
		padding-block: 0.5em;
		background: #fff;

		h2 {
			font-size: 1em;
			letter-spacing: -0.04em;
			font-weight: 300;
			margin: 0;
		}
		small {
			font-weight: 300;
			font-size: 1em;
		}
	}

	.about {
		padding-block: calc(6.5rem);
		h4 {
			font-size: 2rem;
			font-weight: 300;
			letter-spacing: -0.03em;
		}
	}

	aside {
		// transform: scale(0.7);
		padding: 1rem;
		// position: fixed;
		width: 100vw;
		// height: 100dvh;
		// top: 0;
		// left: 0;
		// z-index: -1;
	}
	article {
		display: grid;
		grid-template-columns: repeat(12, [col-start] 1fr);
		padding: 1rem;
		gap: 20px;

		align-items: baseline;

		aside {
			display: block;
			grid-column: 10 / span 3;
			width: auto;
		}

		.text {
			grid-column: 1 / span 7;
		}

		&.content {
			z-index: 10;
			height: 100%;
			position: relative;
			align-items: center;

			.sidebar {
				grid-column: 8 / span 5;
				margin-top: 19.5rem;
				p {
					font-size: 1.5rem;
				}
				h5 {
					font-size: 3rem;
					margin-top: 0;
					margin-bottom: 0.5em;
					line-height: normal;
					font-weight: 500;
					letter-spacing: -0.02em;
				}
			}
		}
		ul {
			list-style: none;
			padding: 0;
			&.tags {
				display: flex;
				gap: 1rem;
			}
			li {
				list-style: none;
			}
		}
		.pill {
			font-size: 1.5rem;
			border: 2px solid currentColor;
			padding: 0.3em 0.8333em 0.2em;
			border-radius: 0.8em;
			display: flex;
			align-items: center;
		}
	}
</style>
