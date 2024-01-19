import { VITE_SPOTIFY_CLIENT_ID, VITE_SPOTIFY_CLIENT_SECRET, VITE_SPOTIFY_REFRESH_TOKEN } from "$env/static/private";
import { json } from "@sveltejs/kit";

const now_playing_endpoint = `https://api.spotify.com/v1/me/player/recently-played`;

export async function GET() {
    const { access_token } = await fetch('https://www.nelsonvassalo.com/song/access').catch(err => console.log({ err })).then(res => res.json())
    const res = await fetch(`${now_playing_endpoint}?limit=1`, {
        headers: {
            Authorization: `Bearer ${access_token}`
        }
    })


    const songs = await res.json();
    // const isPlaying = song.is_playing;
    // const title = song.item.name;
    // const artist = song.item.artists.map((_artist) => _artist.name).join(', ');
    // const album = song.item.album.name;
    // const albumImageUrl = song.item.album.images[0].url;
    // const songUrl = song.item.external_urls.spotify;

    return json(songs.items[0])

}