import {TypeB, valueB} from './typeB';

export interface TypeA {
  field: TypeB
}

export let valueA = valueB; // OK: these imports are not cyclic at runtime
