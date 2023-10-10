<script>
	import A from './AnimatedWord.svelte';
	import { lenisStore } from '../code/js/store';
	import Lenis from '@studio-freight/lenis';
	export let target;
	export let id;
	export let isActive;
	function handleClick(e, link) {
		console.log('click', { link });
		// e.preventDefault();
		const anchorId = link.replace('#', '');
		const anchor = document.getElementById(anchorId);

		$lenisStore.scrollTo(anchor, {
			offset: -50
		});
	}
</script>

<A tag="a" triggerType="hover" href={target} {isActive} on:click={(e) => handleClick(e, target)}
	>{id}</A
>
