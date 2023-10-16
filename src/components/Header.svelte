<script>
	import Ticker from './Ticker.svelte';
	import A from '../components/AnimatedWord.svelte';
	import NavItem from '../components/NavItem.svelte';
	import { activeNav, navItems } from '../code/js/store';
	import { onMount } from 'svelte';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';
	import gsap from 'gsap';

	export let header;
	let checkActive;
	let isActive;
	$navItems = [
		{
			id: 'Projects',
			target: '#projects'
		},
		{
			id: 'Info',
			target: '#info'
		},
		{
			id: 'Connect',
			target: '#connect'
		}
	];

	$: {
		checkActive = (i) => {
			console.log('check active', i, i === $activeNav);
			return i === $activeNav;
		};
	}
</script>

<header bind:this={header}>
	<a href="#">Nelson Vassalo</a>
	<nav>
		{#each $navItems as el, i}
			<NavItem id={el.id} target={el.target} isActive={checkActive(i)} />
		{/each}
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
		display: flex;
		gap: 0.15em;

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
