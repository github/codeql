
class A {
}

typealias A_alias = A

typealias A_optional_alias = A?

class B1 : A {
}

class B2 : A_alias {
}

typealias B1_alias = B1

typealias B2_alias = B2

// ---

protocol P {
}

typealias P_alias = P

class C1 : P {
}

class C2 : P_alias {
}

// ---

class Outer {
	class Inner {
		typealias InnerAlias = A
	}
}

// ---

protocol P1 {
}

protocol P2 {
}

typealias P1P2 = P1 & P2

// ---

class Box<T> {
}

// ---

class D1 {
}

protocol P3 {
}

extension D1 : P3 {
}

// ---

class D2 {
}

typealias D2_alias = D2

protocol P4 {
}

typealias P4_alias = P4

extension D2 : P4_alias {
}

// ---

func test() {
	var i : Int
	var j : Any?
	var a : A
	var a_alias : A_alias
	var a_optional_alias : A_optional_alias
	var b1 : B1
	var b2 : B2
	var b1_alias : B1_alias
	var b2_alias : B2_alias
	var p : P
	var p_alias : P_alias
	var c1 : C1
	var c2 : C2
	var o : Outer
	var oi : Outer.Inner
	var oia : Outer.Inner.InnerAlias
	var p1p2 : P1P2
	var boxInt : Box<A>
	var d1: D1
	var d2: D2
}
