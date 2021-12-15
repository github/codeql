import {B} from './safeB';

export let A = 100;

export function getSum() {
  return A + B; // OK: not accessed from top-level
}
