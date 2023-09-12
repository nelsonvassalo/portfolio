<script>
	import S from './SwapCharacter.svelte';
	let text;
	let data;
	let content;

	$: {
		data = text?.innerText;
		if (text) text.innerText = '';
		if (data) content = Array.from(data);
	}
</script>

<span bind:this={text}>
	<slot />
	{#if content}
		{#each content as letter}
			{#if letter != ' ' || letter != '&nbsp;'}
				<S>{letter}</S>
			{:else}
				&nbps;
			{/if}
		{/each}
	{/if}
</span>
