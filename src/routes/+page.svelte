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
			<div>
				<S tag="h1">Nelson Vassalo</S>
				<h2>
					<S>Designer</S>

					<S>& Developer</S>
				</h2>
				<small>&darr;</small>
			</div>

			<video src="videos/summit.mp4" autoplay loop muted bind:this={video} />
		</section>
		<section>
			<article style="background: #fff" class="about">
				<h3>
					One-man shop with 14 years of experience in digital experiences. Crafting culture-aware
					interactions with a crisp eye for engaging artistic, brand and ecommerce websites.
				</h3>
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
			<article><h2>Sample projects &darr;</h2></article>
		</section>
		<section class="panel">
			<article class="details">
				<h4><S tag="span">Multiply</S></h4>
				<div class="sidebar">
					<h5>A sleek, fast website for a PR agency moving at the speed of culture.</h5>
					<p>Front-end developer. <br />Made with Zero Studios.</p>
					<ul class="tags">
						<li>Sveltekit</li>
						<li>Prismic</li>
						<li>GSAP</li>
					</ul>
				</div>
			</article>
			<video src="videos/summit.mp4" autoplay loop muted bind:this={video} />
		</section>
		<section class="panel">
			<article class="details">
				<h4><S>WOO</S></h4>
				<div class="sidebar">
					<h5>A sleek, fast website for a PR agency moving at the speed of culture.</h5>
					<p>Front-end developer. <br />Made with Zero Studios.</p>
					<ul class="tags">
						<li>Sveltekit</li>
						<li>Prismic</li>
						<li>GSAP</li>
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

	h3 {
		font-size: 3rem;
		text-indent: 2.7083333333em;
		font-weight: 300;
		grid-column: 1 / span 8;
		line-height: 1.2;
	}

	h4 {
		letter-spacing: -0.05em;
		font-size: 12rem;
		font-weight: 500;
	}

	small {
		font-size: 10.75rem;
		align-self: flex-end;
		font-weight: 500;
	}

	.intro {
		width: 100%;
		height: 100dvh;
		display: flex;
		justify-content: end;
		div {
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
		small {
			position: sticky;
		}
	}
	.spacer {
		height: 50%;
	}

	.panel {
		position: relative;
		width: 100%;
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

	.about {
		padding-block: calc(6.5rem);
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
		h4 {
			grid-column: 1 / span 7;
		}

		.sidebar {
			grid-column: 9 / span 4;
		}

		aside {
			display: block;
			grid-column: 10 / span 3;
			width: auto;
		}
	}
</style>
