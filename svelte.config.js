import adapter from '@sveltejs/adapter-auto';
import preprocess from 'svelte-preprocess';
// import { imagePreprocessor } from 'svimg';


/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: [
		// imagePreprocessor({
		// 	inputDir: 'static',
		// 	outputDir: 'static/g',
		// 	webp: true,
		// 	avif: true
		// }),
		preprocess({
			scss: {
				includePaths: ["./src", "./src/code/scss"],
				sourceMap: true
			},
		})

	],
	kit: {
		// adapter-auto only supports some environments, see https://kit.svelte.dev/docs/adapter-auto for a list.
		// If your environment is not supported or you settled on a specific environment, switch out the adapter.
		// See https://kit.svelte.dev/docs/adapters for more information about adapters.
		adapter: adapter()
	}
};

export default config;
