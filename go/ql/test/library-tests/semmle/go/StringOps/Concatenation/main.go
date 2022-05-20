package main

import "fmt"

func test(s1, s2, s3 string, i int) {
	fmt.Println(s1 + s2 + s3)
	fmt.Println(s1 + (s2 + s3))
	fmt.Println((s1 + s2) + s3)
	fmt.Sprintf("'%s'", s1)
	fmt.Sprintf("Here are %s and %s!", s1, s2)
	fmt.Sprintf("%v, quoted: %q", s1, s1)
}
