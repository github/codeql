package main

import "strings"

func test(s1, s2 string) bool {
	idx := strings.Index(s1, s2)
	return strings.HasPrefix(s1, s2) ||
		idx == 0 ||
		s1[0] != 'x' ||
		s1[0:len(s2)] == s2 ||
		s1[:len(s2)] == s2 ||
		s1[0:3] == "hi!"
}
