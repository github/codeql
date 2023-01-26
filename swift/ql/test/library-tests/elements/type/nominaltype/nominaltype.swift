
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

protocol P {
}

typealias P_alias = P

class C1 : P {
}

class C2 : P_alias {
}

typealias C1_alias = C1

typealias C2_alias = C2

func test() {
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
	var c1_alias : C1_alias
	var c2_alias : C2_alias
}
