<script>
	import gsap from 'gsap';
	import { glY, glScale, amplitude, hblur, vblur, kernel } from '../code/js/store';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';
	import { onMount, tick } from 'svelte';
	import clamp from '../code/js/clamp';
	import lerp from '../code/js/lerp';

	export let headerIn;
	let topLimit;

	onMount(async () => {
		gsap.registerPlugin(ScrollTrigger);

		await tick();
		console.log({ headerIn });
		let topLimit = headerIn?.getBoundingClientRect().height;

		const panels = gsap.utils.toArray('.panel');

		// Pinning

		gsap.set('.panel video', { scale: 0.6, y: '15%' });

		let videoTl;

		let contentTl;

		panels.forEach((panel, i) => {
			const video = panel.querySelector('video');
			const topOffset = video.offsetTop;
			console.log('🚀 ~ topOffset:', topOffset);
			console.log(panel.querySelector('video'));
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
									(5.0 / window.innerWidth) * window.devicePixelRatio,
									0.8 - timeline.progress
								),
								0,
								5.0
							)
						);

						glY.set(gsap.getProperty(video, 'yPercent') * 0.01);
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

		// gsap.to('.panel', {
		// 	yPercent: -100,
		// 	ease: 'none',
		// 	stagger: 0.5,
		// 	scrollTrigger: {
		// 		trigger: '.container',
		// 		start: 'top top',
		// 		end: '+=300%',
		// 		scrub: true,
		// 		pin: true
		// 	}
		// });

		// panels.forEach((panel) => {
		// 	gsap.to(panel.children[0], {
		// 		y: -window.innerHeight,
		// 		delay: 200,
		// 		scrollTrigger: {
		// 			trigger: panel,
		// 			markers: true,
		// 			pin: panel, // pin the trigger element while active
		// 			start: `snap(top ${topLimit}`, // when the top of the trigger hits the top of the viewport // end after scrolling 500px beyond the start
		// 			// end: `${window.innerHeight}px top`,
		// 			// end: '+=1000',
		// 			// end: 'bottom center',
		// 			scrub: 1, // smooth scrubbing, takes 1 second to "catch up" to the scrollbar
		// 			// pinSpacing: false,
		// 			// anticipatePin: 1,
		// 			onUpdate: (self) => console.log(self.getVelocity())
		// 		}
		// 	});
		// 	if (panel.querySelector('video')) {
		// 		console.log('has video');
		// 		gsap.to(panel.querySelector('video'), {
		// 			scale: 1,
		// 			y: 0,
		// 			// stagger: panel.clientHeight * 0.1,
		// 			duration: 2,
		// 			ease: 'cubic.inOut',
		// 			scrollTrigger: {
		// 				trigger: panel,
		// 				markers: true,
		// 				id: 'video_tl',
		// 				scrub: true
		// 			}
		// 		});
		// 	} else {
		// 		console.log('doesnt', panel);
		// 		ScrollTrigger.create({
		// 			scrub: true,
		// 			trigger: panel,
		// 			markers: true,
		// 			id: 'no_video'
		// 		});
		// 	}

		// 	// ScrollTrigger.create({
		// 	// 	animation: contentTl,
		// 	// 	start: 'top center',
		// 	// 	// trigger: panel,
		// 	// 	id: 'content'
		// 	// 	// scrub: true
		// 	// });
		// });

		return () => {
			ScrollTrigger.killAll();
		};
	});
</script>

<section class="container">
	<slot />
</section>
