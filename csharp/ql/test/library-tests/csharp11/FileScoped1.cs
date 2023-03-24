file interface I1 { }

file interface I2 { }

file class C1 : I1 { }

public class C2 { }

public class C3 : I2 { }

file interface IC { }

file class C4<T> { }

file class C5<S> : C4<S> { }

file struct S1 { }

file enum E1 { }

file delegate void D1();

file record R1 { }

file record struct RS1 { }