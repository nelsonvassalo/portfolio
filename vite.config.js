import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import glsl from 'vite-plugin-glsl';
import inject from '@rollup/plugin-inject'
import Buffer from 'buffer'

export default defineConfig({
	plugins: [sveltekit(), glsl()],
	build: {
		rollupOptions: {
			plugins: [inject({ Buffer: ['Buffer', 'Buffer'] })],
		},
	}
});
