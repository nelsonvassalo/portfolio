<script>
	import { onMount } from 'svelte';
	let accessToken;
	import { Buffer } from 'buffer';
	globalThis.Buffer = Buffer;

	onMount(async () => {
		let params = '?';
		let client_id = (params += '6c83955a475f4de48a2178f18c897960');
		let client_secret = (params += 'c63934be56374b6bb35877c2649eb046');
		params += '&response_type=code';
		params += '&redirect_uri=http://localhost:5173/';
		params += '&scope=user-read-recently-played';
		console.log(params);
		let code;

		let req2 = await fetch(`https://accounts.spotify.com/authorize${params}`, {
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded'
			}
		}).then(async (req, res) => {
			console.log({ req, res });
			let query = new URLSearchParams(req.url);
			console.log('🚀 ~ query:', req.url.search);
			code = query.get('code');
			console.log('🚀 code', code);
		});

		// let code =
		// 	'AQB2q6T2HhkOY4PlDdv3eGe4L1HDspX-vEF9a0ziOoHZVvVtuZrmk3moqsvOQXmD9wIvReqOzZyHHzj0jt1K9t4HGNQ_TM5Nl6HgRXZvLODwENvV-2UED_oJl_ddsqvbWfTRBuDeKElpIXPdFx1DyXbQsz3aIxyFi6GGwuMZWYo8GqqGa2eCerVG7uq8HFNkMLPqg1M';
		console.log({ code });

		let queryParams = new URLSearchParams({
			grant_type: 'authorization_code',
			code,
			redirect_uri: 'http://localhost:5173/'
			// client_id,
			// client_secret
		});

		let req = await fetch(`https://accounts.spotify.com/api/token?${queryParams}`, {
			method: 'POST',
			headers: {
				Authorization: `Basic ${new Buffer(client_id + ':' + client_secret).toString('base64')}`,
				'Content-Type': 'application/x-www-form-urlencoded'
			}
		});

		let res = await req.json();
		accessToken = res.access_token;
		console.log('🚀 ~ token:', accessToken);

		let req3 = await fetch('https://api.spotify.com/v1/me/player/recently-played', {
			headers: {
				authorization: `Bearer  ${accessToken}`
			}
		});

		let song = await req3.json();

		console.log({ song });
	});

	// 6c83955a475f4de48a2178f18c897960
</script>

<span />
