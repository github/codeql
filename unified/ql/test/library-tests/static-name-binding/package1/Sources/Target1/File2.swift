class A {} // name=Target1.A

private import class Target2.B // $ access=Target2.B // name=LocalB

// Note: currently the local name 'B' introduced by the scoped import is also resolved as a target
private let x: B.C; // $ access=Target2.B access=Target2.B.C access=LocalB
