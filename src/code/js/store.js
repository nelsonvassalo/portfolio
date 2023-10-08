import { writable } from "svelte/store";

export const scroll = writable(0);
export const glY = writable(0)
export const glScale = writable(0)
export const amplitude = writable(0)
export const hblur = writable(0)
export const vblur = writable(0)
export const kernel = writable(0)
export const activeNav = writable(null)