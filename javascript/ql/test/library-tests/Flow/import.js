import { default as mixin } from './reexport-mixins.js';
let m = mixin;

import { f } from './n';
let myf = f;

import { someStuff } from './o';
let someVar = someStuff;

import { h } from './namespace-reexport';
let h1 = h;
let hf = h.f;
