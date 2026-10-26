package main

type t int

func main() {}

func f1(x int) {}

func (t t) f2(x, y int) {}

func (_ t) f3(x int, y string) {}

func f4(x int, y ...string) {}

func f5(x int) int { return 0 }

func f6(x int) (y int) { return 0 }

func f7() (x, y int) { return 0, 0 }

func f8() (x int, _ string) { return 0, "" }

func f9() (_ int, y string) { return 0, "" }
