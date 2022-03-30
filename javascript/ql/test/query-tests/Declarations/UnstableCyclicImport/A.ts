import {B} from './B';

export let A: number = B+1; // NOT OK: `B` is not initialized if `B.ts` is imported first.
