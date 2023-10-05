<script>
	import Ticker from './Ticker.svelte';
	import A from '../components/AnimatedWord.svelte';

	export let header;
</script>

<header bind:this={header}>
	<a href="#">Nelson Vassalo</a>
	<nav>
		<A tag="a" class="active" triggerType="hover">Projects</A>
		<A tag="a" triggerType="hover">Info</A>
		<A tag="a" triggerType="hover">Connect</A>
	</nav>
	<Ticker />
</header>

<style lang="scss">
	header {
		position: fixed;
		z-index: 10;
		top: 0;
		width: 100%;
		background: #fff;
		display: flex;
		justify-content: center;
		font-size: 1.25rem;
		align-items: center;
		padding-inline: 1rem;
		> a {
			position: absolute;
			left: 1rem;
		}
		a {
			text-decoration: none;
			color: #000;
		}
	}

	nav {
		// padding: 1em;
		padding: 0.15em;

		:global(a) {
			padding: 0.7em 1.5em 0.6em;
			display: inline-flex;
			border-radius: 4px;
			cursor: pointer;
			// margin-right: 1em;
			&:hover {
				background: #f2f2f2;
			}
		}
		:global(a.active) {
			background: #f2f2f2;
		}
		// font-family: 'Nelson Mixed';
		// text-transform: uppercase;
	}
</style>
