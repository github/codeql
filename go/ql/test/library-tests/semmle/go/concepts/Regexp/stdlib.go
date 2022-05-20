package main

import (
	"bufio"
	"os"
	"regexp"
)

func main() {
	regexp.Match("a", []byte("aaaa"))
	file, _ := os.Open("file")
	regexp.MatchReader(`(^|\n)repository=`, bufio.NewReader(file))
	regexp.MatchString("ab", "baaa")

	re, _ := regexp.Compile("[so]me|regex")
	re, _ = regexp.CompilePOSIX("posix?")
	re.MatchString("posi")
	regexp.MustCompile("")
	regexp.MustCompilePOSIX("mustPosix")

	re.ReplaceAll([]byte("src0"), []byte("rep0"))
	re.ReplaceAllFunc([]byte("src1"), func(pat []byte) []byte { return []byte("rep1") })
	re.ReplaceAllLiteral([]byte("src2"), []byte("rep2"))
	re.ReplaceAllLiteralString("src3", "rep3")
	re.ReplaceAllString("src4", "rep4")
	re.ReplaceAllStringFunc("src5", func(pat string) string { return "rep5" })

	re.Match([]byte("some"))
	re.MatchReader(bufio.NewReader(file))

	re.String()
}
