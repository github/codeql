package main

func fallthroughToEmptyCase(x int) {
	switch x {
	case 0:
		fallthrough
	case 1:
	default:
		test5(true)
	}
	test5(false)
}

func fallthroughToEmptyDefault(x int) {
	switch x {
	case 0:
		fallthrough
	default:
	}
	test5(false)
}
