<script>
	import '../code/scss/main.scss';
	import { onMount, tick } from 'svelte';
	import { fly, slide } from 'svelte/transition';
	import Lenis from '@studio-freight/lenis';
	import html2canvas from 'html2canvas';
	import isMobile from 'ismobilejs';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';
	import { scroll, activeNav, lenisStore, fontsLoaded } from '../code/js/store';
	import S from '../components/SwapWord.svelte';
	import Header from '../components/Header.svelte';
	import ScrollScene from '../components/ScrollScene.svelte';
	import Canvas from '../components/Canvas.svelte';
	import ProjectRow from '../components/ProjectRow.svelte';
	import A from '../components/AnimatedWord.svelte';
	import FontFaceObserver from 'fontfaceobserver';
	import { backInOut, circOut, expoInOut, expoOut, sineOut } from 'svelte/easing';
	import gsap from 'gsap';

	let video;
	let videoPlay;
	let header;
	let title;
	let loading = true;
	let main;
	let ulWidth;
	let lenis;

	onMount(() => {
		console.log('isMobile?', isMobile().any);
		// setTimeout(() => {
		// 	loading = false;
		// }, 300);
		let font1 = new FontFaceObserver('Object Sans', {
			weight: 700
		});
		let font2 = new FontFaceObserver('Object Sans');
		$fontsLoaded = [font1.load(), font2.load()];
		console.log('🚀 ~ fontsLoaded:', $fontsLoaded);

		videoPlay = video?.play();
		const promises = [...$fontsLoaded, videoPlay];

		gsap.set(title, {
			y: '100%'
		});

		const titleEls = gsap.utils.toArray(title.querySelectorAll('h1, h2, small'));
		console.log('🚀 ~ titleEls:', titleEls);

		gsap.set(titleEls, {
			yPercent: 200
			// y: (i) => `${(i + 1) * 400}%`
		});

		Promise.all(promises).then(async () => {
			await tick();
			loading = false;
			gsap.to(titleEls, {
				yPercent: 0,
				duration: (i) => 1 + i * 0.2,
				ease: 'expo.inOut',
				stagger: 0.2,
				delay: 0.1
			});
			gsap.set(video, {
				yPercent: 100
			});
			gsap.to(
				video,

				{
					yPercent: 0,
					duration: 1.5,
					delay: 0.2,
					ease: 'expo.inOut'
				}
			);
		});

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

		lenis = new Lenis();

		lenis.on('scroll', (e) => {
			ScrollTrigger.update();
			$scroll = e.animate;
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
	$: {
		$lenisStore = lenis;
	}
</script>

<svelte:head>
	<link rel="preload" href="/fonts/ObjectSans-Regular.woff2" as="font" crossOrigin="anonymous" />
</svelte:head>

<Header bind:header />

{#if !loading && !isMobile().any}
	<Canvas />
{/if}
<main bind:this={main} class:loading>
	{#if loading}
		<section class="loader" out:slide={{ y: '-200%', duration: 700, easing: expoInOut }}>
			<p>Loading</p>
		</section>
		<!-- <h1>Nelson Vassalo</h1>
	<h2>Designer & Developer</h2> -->
	{/if}
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

			<video autoplay loop muted bind:this={video} crossorigin="anonymous">
				<source src="/videos/title1.mp4" type="video/mp4" />
				<source src="/videos/title1.mp4" type="video/mp4; codecs='avc1.42E01E, mp4a.40.2'" />
			</video>
		</section>
		<section class="about">
			<article>
				<div class="text">
					<h3>
						One-man shop with 14 years of experience in digital experiences. Crafting culture-aware
						interactions with a crisp eye for engaging artistic, brand and ecommerce websites.
					</h3>
					<h4>Available for February 25.<br /> Freelance and select roles.</h4>
				</div>
				<aside>
					<p>Design + Technology<br /> since 2009 <br />—</p>
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
			<!-- <ProjectRow
				title="Guayaki"
				role="Front-end development.<br/>Made with Zero Studios."
				image="/images/guayaki.jpg"
				tags={['Shopify', 'GSAP']}
			/> -->
			<ProjectRow
				title="WOO"
				role="Strategy, design & development. <br />Archive"
				tags={['GSAP']}
				link="https://archive.nelsonvassalo.com/"
				image="/images/woo.jpg"
			/>
			<ProjectRow
				title="Lokai"
				link="https://lokai.com/"
				role="Part of development team.<br/> Made with Zero Studios"
				tags={['Shopify', 'GSAP']}
				image="/images/lokai.jpg"
			/>
			<ProjectRow
				title="Crap Eyewear"
				link="https://www.crapeyewear.com/"
				role="Part of development team. <br/>Made with Zero Studios"
				tags={['Shopify', 'GSAP']}
				image="/images/crap.jpg"
			/>
			<ProjectRow
				title="Guayaki"
				link="https://guayaki.com/"
				role="Part of development team. <br/>Made with Zero Studios"
				tags={['Shopify', 'GSAP']}
				image="/images/guayaki.jpg"
			/>
			<ProjectRow
				title="Jen Lu"
				link="https://jen.lu/"
				role="Interactive Design and development"
				tags={['Gatsby', 'React', 'Three.js']}
				image="/images/jenlu.jpg"
			/>
			<ProjectRow
				title="ADC Awards"
				link="https://adcgame.karlssonwilker.com/"
				role="Interactive Design and Development"
				tags={['Phaser.js', 'Sveltekit']}
				image="/images/adcawards.jpg"
			/>
			<ProjectRow
				title="Black Frame"
				link="https://framenoir.com/"
				role="Interactive Design and Development<br/>Made with For Office Use Only"
				tags={['GSAP', 'Three.js']}
				image="/images/blackframe.jpg"
			/>
			<article class="content clients" style="--width: -{ulWidth}px">
				<h3>Clients</h3>
				<div>
					<ul bind:offsetWidth={ulWidth}>
						<li><a href="http://adcawards.org/" target="_blank">Art Directors Club</a></li>
						<li><a href="http://paul-institute.com/" target="_blank">Paul Institute Records</a></li>
						<li><a href="http://basedesign.com" target="_blank">BaseDesign</a></li>
						<li><a href="http://karlssonwilker.com" target="_blank">Karlssonwilker</a></li>
						<li><a href="http://www.nos.pt/en/" target="_blank">NOS</a></li>
						<li><a href="http://getgolden.com" target="_blank">Get Golden</a></li>
						<li><a href="http://www.emakina.com/en-be/home" target="_blank">Emakina</a></li>
						<li><a href="http://alexiszurflueh.com/" target="_blank">Alexis Zurflüh</a></li>
						<li>
							<a
								href="http://www.theverge.com/2018/9/13/17847312/human-fashion-show-installation-body-modification-sci-fi-transdermal-implants"
								target="_blank">Society of Spectacle</a
							>
						</li>
						<li><a href="http://moondial.com/supa/" target="_blank">SUPA</a></li>
						<li><a href="https://www.ponyearth.com/" target="_blank">Pony Earth</a></li>
					</ul>
					<ul>
						<li><a href="http://adcawards.org/" target="_blank">Art Directors Club</a></li>
						<li><a href="http://paul-institute.com/" target="_blank">Paul Institute Records</a></li>
						<li><a href="http://basedesign.com" target="_blank">BaseDesign</a></li>
						<li><a href="http://karlssonwilker.com" target="_blank">Karlssonwilker</a></li>
						<li><a href="http://nos.pt" target="_blank">NOS</a></li>
						<li><a href="http://getgolden.com" target="_blank">Get Golden</a></li>
						<li><a href="http://www.emakina.com/en-be/home" target="_blank">Emakina</a></li>
						<li><a href="http://alexiszurflueh.com/" target="_blank">Alexis Zurflüh</a></li>
						<li>
							<a
								href="http://www.theverge.com/2018/9/13/17847312/human-fashion-show-installation-body-modification-sci-fi-transdermal-implants"
								target="_blank">Society of Spectacle</a
							>
						</li>
						<li><a href="http://moondial.com/supa/" target="_blank" />SUPA</li>
						<li><a href="https://www.ponyearth.com/" target="_blank" />Pony Earth</li>
					</ul>
				</div>
			</article>
		</section>
		<section id="info" class="info">
			<article class="resume content">
				<div class="resume-content">
					<p>
						With a background in graphic design and a former student of the MFA Design + Technology
						at Parsons School of Design, I merge both fields for digital experiences that bring
						delight.
					</p>
					<p>
						I have been designing and developing digital artifacts for over 13 years, both as a
						freelancer collaborating in cultural, brand and product/D2C projects and as part of
						focused creative studios.<br />
					</p>
					<p>
						Based in Lisbon, Brooklyn, and always on the web.<br />
						Previously at <a href="https://dresscodeny.com/" target="_blank">Dress Code</a>,
						<a href="https://forofficeuseonly.com/" target="_blank">For Office Use Only</a>,
						<a href="https://zero.nyc/" target="_blank">Zero Studios</a>.
					</p>
				</div>
				<div class="portrait">
					<img src="/images/photo.jpg" alt="" loading="lazy" />
				</div>
			</article>

			<article class="content stack">
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
					<li>Contentful</li>
					<li>Shopify</li>
					<li>Prismic</li>
					<li>Wordpress</li>
				</ul>
				<section class="content colophon">
					<h3>Colophon</h3>

					<ul>
						<li>Sveltekit</li>
						<li>Three.js + custom GLSL</li>
						<li>GSAP</li>
						<li>Lenis Scroll</li>
						<li>SASS</li>
						<li>Spotify API</li>
					</ul>
					<p>Fonts</p>

					<ul>
						<li>
							Object Sans by <a href="https://pangrampangram.com/" target="_blank"
								>Pangram Pangram</a
							>
						</li>
						<li>Custom font</li>
					</ul>
				</section>
			</article>
		</section>
		<section id="connect" class="connect">
			<div class="contact-detail">
				<small>Email</small>
				<A tag="a" triggerType="hover" href="mailto:mail@nelsonvassalo.com" target="_blank"
					>mail (at) nelsonvassalo.com</A
				>
			</div>
			<div class="contact-detail">
				<small>Instagram</small>
				<A tag="a" triggerType="hover" href="http://instagram.com/nelson_vassalo" target="_blank"
					>@nelson_vassalo</A
				>
			</div>
			<footer>
				<ul>
					<li><a href="https://github.com/nelsonvassalo" target="_blank">GitHub</a></li>
					<li><a href="https://www.linkedin.com/in/vassalo/" target="_blank">LinkedIn</a></li>
					<li>
						<a href="https://workingnotworking.com/15214-nelson" target="_blank"
							>Working Not Working</a
						>
					</li>
				</ul>
			</footer>
		</section>
	</ScrollScene>
</main>

<style lang="scss">
	@media screen and (max-width: 48rem) {
		:global(body:before) {
			content: 'Nelson Vassalo \a Designer & Developer\a \a Best seen on a desktop';
			background-color: #000;
			color: #fff;
			font-size: 2rem;
			position: fixed;
			z-index: 20;
			top: 0;
			left: 0;
			height: 100%;
			display: flex;
			width: 100vw;
			padding: 1rem;
			white-space: pre-wrap;
			font-weight: 600;
		}
	}

	@keyframes rotate {
		from {
			rotate: 0deg;
		}
		to {
			rotate: 360deg;
		}
	}
	.loader {
		font-size: 2rem;
		display: flex;
		justify-content: center;
		align-items: center;
		background: black;
		position: fixed;
		width: 100%;
		height: 100%;
		top: 0;
		left: 0;
		z-index: 10;
		color: #fff;
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
	.loading .container {
		transform: translateY(100vh);
		transition: transform 0.5s ease;
	}

	.container {
		transform: none;
	}

	.panel {
		position: relative;
		width: 100%;
		min-height: 100vh;
		// overflow: hidden;
		// visibility: hidden;
		padding: 1rem 0.625rem;

		// min-height: 100%;
		// top: 0;
		// left: 0;
		z-index: 2;
		// position: absolute;

		// backg§round: #fff;
		article {
			// background: rgba(255, 255, 255, 0.5);
			// backdrop-filter: blur(50px);
		}
		video {
			// visibility: hidden;
			opacity: 0;
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

	.intro {
		display: flex;
		justify-content: end;
		padding: 0;
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
			padding: 5.25rem 0.625rem;
			// position: absolute;
			align-items: end;
			align-content: end;
			z-index: 10;
		}
	}

	.projects {
		padding-block-end: 6.5rem;
		.clients {
			padding-block: 3.5rem;
			border-bottom: 2px solid #000;
			overflow: hidden;
			> div {
				width: calc(100% + 2rem);
				margin-left: -1rem;
				overflow: hidden;
			}
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
					font-size: 3rem;
					list-style-type: none;
					// flex: 25vw 0 0;
					text-align: center;
					font-weight: 500;
					letter-spacing: -0.05em;
					word-break: keep-all;
					a {
						display: block;
						line-height: 1;
						max-width: 390px;
						text-decoration: none;
						color: inherit;
					}
				}
			}
		}
	}
	.projects,
	.info {
		padding-inline: 0.625rem;
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

	.about {
		padding-block: calc(6.5rem);
		background: #fff;
		padding-inline: 0.625rem;
		.text {
			grid-column: 1 / span 8;
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
				font-weight: 600;
				font-size: 1.5rem;
				line-height: 1.2;
				padding: 0;
				p {
					margin: 0;
				}

				ul {
					margin: 0;
					padding: 0;
					list-style: none;
					font-weight: 500;
				}
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
			padding-block: 6.5rem;
			border-bottom: 2px solid #000;
			position: relative;
			h3 {
				display: flex;
				column-gap: 1rem;
				align-items: center;
			}
			> div {
				align-items: center;

				small {
					border: 2px solid #000;
					border-radius: 100px;
					aspect-ratio: 1;
					height: 2.5rem;
					width: 2.5rem;
					font-size: 1.5rem;
					display: flex;
					justify-content: center;
					// flex: auto 0 0;
					animation: 6s rotate infinite cubic-bezier(0.68, -0.55, 0.265, 1.55);
					align-items: center;
					font-weight: 600;
					padding-top: 0.2em;
				}
			}

			.resume-content {
				grid-column: 2 / span 7;
				a {
					font-weight: 400;
					text-decoration: none;
					color: inherit;
				}
			}

			.portrait {
				grid-column: 9 / span 4;
				position: absolute;
				height: 100%;
				img {
					width: 100%;
					height: 100%;
					object-fit: cover;
				}
			}

			p {
				font-size: 2rem;
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

		ul li {
			font-size: 1.25rem;
		}

		.stack {
			grid-template-columns: repeat(12, 1fr);
			grid-template-rows: 67px auto;
			column-gap: 2rem;
			// border-bottom: 2px solid #000;

			display: grid;
			padding-block: 6.5rem;
			h3 {
				grid-column: 4 / 9;
				grid-row: 1 / 2;
			}
			ul {
				padding: 0;
				list-style: none;
				line-height: 1.3;
			}
			ul {
				grid-row: 2 / -1;
				margin: 0;
			}
			ul:first-of-type {
				grid-column: 4 / span 3;
			}
			ul:nth-of-type(2) {
				grid-column: 7 / span 3;
			}

			.references {
				grid-column: 1 / span 3;
				// h3 {
				// 	font-size: 1.5rem;
				// }
				ul {
					padding: 0;
					list-style: none;

					a {
						font-weight: 600;
						// font-size: 1rem;
						text-decoration: none;
						color: inherit;
					}
				}
			}

			.colophon {
				grid-column: 10 / span 3;
				grid-row: 1/3;
				a {
					text-decoration: none;
					font-weight: 600;
					color: inherit;
				}
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
	.connect {
		background: #000;
		letter-spacing: -0.05em;
		display: flex;
		align-items: center;
		flex-direction: column;
		justify-content: center;
		padding-block-start: 6.5rem;
		gap: 2rem;
		color: #fff;
		position: relative;

		h3 {
			font-size: 2.5rem;
			text-align: center;
			margin-block: 0;
			letter-spacing: -0.05em;
		}

		.contact-detail {
			display: flex;
			flex-flow: column wrap;
			justify-content: center;
			align-items: start;
			height: 100%;
			:global(a:hover) {
				// color: #000;
				// background: #fff;

				box-shadow: inset #fff 8px 0px, inset #fff 0px 8px, inset #fff -8px 0, inset #fff 0 -8px;
				transition-delay: 0s;
			}
			:global(a) {
				font-size: 4.75rem;
				color: #fff;
				letter-spacing: -0.03em;
				transition: box-shadow 0.2s ease 1s;

				font-weight: 500;
				border: 3px solid #fff;
				padding: 0.4em 1em;
				border-radius: 0.605em;
			}
			small {
				font-size: 1.25rem;
				margin: 0.5em 1.5em;
			}
		}
		footer {
			margin-top: auto;
			// position: absolute;
			bottom: 0;
			left: 1em;
			background: #fff;
			color: #000;
			border-top: 1px solid #222;
			// width: calc(100% - 2em);
			width: 100%;
			padding: 1rem 0.625rem;
			margin-top: 6.5rem;

			ul {
				padding: 0;
				margin: 0;
				display: flex;
				list-style: none;
				gap: 1rem;
				a {
					text-decoration: none;
					color: inherit;
					font-weight: 600;
				}
			}
		}
	}

	aside {
		// transform: scale(0.7);
		padding: 1rem 0.625rem;
		// position: fixed;
		width: 100vw;
		// height: 100dvh;
		// top: 0;
		// left: 0;
		// z-index: -1;
	}
</style>
