package main

func testing() {
	variadicDeclaredFunction() // $ isVariadic
}

func variadicDeclaredFunction(x ...int) int {
	a := make([]int, 0, 10) // $ isVariadic
	y := append(x, a...)    // $ isVariadic
	print(x[0], x[1])       // $ isVariadic
	println(x[0], x[1])     // $ isVariadic
	variadicFunctionLiteral := func(z ...int) int { return z[1] }
	return variadicFunctionLiteral(y...)
}
