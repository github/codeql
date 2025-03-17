import {A} from './A';

export let B: number = 100;

export let Q: number = A; // $ Alert - `A` is not initialized if `A.ts` is imported first.
