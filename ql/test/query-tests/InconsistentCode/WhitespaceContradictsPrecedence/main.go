package main

// autoformat-ignore (otherwise gofmt will fix spacing to reflect precedence)

func ok1(x int) int {
	return x + x>>1;
}

func ok2(x int) int {
	return x + x >> 1;
}

func bad(x int) int {
	return x+x >> 1;
}

func ok3(x int) int {
	return x + (x>>1);
}

func ok4(x int, y int, z int) int {
	return x + y + z;
}
	
func ok5(x int, y int, z int) int {
	return x + y+z;
}

func ok6(x int) int {
	return x + x>> 1;
}

func ok7(x int, y int, z int) int {
	return x + y - z;
}

func ok8(x int, y int, z int) int {
	return x + y-z;
}

func ok9(x int, y int, z int) int {
	return x * y*z;
}

func main() {}
