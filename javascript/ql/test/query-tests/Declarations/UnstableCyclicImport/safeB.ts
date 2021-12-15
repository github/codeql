import {A} from './safeA';

export let B = 20;

export function getProduct() {
  return A * B; // OK: not accessed from top-level
}
