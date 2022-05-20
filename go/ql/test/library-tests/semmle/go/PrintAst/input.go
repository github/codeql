package main

import "fmt"

// NOTE: after auto-formatting this file, make sure to put back the empty statement on line 15 below

// autoformat-ignore (in line with the NOTE above)

// simple statements and for loops
func test5(b bool) {
	{
		if !b {
			goto outer
		}
		{
		}
		; // empty statement
	}

	fmt.Println("Hi")

outer:
	for true {
		for i := 0; i < 10; i++ {
			if j := i - 1; j > 5 {
				break outer
			} else if i < 3 {
				break
			} else if i != 9 {
				continue outer
			} else if i >= 4 {
				goto outer
			} else {
				continue
			}
		}
	}

	k := 9
	for ; ; k++ {
		goto outer
	}
}

// select
func test6(ch1 chan int, ch2 chan float32) {
	var a [1]float32
	var w bool

	select {
	case <-ch1:
		fmt.Println("Heard from ch1")
	case a[0], w = <-ch2:
		fmt.Println(a)
		fmt.Println(w)
	default:
		fmt.Println()
	case ch1 <- 42:
	}

	select {}
}

// defer
func test7(x int) int {
	if x > 0 {
		defer func() { fmt.Println(x) }()
	} else {
		defer func() { fmt.Println(-x) }()
	}
	return 42
}

// expression switch
func test8(x int) {
	switch x {
	}

	switch y := x; y - 19 {
	default:
		test5(false)
	}

	switch x {
	case 1:
	case 2, 3:
		test5(true)
	}

	switch x {
	case 1:
		test5(false)
		fallthrough
	case 2 - 5:
		test5(true)
	}

	switch x {
	default:
	case 2:
		test5(true)
	}

	switch {
	default:
		break
	case true:
	}
}

// type switch
func test9(x interface{}) {
	switch y := x.(type) {
	case error, string:
		fmt.Println(y)
	case float32:
		test5(true)
		test5(false)
	}

	switch y := x; y.(type) {
	default:
		test5(false)
	}
}

// go
func test10(f func()) {
	go f()
}

// more loops
func test11(xs []int) {
	for x := range xs {
		if x > 5 {
			continue
		}
		fmt.Print(x)
	}

	for i, v := range xs {
		fmt.Print(i, v)
	}

	for range xs {
	}
}
