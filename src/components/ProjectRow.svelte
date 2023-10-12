<script>
	let video;
	import S from '../components/SwapWord.svelte';

	import Image from 'svelte-image';

	export let role;
	export let title;
	export let image;
	export let link;
	export let tags = [];
	export let archive;
</script>

<section>
	<svelte:element this={link ? 'a' : 'div'} href={link} target="_blank" class="content">
		<h4 class="text"><S tag="span">{title}</S></h4>

		<div class="role">
			<p>{@html role}</p>
		</div>
		<ul class="tags">
			{#each tags as tag}
				<li class="pill">{tag}</li>
			{/each}
		</ul>

		<img src={image} loading="lazy" width="1280" height="719" />
		<div class="arrow">
			{#if link}
				<div class="icon">
					<svg
						width="45"
						height="43"
						viewBox="0 0 45 43"
						fill="none"
						xmlns="http://www.w3.org/2000/svg"
					>
						<path
							d="M44.1334 1.03684L44.4456 30.8145L40.1526 34.8886L39.9965 8.22201L39.8403 8.07386L3.54461 42.5182L0.422395 39.5553L36.7181 5.11091L36.562 4.96276L8.4621 4.81461L12.7551 0.740551L44.1334 1.03684Z"
							fill="black"
						/>
					</svg>
				</div>
			{:else}
				Under request
			{/if}
		</div>
	</svelte:element>
</section>

<style lang="scss">
	.content {
		display: grid;
		grid-template-columns: repeat(12, [col-start] 1fr);
		column-gap: 20px;
		border-bottom: 2px solid #000;
		position: relative;

		align-items: center;
		text-decoration: none;
		background: #fff;
		transition: 0.2s background-color;
		z-index: 1;

		* {
			color: #000;
			transition: 0.2s 0.15s color;
		}
		h4 {
			letter-spacing: -0.05em;
			font-size: 3rem;
			font-weight: 500;
			padding-left: 0.66em;
			margin-block: 0.75em;
		}

		.text {
			grid-column: 1 / span 4;
			grid-row: 1/-1;
		}

		.role {
			grid-column: 5 / span 4;
			grid-row: 1/-1;
			p {
				font-size: 1.5rem;
			}
			h5 {
				font-size: 1.5rem;
				margin-top: 0;
				line-height: normal;
				font-weight: 500;
				letter-spacing: -0.02em;
			}
		}

		.tags {
			grid-column: 9 / span 4;
			grid-row: 1/-1;
		}

		img {
			grid-column: 5 / span 8;
			grid-row: 1/-1;
			width: 100%;
			opacity: 0;
			position: absolute;
			top: 1rem;
			transform: translateY(-32px);
			transition: transform 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
			z-index: 20;
			border-radius: 10px;
			pointer-events: none;
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
			font-size: 1.25rem;
			border: 2px solid currentColor;
			padding: 0.65em 0.8333em 0.6em;
			border-radius: 0.95em;
			display: flex;
			align-items: center;
		}
		.arrow {
			display: flex;
			.icon {
				display: flex;
				align-items: center;
				width: 80px;
				aspect-ratio: 1;
				border-radius: 45px;
				background: #fff;
				padding: 1.25rem;
				height: auto;
			}
			grid-column: 12 / 13;
			grid-row: 1/-1;

			z-index: 30;
			transition: transform 0.2s cubic-bezier(0.19, 1, 0.22, 1);
		}

		&:hover {
			background: #000;
			z-index: 2;
			* {
				color: #fff;
			}
			img {
				opacity: 1;
				transform: translateY(0px);
			}
			.arrow {
				span {
					color: #000;
				}
				transform: translate(-1rem, 1rem);
			}
		}
	}
</style>
