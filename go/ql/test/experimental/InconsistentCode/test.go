package main

func test() {
	var xs []int
	for _ = range xs {
		defer test() // $ Alert[go/examples/deferinloop] // not ok
	}

	for _ = range xs {
		if true {
			defer test() // $ Alert[go/examples/deferinloop] // not ok
		}
	}

	for i := 0; i < 10; i++ {
		defer test() // $ Alert[go/examples/deferinloop]
	}

	for true {
		defer test() // $ Alert[go/examples/deferinloop] // not ok
	}

	for false {
		defer test() // $ Alert[go/examples/deferinloop] // fine but caught
	}
}
