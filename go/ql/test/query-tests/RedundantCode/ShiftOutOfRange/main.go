package main

func bad1(x uint8) uint8 {
	return x << 8 // NOT OK
}

func bad2(y int32) int32 {
	return y >> 33 // NOT OK
}

func bad3(z int) int {
	return z << 64 // NOT OK
}

func good1(x uint8) uint8 {
	return x << 7 // OK
}

func good2(y int32) int32 {
	return y >> 16 // OK
}

func good3(z int) int {
	return z << 32 // OK
}

func main() {
}
