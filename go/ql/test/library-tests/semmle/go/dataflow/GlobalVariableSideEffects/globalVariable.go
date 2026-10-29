package main

var globalScalar any
var globalArray [1]any
var globalSlice []any
var globalMap1 map[any]any
var globalMap2 map[any]any

func source(n int) any { return n }

func sink(x any) {}

func main() {
	test1()
	test2()
	sink(globalScalar)   // $ hasValueFlow="globalScalar (from source 0)" MISSING: hasValueFlow="globalScalar (from source 10)"
	sink(globalArray[0]) // $ hasValueFlow="index expression (from source 1)" hasValueFlow="index expression (from source 11)"
	sink(globalSlice[0]) // $ hasValueFlow="index expression (from source 2)" hasValueFlow="index expression (from source 12)"
	for val := range globalMap1 {
		sink(val) // $ hasValueFlow="val (from source 3)" hasValueFlow="val (from source 13)"
	}
	for _, val := range globalMap2 {
		sink(val) // $ hasValueFlow="val (from source 4)" hasValueFlow="val (from source 14)"
	}
}

func test1() {
	globalScalar = source(0)
	globalArray[0] = source(1)
	globalSlice[0] = source(2)
	globalMap1[source(3)] = nil
	globalMap2[""] = source(4)
}

func test2() {
	taintScalar(&globalScalar)
	taintArray(globalArray)
	taintSlice(globalSlice)
	taintMapKey(globalMap1)
	taintMapValue(globalMap2)
}

func taintScalar(x *any) {
	*x = source(10)
}

func taintArray(x [1]any) {
	x[0] = source(11)
}

func taintSlice(x []any) {
	x[0] = source(12)
}

func taintMapKey(x map[any]any) {
	x[source(13)] = ""
}

func taintMapValue(x map[any]any) {
	x[""] = source(14)
}
