import {x, y, setX} from './a';
let x1 = x;
let y1 = y;
let s1 = setX;
setX(42);
let x2 = x;
let y2 = y;
let s2 = setX;

export { default as v } from './a';

import * as a from './a';
let z1 = a.x;

import a_default from './a';
let z2 = a_default;

import c_default from './c';
let z3 = c_default;

import { foo } from './d';
let z4 = foo;

import stuff from './e';
let z5 = stuff;

import { setX as setX2 } from './a2';
let z6 = setX2;

import A from './ts';
let z7 = A;

import { foo as amdfoo } from './amd';
let z8 = amdfoo;

import { foo as amdfoo2, toString as amdToString } from './amd2';
let z8 = amdfoo2;
let z9 = amdToString;

import { f, toString } from './f';
let z10 = f;
let z11 = toString;

import * as f2 from './ts2';
let z12 = f2;

import { w } from './a';
let z13 = w;

import { foo_reexported } from './reexport-d';
let z14 = foo_reexported;

import { something } from './reexport-unknown';
let z15 = something;

import { notAlwaysZero } from './a';
let z16 = notAlwaysZero;
