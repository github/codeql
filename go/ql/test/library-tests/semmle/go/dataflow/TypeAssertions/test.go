package main

func src() interface{} {
	return "hi"
}

func sink(p interface{}) {}

func test() (bool, *string) {
	ptr := src()
	sink(ptr) // $ dataflow=ptr
	cast := ptr.(*string)
	sink(cast) // $ dataflow=cast
	cast2, ok := ptr.(*string)
	if !ok {
		return true, nil
	}
	sink(cast2) // $ dataflow=cast2
	var cast3, ok2 = ptr.(*string)
	if !ok2 {
		return true, nil
	}
	sink(cast3) // $ dataflow=cast3
	cast2, ok = ptr.(*string)
	if !ok {
		return true, nil
	}
	sink(cast2) // $ dataflow=cast2
	return true, nil
}
