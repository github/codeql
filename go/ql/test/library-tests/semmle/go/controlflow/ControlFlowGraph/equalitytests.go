package main

type structWithoutInterface struct {
	field int
}

type structWithInterface struct {
	field error
}

func equalityTests(i1 int, i2 int, e1 error, e2 error, s1 structWithoutInterface, s2 structWithoutInterface, s3 structWithInterface, s4 structWithInterface, a1 [3]error, a2 [3]error, a3 [3]int, a4 [3]int) bool {
	return i1 == i2 && e1 == e2 && s1 == s2 && s3 == s4 && a1 == a2 && a3 == a4
}
