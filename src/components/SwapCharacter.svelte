<script>
	import { afterUpdate, beforeUpdate, onMount, tick } from 'svelte';
	import FontFaceObserver from 'fontfaceobserver';
	let div;
	let hover = true;
	let width;
	let hoverWidth;
	let initialWidth;
	let loaded = false;

	onMount(async () => {
		let font = new FontFaceObserver('Object Sans', {
			weight: 700
		});
		font.load().then(async (font) => {
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
	on:mouseenter={hoverHandler}
	on:mouseleave={leaveHandler}
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
		transition: width 0.15s;
		position: relative;
		// cursor: default;
		span {
			display: inline;
		}
		&.hover {
			// max-width: 100px;
			// width: 80px;
			font-weight: 700;
			transition: opacity 0.2s linear;
			span {
				opacity: 1 !important;
			}
		}
	}
</style>
