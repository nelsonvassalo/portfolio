<script>
	import '../code/scss/main.scss';
	import { onMount } from 'svelte';
	import Lenis from '@studio-freight/lenis';
	import html2canvas from 'html2canvas';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';

	import { scroll, activeNav } from '../code/js/store';
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
	let ulWidth;

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

		ScrollTrigger.create({
			trigger: '#projects',
			start: 'bottom top',
			end: document.getElementById('projects').offsetHeight,
			markers: true,
			onToggle: ({ isActive }) => {
				console.log('toggle projects', { isActive });
				isActive ? ($activeNav = 0) : ($activeNav = null);
			}
		});

		ScrollTrigger.create({
			trigger: '#info',
			start: 'bottom top',
			end: document.getElementById('info').offsetHeight,
			markers: true,
			onToggle: ({ isActive }) => ($activeNav = 1),
			onLeaveBack: ({ isActive }) => ($activeNav = 0)

			// onEnterBack: () => {
			// 	$activeNav = 1;
			// }
		});

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
		<section class="projects" id="projects">
			<div>
				<h2>Projects</h2>
				<small>&darr;</small>
			</div>
			<ProjectRow
				title="Multiply"
				link="http://multiply.us"
				role="Front-end development.<br/>
							Made with Zero Studios."
				image="/images/multiply.jpg"
				tags={['Sveltekit', 'Prismic', 'GSAP']}
			/>
			<ProjectRow
				title="Guayaki"
				role="Front-end development.<br/>Made with Zero Studios."
				image="/images/guayaki.jpg"
				tags={['Shopify', 'GSAP']}
			/>
			<ProjectRow
				title="WOO"
				role="Strategy, design & development. <br />Archive"
				tags={['GSAP']}
				image="/images/woo.jpg"
			/>
			<ProjectRow
				title="Lokai"
				role="Part of development team.<br/> Made with Zero Studios"
				tags={['Shopify', 'GSAP']}
				image="/images/lokai.jpg"
			/>
			<ProjectRow
				title="Crap Eyewear"
				role="Part of development team. <br/>Made with Zero Studios"
				tags={['Shopify', 'GSAP']}
				image="/images/crap.jpg"
			/>
			<ProjectRow
				title="Jen Lu"
				role="Interactive Design and development"
				tags={['Gatsby', 'React', 'Three.js']}
				image="/images/jenlu.jpg"
			/>
			<ProjectRow
				title="ADC Awards"
				role="Interactive Design and Development"
				tags={['Phaser.js', 'Sveltekit']}
				image="/images/adcawards.jpg"
			/>
			<ProjectRow
				title="Black Frame"
				role="Interactive Design and Development<br/>Made with For Office Use Only"
				tags={['GSAP', 'Three.js']}
				image="/images/blackframe.jpg"
			/>
		</section>
		<section id="info" class="info">
			<div>
				<h2>Info</h2>
				<small>i</small>
			</div>
			<article class="resume content">
				<div class="resume-content">
					<p>
						Based in Lisbon, Brooklyn, and always on the web.<br />
						I have a background in graphic design and was a student of the MFA Design + Technology at
						Parsons School of Design. I fuse the two fields thorougly for consistent digital experiences
						founded on sharp visuals and interactions.
					</p>
					<p>
						I have been designing and developing experiences for over 13 years, both as a freelancer
						collaborating in cultural, brand and product/D2C projects and a full-time team player
						for focused creative studios.
					</p>
					<p>
						Previously at <a href="https://dresscodeny.com/" target="_blank">Dress Code</a>,
						<a href="https://forofficeuseonly.com/" target="_blank">For Office Use Only</a>,
						<a href="https://zero.nyc/" target="_blank">Zero Studios</a>.
					</p>
				</div>

				<section class="references">
					<h3>References</h3>
					<ul>
						<li>
							<a href="https://www.typewolf.com/site-of-the-day/nelson-vassalo" target="_blank"
								>Typewolf: site of the day</a
							>
						</li>
						<li>
							<a href="https://www.hoverstat.es/features/nelson-vassalo/" target="_blank"
								>Hover States</a
							>
						</li>
						<li>
							<a href="https://www.awwwards.com/sites/get-golden" target="_blank"
								>Awwwards Honorable Mention</a
							>
						</li>
						<li>
							<a href="https://www.awwwards.com/sites/jen-lu-v5" target="_blank"
								>Awwwards Honorable Mention</a
							>
						</li>
						<li>
							<a
								href="https://winners.webbyawards.com/2021/websites-and-mobile-sites/general-websites-and-mobile-sites/netart/167073/jenlu-v5"
								target="_blank">Webby Awards Honoree</a
							>
						</li>
						<li>
							<a href="https://mindsparklemag.com/website/screensaver-portfolio/" target="_blank"
								>Mindsparkle Mag</a
							>
						</li>

						<li>
							<a href="https://www.csswinner.com/details/screensaver-portfolio/11293">CSS Winner</a>
						</li>
						<li>
							<a
								href="https://cssdesignawards.com/sites/screensaver-portfolio/30270/"
								target="_blank">CSS Design Awards Nominee</a
							>
						</li>
					</ul>
				</section>
			</article>

			<article class="content clients" style="--width: -{ulWidth}px">
				<h3>Clients</h3>
				<div>
					<ul bind:offsetWidth={ulWidth}>
						<li><a href="" />Art Directors Club (One Club)</li>
						<li><a href="" />Paul Institute Records</li>
						<li><a href="" />BaseDesign</li>
						<li><a href="" />Karlssonwilker</li>
						<li><a href="" />NOS</li>
						<li><a href="" />Get Golden</li>
						<li><a href="" />SUPA</li>
						<li><a href="" />Pony Earth</li>
					</ul>
					<ul>
						<li><a href="" />Art Directors Club (One Club)</li>
						<li><a href="" />Paul Institute Records</li>
						<li><a href="" />BaseDesign</li>
						<li><a href="" />Karlssonwilker</li>
						<li><a href="" />NOS</li>
						<li><a href="" />Get Golden</li>
						<li><a href="" />SUPA</li>
						<li><a href="" />Pony Earth</li>
					</ul>
				</div>
			</article>
			<article class="content stack">
				<h3>Stack</h3>

				<ul>
					<li>React</li>
					<li>Sveltekit</li>
					<li>GSAP</li>
					<li>Three.js</li>
					<li>Tailwind</li>
					<li>Phaser.js</li>
					<li>P5.js</li>
					<li>GLSL shading</li>
				</ul>

				<ul>
					<li>Sanity.io</li>
					<li>Shopify</li>
					<li>Prismic</li>
					<li>Wordpress</li>
				</ul>
				<section class="content colophon">
					<p>Used on this site</p>

					<ul>
						<li>
							Object Sans by <a href="https://pangrampangram.com/" target="_blank"
								>Pangram Pangram</a
							>
						</li>
						<li>Custom pixel drawing font</li>
					</ul>
					<ul>
						<li>Sveltekit</li>
						<li>Three.js + custom GLSL</li>
						<li>SASS</li>
					</ul>
				</section>
			</article>
		</section>
	</ScrollScene>
</main>

<style lang="scss">
	@keyframes rotate {
		from {
			rotate: 0deg;
		}
		to {
			rotate: 360deg;
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

	:global(h3) {
		font-size: 3rem;
		font-weight: 300;
		line-height: 1.2;
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
		padding-block-end: 6.5rem;
	}
	.projects,
	.info {
		padding-inline: 1rem;
		background: #fff;
		:global(section:first-child .content) {
			border-top: 2px solid #000;
		}
		:global(h2) {
			font-size: 1em;
			letter-spacing: -0.04em;
			font-weight: 500;
			margin: 0;
			letter-spacing: -0.05em;
		}
		> div {
			justify-content: center;
			text-align: center;
			display: flex;
			font-size: 17rem;
			padding-block: 0.125em;

			// padding-block-end: 0;
			// background: #fff;

			small {
				font-weight: 300;
				font-size: 1em;
				margin-left: auto;
			}
		}
	}

	.info > div {
		align-items: center;
		small {
			border: 2px solid #000;
			border-radius: 100px;
			aspect-ratio: 1;
			height: 9rem;
			font-size: 0.5em;
			display: flex;
			justify-content: center;
			flex: auto 0 0;
			animation: 6s rotate infinite cubic-bezier(0.68, -0.55, 0.265, 1.55);
			width: auto;
			align-items: center;
			font-weight: 600;
			padding-top: 0.2em;
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

			text-indent: 2.7083333333em;
		}
		h4 {
			font-size: 2rem;
			font-weight: 300;
			letter-spacing: -0.03em;
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
	}

	.info {
		text-align: left;
		h3 {
			font-size: 2rem;
			margin-block-start: 0;
		}
		.resume {
			display: grid;
			grid-template-columns: repeat(12, 1fr);
			column-gap: 1rem;
			padding-block-end: 6.5rem;
			.resume-content {
				grid-column: 1 / span 8;
				a {
					font-weight: 400;
					text-decoration: none;
					color: inherit;
				}
			}
			.references {
				grid-column: 10 / span 3;
				h3 {
					font-size: 1.5rem;
				}
				ul {
					padding: 0;
					list-style: none;
					line-height: 1.25;
					a {
						font-weight: 600;
						font-size: 1rem;
						text-decoration: none;
						color: inherit;
					}
				}
			}

			p {
				font-size: 1.5rem;
				text-indent: 2.7083333333em;
				line-height: 1.25;
				font-weight: 300;
				&:first-of-type {
					margin-block: 0;
				}
			}
		}
		@keyframes ticker {
			from {
				translate: 0;
			}
			to {
				translate: var(--width);
			}
		}
		.clients {
			padding-block: 3.5rem;
			background: #000;
			margin-left: -1rem;
			width: calc(100% + 2rem);
			overflow: hidden;
			color: #fff;
			h3 {
				text-align: center;
				margin-bottom: 1.5em;
			}
			div {
				display: flex;
			}
			ul {
				display: flex;
				animation: 30s ticker linear infinite;
				column-gap: 6rem;
				align-items: center;
				flex-wrap: nowrap;
				margin: 0;
				padding-left: 0;
				flex: auto 0 0;
				padding-right: 6rem;
				li {
					max-width: 390px;
					font-size: 3rem;
					list-style-type: none;
					// flex: 25vw 0 0;
					text-align: center;
					line-height: 1;
					font-weight: 500;
					letter-spacing: -0.05em;
				}
			}
		}
		ul li {
			font-size: 1.25rem;
		}

		.stack {
			grid-template-columns: repeat(12, 1fr);
			grid-template-rows: 67px auto;

			display: grid;
			padding-block: 6.5rem;
			h3 {
				grid-column: 1 / 9;
				grid-row: 1 / -1;
			}
			ul {
				padding: 0;
				list-style: none;
			}
			ul {
				grid-row: 2 / 3;
			}
			ul:first-of-type {
				grid-column: 1 / span 4;
			}
			ul:nth-of-type(2) {
				grid-column: 5 / span 4;
			}

			.colophon {
				grid-column: 9 / span 4;
				grid-row: 2/3;
				h4 {
					font-size: 2rem;
					font-weight: 300;
					margin-block-start: 0;
				}

				h5 {
					font-size: 1.5rem;
					font-weight: 500;
				}
			}
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
