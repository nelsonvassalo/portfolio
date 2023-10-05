<script>
	import { afterUpdate, beforeUpdate, onMount, tick } from 'svelte';
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
				}, stagger * 2000);
			}
		}
	}

	onMount(async () => {
		let font1 = new FontFaceObserver('Object Sans');
		let font2 = new FontFaceObserver('Object Sans', {
			weight: 700
		});
		const promises = [font1.load(), font2.load()];

		Promise.all(promises).then(async (font) => {
			hoverWidth = div.children[0].offsetWidth;
			hover = false;
			await tick();
			// div.style.display = 'inline-block';
			loaded = true;
			initialWidth = div.offsetWidth;
		});

		// width = div.children[0].clientWidth;
		// div.style.width = div.offsetWidth;
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
	style:display={loaded && 'inline-block'}
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
