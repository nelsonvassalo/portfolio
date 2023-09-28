<script>
	import gsap from 'gsap';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';
	import { onMount } from 'svelte';

	onMount(() => {
		gsap.registerPlugin(ScrollTrigger);

		const topLimit = header?.getBoundingClientRect().height;

		const panels = gsap.utils.toArray('.panel');

		// Pinning
		panels.forEach((panel) => {
			ScrollTrigger.create({
				snap: {
					snapTo: 0.25,
					duration: 0.2
				},
				trigger: panel,
				markers: true,
				pin: true, // pin the trigger element while active
				start: `top center`, // when the top of the trigger hits the top of the viewport // end after scrolling 500px beyond the start
				// end: `${window.innerHeight}px bottom`,
				end: () => `+=${panel.offsetHeight}`,
				// end: 'bottom center',
				scrub: true, // smooth scrubbing, takes 1 second to "catch up" to the scrollbar
				pinSpacing: false,
				// anticipatePin: 1,
				onUpdate: (self) => console.log(self.getVelocity())
				// snap: {
				// 	// snapTo: 'labels', // snap to the closest label in the timeline
				// 	duration: { min: 0.2, max: 4 }, // the snap animation should be at least 0.2 seconds, but no more than 3 seconds (determined by velocity)
				// 	delay: 0.1, // wait 0.2 seconds from the last scroll event before doing the snapping
				// 	ease: 'power1.inOut' // the ease of the snap animation ("power3" by default)
				// }
			});
		});

		const tl = gsap.timeline({
			paused: true
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

		panels.forEach((panel) => {
			console.log(panel.clientHeight);
			tl.fromTo(
				panel.querySelector('video'),

				{
					scaleX: 0.6,
					scaleY: 0.6,
					y: '-50%'
				},
				{
					scaleX: 1,
					scaleY: 1,
					y: 0,
					// stagger: panel.clientHeight * 0.1,
					duration: 2,
					ease: 'cubic.inOut',
					scrollTrigger: {
						markers: { startColor: 'black', endColor: 'blue' },
						trigger: panel,
						scrub: true,
						start: 'top 40%'
						// end: 'clamp(+=500'
					}
					// y: '-50%',
					// duration: 0.2
				}
			);
		});

		tl.to('main', {
			backdropFilter: 'blur(0px)',
			background: 'transparent'
		});

		return () => {
			ScrollTrigger.killAll();
		};
	});
</script>

<section class="container">
	<slot />
</section>
