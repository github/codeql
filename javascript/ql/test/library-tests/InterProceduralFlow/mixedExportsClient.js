import defaultValue from './mixedExports';
import { x } from './mixedExports';
import * as ns from './mixedExports';

let sink1 = defaultValue.x; // OK
let sink2 = x; // NOT OK
let sink3 = ns.x; // NOT OK
