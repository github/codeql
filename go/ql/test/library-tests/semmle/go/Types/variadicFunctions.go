package main

import "fmt"

func testing() {
	variadicDeclaredFunction()
	nonvariadicDeclaredFunction([]int{})
}

func variadicDeclaredFunction(x ...int) int {
	a := make([]int, 0, 10)
	y := append(x, a...)
	print(x[0], x[1])
	println(x[0], x[1])
	fmt.Fprint(nil, nil, nil)
	variadicFunctionLiteral := func(z ...int) int { return z[1] } // $ isVariadic
	return variadicFunctionLiteral(y...)
} // $ isVariadic

func nonvariadicDeclaredFunction(x []int) int {
	return 0
}
