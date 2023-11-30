package main

func source() interface{} {
	return "hi"
}

func sink(p interface{}) {}

func test() (bool, *string) {
	ptr := source()
	sink(ptr) // $ hasValueFlow="ptr"
	cast := ptr.(*string)
	sink(cast) // $ hasValueFlow="cast"
	cast2, ok := ptr.(*string)
	if !ok {
		return true, nil
	}
	sink(cast2) // $ hasValueFlow="cast2"
	var cast3, ok2 = ptr.(*string)
	if !ok2 {
		return true, nil
	}
	sink(cast3) // $ hasValueFlow="cast3"
	cast2, ok = ptr.(*string)
	if !ok {
		return true, nil
	}
	sink(cast2) // $ hasValueFlow="cast2"
	return true, nil
}
