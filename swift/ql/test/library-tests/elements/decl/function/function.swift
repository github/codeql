
func func1() {}

class Class1 {
	func func2() {}

	class Class2 {
		func func3() {}
	}
}

protocol Protocol1 {
	func func4()
}

class Class3: Class1, Protocol1 {
	func func4() {}
}

extension Class3 {
	func func5() {}
}

struct Struct1 {
	func func6() {}
}

enum Enum1 {
	case case1
	case case2
	func func7() {}
}

extension Class1
{
	class Class4 {
		func func8() {}
	}
}
