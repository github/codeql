import A = require('something')
import B from './somewhere';
import {C, A as D} from './somewhere';
import * as E from './somewhere';

interface A {} // imported A cannot be a type
interface E {} // imported E cannot be a type

namespace F {
  export interface T {}
}

namespace G {
  export var instantiate;
  export interface T {}
}

declare namespace H {
  export interface T {}
}

declare namespace I {
  export var instantiate;
  export interface T {}
}

var at: A.T;
var abt: A.B.T;
var bt: B.T
var ct: C.T
var dt: D.T
var et: E.T
var ft: F.T
var gt: G.T
var ht: H.T
var it: I.T;

var a: A
var e: E
