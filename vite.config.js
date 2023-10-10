import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import glsl from 'vite-plugin-glsl';
import inject from '@rollup/plugin-inject'
import Buffer from 'buffer'
import { imagetools } from 'vite-imagetools';

export default defineConfig({
	plugins: [sveltekit(), glsl(), imagetools()],
	build: {
		rollupOptions: {
			plugins: [inject({ Buffer: ['Buffer', 'Buffer'] })],
		},
	}
});
