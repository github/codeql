package main

func capturedNil() {
	var value interface{} = 42
	clear := func() { value = nil }
	clear()
	if value == nil {
	}
}

func readOnlyLoop(b bool) {
	var value interface{} = 42
	for b {
		x := value
		if x == nil { // $ Alert
		}
	}
	if value == nil { // $ Alert
	}
}

func nilLoop(b bool) {
	var value interface{}
	for b {
		value = 42
	}
	if value == nil {
	}
}

func unknownLoop(value interface{}, b bool) {
	for b {
		value = 42
	}
	if value == nil {
	}
}

func typedNilLoop(b bool) {
	var pointer *int
	var value interface{} = pointer
	for b {
		x := value
		if x == nil { // $ Alert
		}
	}
	if value == nil { // $ Alert
	}
}

func capturedConcrete() {
	var value interface{} = 42
	set := func() { value = 43 }
	set()
	if value == nil { // Captured writes remain unknown to the local analysis.
	}
}
