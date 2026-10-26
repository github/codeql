import * as nj from './nodeJsLib';
import * as es from './esLib';

import {foo as njFoo} from './nodeJsLib';
import {source as esFoo} from './esLib';

let sink1 = nj.foo;
let sink2 = es.source;

let sink3 = njFoo;
let sink4 = esFoo;
