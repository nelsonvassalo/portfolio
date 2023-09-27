<script>
	import { onMount } from 'svelte';
	import S from '../components/SwapWord.svelte';
	import Ticker from '../components/SpotifyTicker.svelte';

	let today;
	export let header;

	onMount(() => {
		let date;
		console.log({ header });
		function getToday() {
			date = new Date();
			today = `${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`.padStart(2, '0');
		}

		getToday();

		const timer = setInterval(() => {
			date = new Date();
			getToday();
		}, 1000);
		return () => {
			clearInterval(timer);
		};
	});
</script>

<header bind:this={header}>
	<a href="#">Nelson Vassalo</a>
	<nav>
		<S tag="a" className="active">Work</S>
		<S tag="a">Info</S>
		<S tag="a">Connect</S>
	</nav>
	{#if today}
		<aside>
			<time datetime={today}>LIS {today}</time>
			<time datetime={today.toLocaleString('en-US', { timeZone: 'America/New_York' })}
				>NYC {today.toLocaleString('en-US', { timeZone: 'America/New_York' })}</time
			>
		</aside>
	{/if}
	<!-- <Ticker /> -->
</header>

<style lang="scss">
	header {
		position: fixed;
		z-index: 10;
		top: 0;
		width: 100%;
		background: #fff;
		display: flex;
		justify-content: space-between;
		font-size: 1.25rem;
		align-items: center;
		padding-inline: 1rem;
		a {
			text-decoration: none;
			color: #000;
		}
	}

	nav {
		// padding: 1em;
		padding: 0.15em;
		:global(a) {
			padding: 0.7em 0.75em 0.6em;
			display: inline-block;
			border-radius: 4px;
			cursor: pointer;
			margin-right: 1em;
			&:hover {
				background: #f2f2f2;
			}
			&.active {
				background: #e4e4e4;
			}
		}
		// font-family: 'Nelson Mixed';
		// text-transform: uppercase;
	}
</style>
