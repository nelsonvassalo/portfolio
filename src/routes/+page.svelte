<script>
	import S from '../components/SwapWord.svelte';
</script>

<main>
	<h1>
		<S>Nelson Vassalo</S>
	</h1>
	<h2><S>Designer & Developer</S></h2>
	<h2><S>Work</S></h2>
	<aside>
		Full portfolio
		<input type="text" placeholder="Enter your key here" />
	</aside>
</main>

<style lang="scss">
	:global(body) {
		display: flex;
		align-items: center;
		justify-content: center;
		height: 100vh;
	}
	main {
		text-align: center;
		line-height: 1;
	}
	h2 {
		font-family: 'Nelson Mixed', 'NelsonMixed';
		font-size: 80px;
		font-weight: 600;
	}
	h1 {
		font-family: 'Nelson Mixed', 'NelsonMixed';
		font-weight: 600;
		font-size: 80px;
		letter-spacing: -0.02em;
		text-transform: uppercase;
		margin: 0;
		display: flex;
	}
</style>
