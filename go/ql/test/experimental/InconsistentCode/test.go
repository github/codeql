package main

func test() {
	var xs []int
	for _ = range xs {
		defer test() // not ok
	}

	for _ = range xs {
		if true {
			defer test() // not ok
		}
	}

	for i := 0; i < 10; i++ {
		defer test()
	}

	for true {
		defer test() // not ok
	}

	for false {
		defer test() // fine but caught
	}
}
