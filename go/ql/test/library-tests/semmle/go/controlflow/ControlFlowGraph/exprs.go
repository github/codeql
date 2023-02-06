package main

type point struct{ x, y int }

func test() point {
	var i, j = 0, 1 + (2 + 3)
	var k = i + 2*j
	s := "k = " + string(k)
	fn := func(a, b int, z float64) bool { return a*b < int(z) }
	struct1 := struct{ x, y int }{}
	struct2 := struct {
		x int
		y bool
	}{k, fn(i, j, 3/14)}
	struct3 := struct{ x, y int }{y: struct1.x, x: struct2.x}
	arr1 := [1]int{struct3.x}
	arr2 := [...]int{struct3.x, 2: arr1[0]}
	slc := []string{s, s}
	mp := map[string]int{slc[0]: arr2[1]}
	slc2 := slc[1:2:3]
	slc3 := slc2[:2:3]
	slc4 := slc3[0:2]
	slc5 := slc4[0:]
	slc6 := slc5[:2]
	return point{mp[s], len(slc6[0])}
}

func test2(arg interface{}) int {
	return arg.(point).x
}

func test3(arg interface{}) int {
	if p, ok := arg.(point); ok {
		return p.x
	}
	return -1
}

func test4(arg interface{}) int {
	var p point
	var ok bool
	p, ok = arg.(point)
	if ok {
		return p.x
	}
	return -1
}

func sum(xs []int) (res int) {
	for i := 0; i < len(xs); i++ {
		res += xs[i]
	}
	return
}

func sum2(xs ...int) int {
	return sum(xs)
}

func ints() []int {
	return []int{1, 2, 3}
}

var s = sum(ints())
var s2 = sum2(ints()...)

func add(x, y int) int {
	return x + y
}

func gen() (int, int) {
	return 1, 2
}

var s3 = add(gen())

func short(x, y, z bool) bool {
	return !(x && y) || z
}

func recvOrPanic(ch chan int) int {
	val, ok := <-ch
	if ok {
		return val
	}
	panic("No value")
}

const one = 1

var a = []int{0 + one: 2}

func short2(x, y, z bool) bool {
	return (x && y) || z
}
