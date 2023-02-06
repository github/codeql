package main

import "testing"

func Test(t *testing.T) {} // test case

func Test2(t *testing.T) {} // test case

func TestMustHaveSingleParameter(t *testing.T, b bool) {} // not a test case

func TestParameterMustHaveCorrectType(b *testing.B) {} // not a test case

func TestsDoNotLookLikeThis(t *testing.T) {} // not a test case

func Benchmark(b *testing.B) {} // test case

func Benchmark2(b *testing.B) {} // test case

func BenchmarkMustHaveSingleParameter(b *testing.B, flag bool) {} // not a test case

func BenchmarkParameterMustHaveCorrectType(t *testing.T) {} // not a test case

func BenchmarksDoNotLookLikeThis(b *testing.B) {} // not a test case

func Example() {} // test case

func Example2() {} // test case

func ExampleMustNotHaveParameter(t *testing.T) {} // not a test case

func ExamplesDoNotLookLikeThis() {} // not a test case
