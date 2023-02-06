protocol P1 {}
protocol P2 {}
protocol P3 {}

var x: P1 & P2 & P3

protocol P4: P1 {}
var y: P1 & P2 & P4

var z: P1 & (P2 & P3)

typealias P23 = P2 & P3
var zz: P1 & P23
