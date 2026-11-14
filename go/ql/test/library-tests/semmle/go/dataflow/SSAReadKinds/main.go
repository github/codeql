package main

func expressionReads(value int) int { // $ explicit=2 $ implicit=0 $ flow=2 $ access-path=2
	value += 1
	return value
}

func namedResult() (result int) { // $ explicit=0 $ implicit=1 $ flow=1 $ access-path=1
	result = 42 // $ implicit-return
	return
}

func explicitAndImplicitResult() (result int) { // $ explicit=1 $ implicit=1 $ flow=2 $ access-path=2
	result = 42
	result++ // $ implicit-return
	return
}

func capture(value int) func() int { // $ explicit=1 $ implicit=1 $ flow=1 $ access-path=1
	return func() int {
		return value
	}
}

var condition bool

func conditionalResult() (result int) { // $ explicit=0 $ implicit=1 $ flow=1 $ access-path=1 $ implicit-phi
	if condition {
		result = 1
	} else {
		result = 2
	}
	return
}
