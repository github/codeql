package main

func testing() {
	variadicDeclaredFunction()
}

func variadicDeclaredFunction(x ...int) int { // $ isVariadic
	a := make([]int, 0, 10)
	y := append(x, a...)
	print(x[0], x[1])
	println(x[0], x[1])
	variadicFunctionLiteral := func(z ...int) int { return z[1] } // $ isVariadic
	return variadicFunctionLiteral(y...)
}
