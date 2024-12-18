package main

func source() string {
	return "untrusted data"
}

func sink(any) {
}

func main() {
	var someMap map[string]string = map[string]string{}
	someMap["someKey"] = source()

	for _, val := range someMap {
		sink(val) // $ hasValueFlow="val"
	}
}

func testLiteral() {
	someMap := map[string]string{"someKey": source()}

	for _, val := range someMap {
		sink(val) // $ hasValueFlow="val"
	}
}
