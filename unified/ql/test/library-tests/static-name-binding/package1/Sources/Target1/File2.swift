class A {} // name=Target1.A

private import class Target2.B // $ access=Target2.B

private let x: B.C; // $ access=Target2.B access=Target2.B.C
