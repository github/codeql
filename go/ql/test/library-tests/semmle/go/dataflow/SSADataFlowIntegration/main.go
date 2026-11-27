package main

func source() string { return "tainted" }
func sink(string)    {}
func isBad(string) bool {
	return false
}

func readMerge(b, c bool) {
	value := source()
	if b {
		sink(value) // $ hasValueFlow="value"
	} else {
		sink(value) // $ hasValueFlow="value"
	}
	if c {
		sink(value) // $ hasValueFlow="value"
	} else {
		sink(value) // $ hasValueFlow="value"
	}
}

func writeMerge(b, c bool) {
	value := "safe"
	if b {
		value = source()
	}
	if c {
		sink(value) // $ hasValueFlow="value"
	} else {
		sink(value) // $ hasValueFlow="value"
	}
	value = "safe"
	sink(value)
}

func loop(b bool) {
	value := source()
	for b {
		sink(value) // $ hasValueFlow="value"
		value = "safe"
	}
	sink(value) // $ hasValueFlow="value"
}

func namedResult() (value string) {
	value = source()
	return
}

func implicitRead() {
	sink(namedResult()) // $ hasValueFlow="call to namedResult"
}

func capturedWrite() {
	value := "safe"
	set := func() {
		value = source()
	}
	set()
	sink(value) // $ hasValueFlow="value"
}

func capturedRead() {
	value := source()
	read := func() {
		sink(value) // $ hasValueFlow="value"
	}
	sink(value) // $ hasValueFlow="value"
	read()
}

func uncertainUpdate(b bool) {
	value := source()
	update := func() {
		if b {
			value = "safe"
		}
	}
	update()
	sink(value) // $ hasValueFlow="value"
}

func postUpdate(b, c bool) {
	value := []string{"safe"}
	update := func(values []string) {
		values[0] = source()
	}
	update(value)
	if b {
		sink(value[0]) // $ hasValueFlow="index expression"
	}
	if c {
		sink(value[0]) // $ hasValueFlow="index expression"
	} else {
		sink(value[0]) // $ hasValueFlow="index expression"
	}
}

func guardedMerge(b bool) {
	value := source()
	if isBad(value) {
		return
	}
	if b {
		sink(value)
	} else {
		sink(value)
	}
}

type record struct {
	value string
}

func guardedFieldMerge(b bool) {
	item := record{source()}
	if isBad(item.value) {
		return
	}
	if b {
		sink(item.value)
	} else {
		sink(item.value)
	}
}
