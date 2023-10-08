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
	export let isActive;
	export let href = tag === 'a' ? href : false;

	$: {
		let data = text?.innerText;
		if (text) text.innerText = '';
		if (data) content = Array.from(data);

		if (triggerType == 'hover') {
			if (hover) {
				animateIn();
			}
			if (!hover && justHovered) {
				justHovered = true;
				animateOut();
			}
		}
	}

	const animateIn = () => {
		hovering = true;
	};
	const animateOut = () => {
		hovering = false;
		justHovered = false;
	};

	onMount(async () => {
		await tick();

		gsap.registerPlugin(ScrollTrigger);
		if (triggerType == 'scroll') {
			hovering = true;
			// justHovered = true;
			// gsap.to(text, {
			// 	scrollTrigger: {
			// 		trigger: text,
			// 		markers: true,

			// 	}
			// });
			ScrollTrigger.create({
				trigger: text,
				markers: true,
				start: 'top center',
				end: '+=1300',
				onLeave: () => {
					hovering = false;
				}
			});
		}
	});
</script>

<svelte:element
	this={tag}
	bind:this={text}
	class={className}
	class:active={isActive}
	on:mouseenter={animateIn}
	on:mouseleave={animateOut}
	on:click
	{href}
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
	a {
		color: #000;
		text-decoration: none;
	}
</style>
