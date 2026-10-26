package main

import "fmt"

func testing() {
	variadicDeclaredFunction() // $ isVariadic
	nonvariadicDeclaredFunction([]int{})
}

func variadicDeclaredFunction(x ...int) int {
	a := make([]int, 0, 10)   // $ isVariadic
	y := append(x, a...)      // $ isVariadic
	print(x[0], x[1])         // $ isVariadic
	println(x[0], x[1])       // $ isVariadic
	fmt.Fprint(nil, nil, nil) // $ isVariadic
	variadicFunctionLiteral := func(z ...int) int { return z[1] }
	return variadicFunctionLiteral(y...)
}

func nonvariadicDeclaredFunction(x []int) int {
	return 0
}
