package main

func f1(i int) {
	for j := i - 1; j >= 0; j-- { // OK
	}
}

func f2(i int, s string) {
	for j := i + 1; j < len(s); j-- { // NOT OK
	}
}

func f3(s string) {
	for i, l := 0, len(s); i > l; i++ { // NOT OK
	}
}

func f4(lower int, a []int) {
	for i := lower - 1; i >= 0; i-- { // OK
		a[i] = 0
	}
}

func f5(upper int, a []int) {
	for i := upper + 1; i < len(a); i-- { // NOT OK
		a[i] = 0
	}
}

func f6(upper uint, a []int) {
	for i := upper + 1; i < uint(len(a)); i-- { // NOT OK, but not currently flagged
		a[i] = 0
	}
}

func f7(a []int) {
	for i := uint(len(a)) - 1; i < uint(len(a)); i-- { // OK
		a[i] = 0
	}
}

func main() {}
