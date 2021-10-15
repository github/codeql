import {A} from './exportCycleA';

export let B = () => A; // OK: `A` is not used during initialization.
