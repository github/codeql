import {B} from './exportCycleB';

export var A = 100;
export {B}; // OK: export binding does not immediately evaluate 'B'
