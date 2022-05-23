package main

import "regexp"

func f1(i int, a []int) int {
	if i <= len(a) { // NOT OK
		return a[i]
	}
	return -1
}

func f2(i int, a []int) int {
	if i < len(a) { // OK
		return a[i]
	}
	return -1
}

func f3(i int, a []int) int {
	if i <= len(a) { // OK
		if i != len(a) {
			return a[i]
		}
	}
	return -1
}

func f4(i int, a []int) int {
	if len(a) > 0 { // NOT OK
		return a[1]
	}
	return -1
}

func f5(i int, a []int) int {
	if len(a) > 1 { // OK
		return a[1]
	}
	return -1
}

func f6(i int, a []int) int {
	if len(a) > 0 { // OK
		if len(a) > 1 {
			return a[0]
		}
	}
	return -1
}

func f7(i int, a map[int]int) int {
	if i <= len(a) { // OK
		return a[i]
	}
	return -1
}

func f8(s string) string {
	r := regexp.MustCompile("(.*?),(.*?)")
	m := r.FindStringSubmatch(s)
	if len(m) > 0 { // OK
		return m[1]
	}
	return ""
}

func f9(xs []int) int {
	if len(xs) > 1 {
		if len(xs) != 3 || f5(0, xs) == -1 {
			return 0
		}
		return xs[2]
	}
	return -1
}

type intintmap map[int]int

func f10(i int, a intintmap) int {
	if i <= len(a) { // OK
		return a[i]
	}
	return -1
}

func main() {}
