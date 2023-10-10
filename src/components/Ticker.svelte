<script>
	import { onMount } from 'svelte';
	import LastSong from './LastSong.svelte';
	import gsap from 'gsap';

	import moment from 'moment-timezone';

	let todayLIS;
	let todayNYC;
	let date;
	let current;
	let els = [];
	let i = 0;
	let tickerTimer;
	let interval;

	$: {
		els.forEach((el, i) => {
			console.log(el);
			gsap.set(el, { autoAlpha: 0, top: 0, yPercent: 100, position: 'absolute' });
			if (i === 0) {
				gsap.fromTo(
					els[0],
					{
						yPercent: -100,
						position: 'relative'
					},
					{
						yPercent: 0,
						autoAlpha: 1,
						ease: 'power3.in',
						duration: 0.3
					}
				);
			}
		});
	}
	function advanceOne() {
		interval = i == 1 ? 10000 : 4000;
		clearInterval(tickerTimer);
		i++;
		if (i > els.length - 1) {
			i = 0;
		}
		// console.log('🚀 ~ wrapped:', wrapped);
		let prevI = i == 0 ? els.length - 1 : i - 1;
		gsap.to(els[prevI], {
			yPercent: -50,
			position: 'absolute',
			autoAlpha: 0
		});
		gsap.fromTo(
			els[i],
			{
				yPercent: 100
			},
			{
				yPercent: 0,
				autoAlpha: 1,
				position: 'relative',
				duration: 0.4
			}
		);
		reStartTimer();
	}

	function reStartTimer() {
		tickerTimer = setInterval(() => {
			advanceOne();
		}, interval);
	}

	onMount(() => {
		function getToday() {
			date = moment();
			todayLIS = date.tz('Europe/Lisbon').format('HH:mm');
			todayNYC = date.tz('America/New_York').format('h:mm');
		}

		getToday();

		const dateTimer = setInterval(() => {
			date = new Date();
			getToday();
		}, 15000);

		tickerTimer = setInterval(() => {
			advanceOne();
			console.log('🚀 ~ prevI:', prevI);
		}, 5000);

		return () => {
			clearInterval(dateTimer);
			clearInterval(tickerTimer);
		};
	});
</script>

<aside on:click={advanceOne}>
	{#if date}
		<time datetime={todayLIS} bind:this={els[0]}>{todayLIS} GMT</time>
		<time datetime={date.tz('America/New_York').format('HH:mm A')} bind:this={els[1]}
			>{todayNYC} EST</time
		>
	{/if}
	<!-- <LastSong bind:div={els[2]} /> -->
</aside>

<style lang="scss">
	aside {
		display: flex;
		flex-direction: column;
		align-items: end;
		justify-items: center;
		width: 22rem;
		position: absolute;
		right: 1rem;
		cursor: url('/images/cursor.png'), auto;
		:global(> *) {
			padding: 0.65em 0 0.6em;
		}
		// height: 52px;
		overflow: hidden;
	}
</style>
