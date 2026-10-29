package main

func test12() int {
	_ = test7(0)
	var _ = test7(1)
	return 2
}

func test13() int {
	_, x := gen()
	var _, y = gen()
	return x + y
}

func test14(ch chan int) int {
	select {
	case _ = <-ch:
	case x, _ := <-ch:
		return x
	case _, y := <-ch:
		if y {
			break
		}
		return 0
	case _, _ = <-ch:
	}
	return 1
}

func test13b() int {
	x, _ := gen()
	var y, _ = gen()
	return x + y
}
