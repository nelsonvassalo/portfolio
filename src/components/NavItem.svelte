<script>
	import A from './AnimatedWord.svelte';
	export let target;
	export let id;
	export let isActive;
	function handleClick(e, link) {
		console.log('click', { link });
		e.preventDefault();
		const anchorId = link.replace('#', '');
		console.log('🚀 ~ anchorId:', anchorId);
		const anchor = document.getElementById(anchorId);
		console.log('🚀 ~ anchor:', anchor);

		window.scrollTo({
			top: anchor?.offsetTop,
			behavior: 'smooth'
		});
	}
</script>

<A tag="a" triggerType="hover" href={target} {isActive} on:click={(e) => handleClick(e, target)}
	>{id}</A
>
