<script>
	import { json } from '@sveltejs/kit';
	import { afterUpdate, onMount, tick } from 'svelte';
	import A from './AnimatedWord.svelte';
	let song;
	let width;
	let inner;
	let expanded;
	export let div;

	async function getNowPlaying() {
		song = await fetch('/song/last_played').then((res) => {
			return res.json();
		});
	}

	onMount(async () => {
		getNowPlaying();

		const interval = setInterval(() => {
			getNowPlaying();
		}, 30000);

		return () => {
			clearInterval(interval);
		};
	});

	$: {
		if (width > 352 && !expanded) {
			expanded = true;
		}
	}
</script>

<div bind:this={div}>
	<svg width="13" height="15" viewBox="0 0 13 15" fill="none" xmlns="http://www.w3.org/2000/svg">
		<path
			d="M0.557244 9.16946C0.402062 9.16946 0.270392 9.11202 0.162235 8.99713C0.0540785 8.88224 0 8.74581 0 8.58784V6.41216C0 6.25419 0.0540785 6.11776 0.162235 6.00287C0.270392 5.8832 0.402062 5.82336 0.557244 5.82336C0.72183 5.82336 0.858202 5.8832 0.966359 6.00287C1.07922 6.11776 1.13565 6.25419 1.13565 6.41216V8.58784C1.13565 8.74581 1.07922 8.88224 0.966359 8.99713C0.858202 9.11202 0.72183 9.16946 0.557244 9.16946ZM2.93435 12.1063C2.77446 12.1063 2.64044 12.0512 2.53228 11.9411C2.42413 11.8262 2.37005 11.6874 2.37005 11.5247V3.47535C2.37005 3.31259 2.42413 3.17377 2.53228 3.05888C2.64044 2.94399 2.77446 2.88655 2.93435 2.88655C3.09893 2.88655 3.2353 2.94399 3.34346 3.05888C3.45162 3.17377 3.5057 3.31259 3.5057 3.47535V11.5247C3.5057 11.6874 3.45162 11.8262 3.34346 11.9411C3.2353 12.0512 3.09893 12.1063 2.93435 12.1063ZM5.3044 15C5.14451 15 5.01049 14.9426 4.90233 14.8277C4.79888 14.7176 4.74715 14.5811 4.74715 14.4184V0.581618C4.74715 0.418861 4.79888 0.282432 4.90233 0.172331C5.01049 0.0574438 5.14451 0 5.3044 0C5.46898 0 5.60535 0.0574438 5.71351 0.172331C5.82637 0.282432 5.8828 0.418861 5.8828 0.581618V14.4184C5.8828 14.5811 5.82637 14.7176 5.71351 14.8277C5.60535 14.9426 5.46898 15 5.3044 15ZM7.6815 11.2303C7.52161 11.2303 7.38759 11.1752 7.27944 11.0651C7.17128 10.955 7.1172 10.8186 7.1172 10.6558V4.34418C7.1172 4.18143 7.17128 4.045 7.27944 3.9349C7.38759 3.82001 7.52161 3.76257 7.6815 3.76257C7.84138 3.76257 7.9754 3.82001 8.08356 3.9349C8.19642 4.045 8.25285 4.18143 8.25285 4.34418V10.6558C8.25285 10.8186 8.19642 10.955 8.08356 11.0651C7.9754 11.1752 7.84138 11.2303 7.6815 11.2303ZM10.0586 13.4059C9.89401 13.4059 9.75764 13.3485 9.64948 13.2336C9.54133 13.1235 9.48725 12.9895 9.48725 12.8315V2.1685C9.48725 2.01053 9.54133 1.8741 9.64948 1.75921C9.75764 1.64433 9.89401 1.58688 10.0586 1.58688C10.2185 1.58688 10.3525 1.64433 10.4607 1.75921C10.5688 1.8741 10.6229 2.01053 10.6229 2.1685V12.8315C10.6229 12.9895 10.5688 13.1235 10.4607 13.2336C10.3525 13.3485 10.2185 13.4059 10.0586 13.4059ZM12.4286 9.78698C12.2641 9.78698 12.1277 9.73193 12.0195 9.62183C11.9161 9.50694 11.8644 9.37051 11.8644 9.21254V5.78746C11.8644 5.62949 11.9161 5.49306 12.0195 5.37817C12.1277 5.26328 12.2641 5.20584 12.4286 5.20584C12.5885 5.20584 12.7226 5.26328 12.8307 5.37817C12.9436 5.49306 13 5.62949 13 5.78746V9.21254C13 9.37051 12.9436 9.50694 12.8307 9.62183C12.7226 9.73193 12.5885 9.78698 12.4286 9.78698Z"
			fill="black"
		/>
	</svg>

	{#if song}
		<a
			href={song.track.external_urls.spotify}
			target="_blank"
			class:expanded
			style={`--width: -${width}px`}
		>
			<span bind:this={inner} bind:clientWidth={width}>
				{song.track?.name},
				{#each song.track?.artists as artist, i}
					{#if i < 2}
						{artist.name}{#if song.track.artists.length > 1 && i == 0},&nbsp; {/if}
					{/if}
				{/each}
				{#if song.track.artists.length > 2}
					and others
				{/if}
				<svg
					width="11"
					height="11"
					viewBox="0 0 11 11"
					fill="none"
					xmlns="http://www.w3.org/2000/svg"
				>
					<path
						d="M9.47534 8.52468L9.4415 2.43223L9.40765 2.39838L1.53822 10.2678L0.861282 9.59087L8.73071 1.72144L8.69686 1.68759L2.6044 1.65375L3.53519 0.722953L10.3384 0.790647L10.4061 7.59389L9.47534 8.52468Z"
						fill="black"
					/>
				</svg>
			</span>
			{#if expanded}
				<span>
					{song.track?.name},
					{#each song.track?.artists as artist, i}
						{#if i < 2}
							{artist.name}{#if song.track.artists.length > 1 && i == 0},&nbsp; {/if}
						{/if}
					{/each}
					{#if song.track.artists.length > 2}
						and others
					{/if}
					<svg
						width="11"
						height="11"
						viewBox="0 0 11 11"
						fill="none"
						xmlns="http://www.w3.org/2000/svg"
					>
						<path
							d="M9.47534 8.52468L9.4415 2.43223L9.40765 2.39838L1.53822 10.2678L0.861282 9.59087L8.73071 1.72144L8.69686 1.68759L2.6044 1.65375L3.53519 0.722953L10.3384 0.790647L10.4061 7.59389L9.47534 8.52468Z"
							fill="black"
						/>
					</svg>
				</span>
			{/if}
		</a>
	{/if}
</div>

<style lang="scss">
	@keyframes ticker {
		from {
			transform: translateX(0);
		}
		to {
			transform: translateX(var(--width));
		}
	}
	div {
		display: flex;
		width: 100%;
		user-select: none;

		align-items: center;
		justify-content: flex-end;

		> svg {
			margin-right: 0.5em;
			// width: 13px;
			flex-shrink: 0;
		}
		a {
			text-decoration: none;
			color: #000;
			font-weight: 600;
			letter-spacing: -0.03em;
			overflow: hidden;
			// text-overflow: ellipsis;
			height: 1lh;
			white-space: nowrap;
			span {
				display: inline-block;
			}
			&.expanded {
				display: flex;
				position: relative;
				&:before,
				&:after {
					content: '';
					width: 40px;
					height: 100%;
					background: linear-gradient(to right, white, transparent);
					position: absolute;
					top: 0;
					z-index: 1;
				}
				&:before {
					left: 0;
				}
				&:after {
					transform: rotate(180deg);
					right: 0;
				}
				span {
					animation: 13s ticker linear infinite;
					padding-right: 1rem;
				}
			}
			svg {
				width: 10px;
			}
		}
	}
</style>
