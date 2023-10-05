import { json } from "@sveltejs/kit";

const now_playing_endpoint = `https://api.spotify.com/v1/me/player/recently-played`;

export async function GET() {
    const { access_token } = await fetch('http://localhost:5173/song/access').then(res => res.json())
    console.log("🚀 ~ access_token:", access_token)

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