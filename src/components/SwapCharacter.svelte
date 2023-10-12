<script>
	import { afterUpdate, beforeUpdate, onMount, tick } from 'svelte';
	import { fontsLoaded } from '../code/js/store';
	import FontFaceObserver from 'fontfaceobserver';
	let div;
	let hover = true;
	let width;
	let hoverWidth;
	let initialWidth;
	let loaded = false;
	let spans;
	export let trigger = null;
	export let hovering = false;
	export let mouseover = false;
	export let stagger = 0;

	$: {
		if (trigger == ('hover' || 'scroll')) {
			if (hovering) {
				setTimeout(() => {
					hoverHandler();
				}, stagger * 1000);
			} else {
				setTimeout(() => {
					leaveHandler();
				}, stagger * 1000);
			}
		}
	}

	onMount(async () => {
		hover = false;
	});

	afterUpdate(() => {
		// width = div.children[0].clientWidth;
		// width = `${div.offsextWidth}px`;
		// div.style.width = width;
		// width  = 'auto';
		// width = 80;
		// width = div.offsetWidth;
	});

	function hoverHandler() {
		// prevWidth = div.offsetWidth;
		hover = true;
		width = hoverWidth;
	}
	function leaveHandler() {
		setTimeout(() => {
			hover = false;

			width = initialWidth;
			// div.style.width = prevWidth + 'px';
			// width = prevWidth;
		}, 750);
	}
</script>

<span
	bind:this={div}
	on:mouseenter={!trigger && hoverHandler}
	on:mouseleave={!trigger && leaveHandler}
	class:hover
	style:width={width + 'px'}
	style:display="inline-block"
>
	<span>
		<slot />
	</span>
</span>

<style lang="scss">
	span {
		// display: inline-block;
		transition: width 1.7s cubic-bezier(0.075, 0.82, 0.165, 1);

		position: relative;
		// cursor: default;
		span {
			display: inline;
		}
		&.hover {
			// max-width: 100px;
			// width: 80px;
			font-weight: 700;
			transition: opacity 0.7s linear;
			span {
				opacity: 1 !important;
			}
		}
	}
</style>
