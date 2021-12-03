package main

func foo(x int) int {
	return x - x /* NOT OK */ + (x & x) /* NOT OK */
}

func bar(b bool, x float32) float32 {
	if b {
		return (x + x) / 2 // NOT OK
	} else {
		return (x * x) / 2 // OK
	}
}

const c = 1

func baz(b bool) int {
	var d = 1
	if b {
		return d - 1 // OK
	} else {
		return c - 1 // OK
	}
}

func main() {
	if c == '\xA8' || c == '\xA9' {
		foo(42)
	}
}
