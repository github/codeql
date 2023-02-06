package main

import "fmt"

func greet(who string) {
	fmt.Printf("Hello %s!", who)
}

func main() {
	world := "world"
	greet(world)
	greet2()
}
