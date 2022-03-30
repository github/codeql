package main

import (
	"fmt"
	"strings"
)

func test4(s string) string {
	s2 := strings.Replace(s, " ", "_", 1)
	s3 := strings.ReplaceAll(s, "&", "&amp;")
	return fmt.Sprint(s2, s3) + fmt.Sprintf("%q", s2) + fmt.Sprintln(s3)
}
