<script>
	import '../code/scss/main.scss';
	import { SvelteComponent, onMount } from 'svelte';
	import { writable } from 'svelte/store';
	import Lenis from '@studio-freight/lenis';
	import html2canvas from 'html2canvas';

	import { scroll } from '../code/js/store';
	import S from '../components/SwapWord.svelte';
	import Header from '../components/Header.svelte';
	import ScrollScene from '../components/ScrollScene.svelte';
	import Canvas from '../components/Canvas.svelte';
	import ProjectRow from '../components/ProjectRow.svelte';
	import A from '../components/AnimatedWord.svelte';

	let video;
	let header;
	let title;
	let loading = true;
	let main;

	onMount(() => {
		console.log('header from page', header);
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
		lenis.on('scroll', (e) => {
			scroll.set(e.animate);
			// console.log(e.animate.from, e.animate.to, e.animate.value)
		});

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

	<ScrollScene headerIn={header}>
		<section bind:this={title} class="panel intro">
			<article>
				<S tag="h1">Nelson Vassalo</S>
				<h2>
					<S>Designer</S>
					<S>& Developer</S>
				</h2>
				<small>&darr;</small>
			</article>

			<video
				src="videos/title1.mp4"
				autoplay
				loop
				muted
				bind:this={video}
				type="video/mp4; codecs='avc1.42E01E, mp4a.40.2'"
			/>
		</section>
		<section class="about">
			<article>
				<div class="text">
					<h3>
						One-man shop with 14 years of experience in digital experiences. Crafting culture-aware
						interactions with a crisp eye for engaging artistic, brand and ecommerce websites.
					</h3>
					<h4>Available for November.<br /> Freelance and select roles.</h4>
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
		</section>
		<section class="projects">
			<A tag="h2" triggerType="scroll">Projects</A>
			<small>&darr;</small>
		</section>

		<ProjectRow />
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

	:global(h3) {
		font-size: 3rem;
		text-indent: 2.7083333333em;
		font-weight: 300;
		line-height: 1.2;
	}

	:global(h4) {
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
			// position: absolute;
			align-items: end;
			align-content: end;
			z-index: 10;
		}
	}

	.panel {
		position: relative;
		width: 100%;
		min-height: 100vh;
		// overflow: hidden;
		// visibility: hidden;
		padding: 1rem;

		// min-height: 100%;
		// top: 0;
		// left: 0;
		z-index: 2;
		// position: absolute;

		// backg§round: #fff;
		article {
			background: rgba(255, 255, 255, 0.5);
			// backdrop-filter: blur(50px);
		}
		video {
			visibility: hidden;
			opacity: 0.5;
			width: calc(100% - 2rem);
			border-radius: 0.5rem;
			align-self: flex-start;
			// padding: 1rem;
			// transform: scale(0.6);
			transform-origin: 50% 100%;
			position: absolute;
			bottom: 0;
			left: 1rem;
			// position: sticky;
			// margin-bottom: -2rem;
		}
	}

	.projects {
		justify-content: center;
		text-align: center;
		display: flex;
		font-size: 17rem;
		padding-block-start: 0.5em;
		padding-block-end: 0;
		// background: #fff;

		:global(h2) {
			font-size: 1em;
			letter-spacing: -0.04em;
			font-weight: 700;
			margin: 0;
			margin-left: auto;
			letter-spacing: -0.02em;
		}
		small {
			font-weight: 300;
			font-size: 1em;
			margin-left: auto;
		}
	}

	.about {
		padding-block: calc(6.5rem);
		background: #fff;
		padding-inline: 1rem;
		.text {
			grid-column: 1 / span 9;
		}
		h3 {
			margin: 0;
		}
		h4 {
			font-size: 2rem;
			font-weight: 300;
			letter-spacing: -0.03em;
		}
	}

	article {
		display: grid;
		grid-template-columns: repeat(12, [col-start] 1fr);
		column-gap: 20px;

		align-items: baseline;
		aside {
			display: block;
			grid-column: 10 / span 3;
			width: auto;
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
</style>
