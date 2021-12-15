import * as nj from './nodeJsLib';
import * as es from './esLib';

import {foo as njFoo} from './nodeJsLib';
import {foo as esFoo} from './esLib';

let x1 = nj.foo;
let x2 = es.foo;

let x3 = njFoo;
let x4 = esFoo;
