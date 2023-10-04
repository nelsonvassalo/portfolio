<script>
	import { onMount, tick } from 'svelte';
	import gsap from 'gsap';
	import S from './SwapCharacter.svelte';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';

	let text;
	let data;
	let content;
	let spans = [];
	let justHovered = false;
	let hover = false;
	let hovering;
	export let tag = 'span';
	export let triggerType;
	export let className;

	$: {
		let data = text?.innerText;
		if (text) text.innerText = '';
		if (data) content = Array.from(data);

		if (content) setAnimations();

		if (triggerType == 'hover') {
			if (hover) {
				animateIn();
				justHovered = true;
			}
			if (!hover && justHovered) {
				animateOut();
				justHovered = false;
			}
		}
	}

	const setAnimations = async () => {
		// console.log('setting anims', text.querySelectorAll('span'));
	};
	const animateIn = () => {
		hovering = true;
	};
	const animateOut = () => {
		hovering = false;
	};

	onMount(async () => {
		await tick();
		let trigger;

		if (triggerType == 'scroll')
			trigger = new ScrollTrigger({
				trigger: text,
				markers: true
			});
	});
</script>

<svelte:element
	this={tag}
	bind:this={text}
	class={className}
	on:mouseenter={animateIn}
	on:mouseleave={animateOut}
>
	<slot />
	{#if content}
		{#each content as letter, i}
			<S bind:this={spans[i]} trigger={triggerType} stagger={0.05 * i} {hovering}>{letter}</S>
		{/each}
	{/if}
</svelte:element>

<style>
	span {
		display: inline;
		width: auto;
	}
</style>
