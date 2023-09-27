import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import inject from '@rollup/plugin-inject'
import Buffer from 'buffer'

export default defineConfig({
	plugins: [sveltekit()],
	build: {
		rollupOptions: {
			plugins: [inject({ Buffer: ['Buffer', 'Buffer'] })],
		},
	}
});
