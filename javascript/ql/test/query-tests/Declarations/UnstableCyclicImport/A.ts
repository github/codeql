import {B} from './B';

export let A: number = B+1; // $ Alert - `B` is not initialized if `B.ts` is imported first.
