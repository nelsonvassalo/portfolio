<script>
	let video;
	import S from '../components/SwapWord.svelte';
</script>

<section>
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

<style lang="scss">
	article {
		display: grid;
		grid-template-columns: repeat(12, [col-start] 1fr);
		column-gap: 20px;

		align-items: baseline;

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
