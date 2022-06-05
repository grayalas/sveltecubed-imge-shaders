import adapter from '@sveltejs/adapter-auto';
import glslify from 'rollup-plugin-glslify';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapter(),

		// Override http methods in the Todo forms
		methodOverride: {
			allowed: ['PATCH', 'DELETE']
		},
		vite: {
			noExternal: ['three'],
			// noExternal: ['@sveltejs/gl', 'three'],
			plugins: [glslify()]
		}
	}
};

export default config;
