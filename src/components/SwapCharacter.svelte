<script>
	import { afterUpdate, beforeUpdate, onMount, tick } from 'svelte';
	let div;
	let hover = false;
	let width;
	let originalWidth;

	onMount(() => {
		// width = div.children[0].clientWidth;
		// div.style.width = div.offsetWidth;
	});

	afterUpdate(() => {
		width = div.children[0].clientWidth;

		// width = `${div.offsextWidth}px`;
		// div.style.width = width;
		// width  = 'auto';
		// width = 80;
		// width = div.offsetWidth;
	});

	function hoverHandler() {
		// prevWidth = div.offsetWidth;
		hover = true;
		div.style.display = 'inline-block';
		div.children[0].style.display = 'inline-block';
		setTimeout(() => {
			hover = false;
			width = originalWidth;
			setTimeout(() => {
				div.style.display = 'inline';
				div.children[0].style.display = 'inline';
			}, 200);

			// width = div.children[0].clientWidth;
			// div.style.width = prevWidth + 'px';
			// width = prevWidth;
		}, 750);
	}
</script>

<span bind:this={div} on:mouseenter={hoverHandler} class:hover style:width={width + 'px'}>
	<span>
		<slot />
	</span>
</span>

<style lang="scss">
	span {
		// display: inline-block;
		transition: width 0.1s linear;
		position: relative;
		cursor: default;
		span {
			// display: inline-block;
		}
		&.hover {
			max-width: 100px;
			width: 80px;
			font-weight: 700;
			// text-transform: uppercase;
			transition: opacity 0.2s linear;
			span {
				opacity: 1 !important;
			}
		}
	}
</style>
