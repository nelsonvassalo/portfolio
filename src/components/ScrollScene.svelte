<script>
	import gsap from 'gsap';
	import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';
	import { onMount } from 'svelte';

	export let header;

	onMount(() => {
		gsap.registerPlugin(ScrollTrigger);
		console.log({ header });

		const topLimit = header?.getBoundingClientRect().height;

		const panels = gsap.utils.toArray('.panel');

		// Pinning

		gsap.set('.panel video', { scale: 0.6, y: '+=25%' });

		let videoTl;

		let contentTl;

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
			gsap.to(panel.children[0], {
				y: -window.innerHeight,
				delay: 200,
				scrollTrigger: {
					trigger: panel,
					markers: true,
					pin: panel, // pin the trigger element while active
					start: `top ${topLimit}`, // when the top of the trigger hits the top of the viewport // end after scrolling 500px beyond the start
					// end: `${window.innerHeight}px top`,
					end: '+=1000',
					// end: 'bottom center',
					scrub: 1, // smooth scrubbing, takes 1 second to "catch up" to the scrollbar
					// pinSpacing: false,
					// anticipatePin: 1,
					onUpdate: (self) => console.log(self.getVelocity())
				}
			});

			gsap.to(panel.querySelector('video'), {
				scale: 1,
				y: 0,
				// stagger: panel.clientHeight * 0.1,
				duration: 2,
				ease: 'cubic.inOut',
				scrollTrigger: {
					trigger: panel,
					markers: true,
					id: 'video_tl',
					scrub: true
				}
			});

			// ScrollTrigger.create({
			// 	animation: contentTl,
			// 	start: 'top center',
			// 	// trigger: panel,
			// 	id: 'content'
			// 	// scrub: true
			// });
		});

		return () => {
			ScrollTrigger.killAll();
		};
	});
</script>

<section class="container">
	<slot />
</section>
