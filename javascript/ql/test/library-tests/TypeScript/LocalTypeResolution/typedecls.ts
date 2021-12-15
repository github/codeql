import {X, Y as Y_alias} from './lib';

var x: X;
var y: Y_alias;

class C {}
var c: C

interface I {}
var i: I

class Generic<S> {
  method(): S
}

function generic<T>(x: T): T {
  var t: T
}

var fn: <G>(x: G) => G;

var qualified: X.foo;

enum E {a, b}
var e: E

type F = X;
var f: F
