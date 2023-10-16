// access_token.json.js
import { json } from "@sveltejs/kit";
const client_id = import.meta.env.VITE_SPOTIFY_CLIENT_ID;
const client_secret = import.meta.env.VITE_SPOTIFY_CLIENT_SECRET;
const refresh_token = import.meta.env.VITE_SPOTIFY_REFRESH_TOKEN;
const redirect_uri = "http://nelsonvassalo.vercel.app"
const token_endpoint = `https://accounts.spotify.com/api/token`;

export const GET = async () => {

    const response = await fetch(token_endpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams({
            grant_type: 'refresh_token',
            refresh_token,
            redirect_uri,
            client_id,
            client_secret,
        })
    }).then(res => res.json())

    return json(response)
};