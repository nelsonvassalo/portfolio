<script>
	import S from './SwapCharacter.svelte';
	let text;
	let data;
	let content;
	export let tag;
	export let className;

	$: {
		data = text?.innerText;
		if (text) text.innerText = '';
		if (data) content = Array.from(data);
		console.log({ content });
	}
</script>

<svelte:element this={tag} bind:this={text} class={className}>
	<slot />
	{#if content}
		{#each content as letter}
			{#if letter != (' ' || '' || '&nbsp;')}
				<S>{letter}</S>
			{:else}
				{letter}
			{/if}
		{/each}
	{/if}
</svelte:element>
