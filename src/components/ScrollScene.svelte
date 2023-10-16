<script>
	import gsap from 'gsap';
	import { glScale, amplitude, hblur, vblur, kernel, navItems, activeNav } from '../code/js/store';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';
	import { afterUpdate, onMount, tick } from 'svelte';
	import clamp from '../code/js/clamp';
	import lerp from '../code/js/lerp';

	export let headerIn;
	let topLimit;

	onMount(async () => {
		gsap.registerPlugin(ScrollTrigger);
		gsap.ticker.lagSmoothing(0);

		let topLimit = headerIn?.getBoundingClientRect().height;

		const panels = gsap.utils.toArray('.panel');

		gsap.set('.panel video', { scale: 0.6, y: '15%' });

		panels.forEach((panel, i) => {
			const video = panel.querySelector('video');
			const topOffset = video.offsetTop;

			gsap.set(video, { bottom: 'auto', y: 0, top: '+50%' });

			gsap.to(panel.querySelector('article h4, article h1'), {
				y: -window.innerHeight + 50,
				ease: 'cubic.easeOut',
				scrollTrigger: {
					scrub: true,
					trigger: panel,
					// markers: true,
					id: 'article',
					start: `clamp(top ${topLimit})`,
					end: '+=1000'
				}
			});

			gsap.to(panel.querySelector('article'), {
				backgroundColor: 'transparent',
				scrollTrigger: {
					scrub: true,
					trigger: panel,
					start: `top top`,
					end: `+=${panel.offsetHeight / 4}`
				}
			});

			gsap.to(panel.querySelector('article h2, .sidebar'), {
				y: -window.innerHeight + 50,
				ease: 'cubic.easeOut',
				scrollTrigger: {
					scrub: true,
					trigger: panel,
					// markers: true,
					id: 'sidebar',
					start: `clamp(top ${topLimit})`,
					end: '+=1100'
				}
			});

			gsap.to(video, {
				yPercent: -50,
				scale: 1,
				scrollTrigger: {
					scrub: true,
					trigger: panel,
					pin: panel,
					endTrigger: video,
					// markers: true,
					end: `+=${panel.offsetHeight * 1.5}`,
					id: 'panel',
					// pin: video,
					start: `top ${topLimit}`,
					onUpdate: (timeline) => {
						amplitude.set(clamp(lerp(0, 0.02, 0.65 - timeline.progress), 0, 0.02));
						hblur.set(
							clamp(
								lerp(
									0,
									(2.0 / window.innerWidth) * window.devicePixelRatio,
									0.8 - timeline.progress
								),
								0,
								2.0
							)
						);
						vblur.set(
							clamp(
								lerp(
									0,
									(2.0 / window.innerWidth) * window.devicePixelRatio,
									0.8 - timeline.progress
								),
								0,
								2.0
							)
						);

						glScale.set(gsap.getProperty(video, 'scale'));
					}
				}
			});

			// ScrollTrigger.create({
			// 	trigger: video,
			// 	pin: true,
			// 	end: '+=1000'
			// });
		});

		await tick();
		// ScrollTrigger.refresh();

		$navItems?.forEach((nav, i) => {
			console.log({ nav }, document.querySelector(nav.target).getBoundingClientRect().top);
			ScrollTrigger.create({
				trigger: nav.target,
				start: 'top bottom',
				end: 'bottom center',
				// markers: true,
				id: nav.id,
				onEnterBack: () => {
					$activeNav = i;
				},
				onEnter: () => {
					$activeNav = i;
				},
				onLeaveBack: () => {
					if (i == 0) $activeNav = null;
				}
			});
		});

		return () => {
			ScrollTrigger.killAll();
		};
	});
</script>

<section class="container">
	<slot />
</section>
