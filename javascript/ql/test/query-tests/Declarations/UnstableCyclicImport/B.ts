import {A} from './A';

export let B: number = 100;

export let Q: number = A; // NOT OK: `A` is not initialized if `A.ts` is imported first.
