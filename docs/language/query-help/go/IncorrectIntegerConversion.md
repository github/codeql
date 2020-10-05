# Incorrect conversion between integer types

```
ID: go/incorrect-integer-conversion
Kind: path-problem
Severity: warning
Precision: very-high
Tags: security external/cwe/cwe-190 external/cwe/cwe-681

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-681/IncorrectIntegerConversion.ql)

If a string is parsed into an int using `strconv.Atoi`, and subsequently that int is converted into another integer type of a smaller size, the result can produce unexpected values.

This also applies to the results of `strconv.ParseInt` and `strconv.ParseUint` when the specified size is larger than the size of the type that number is converted to.


## Recommendation
If you need to parse integer values with specific bit sizes, avoid `strconv.Atoi`, and instead use `strconv.ParseInt` or `strconv.ParseUint`, which also allow specifying the bit size.

When using those functions, be careful to not convert the result to another type with a smaller bit size than the bit size you specified when parsing the number.

If this is not possible, then add upper (and lower) bound checks specific to each type and bit size (you can find the minimum and maximum value for each type in the `math` package).


## Example
In the first example, assume that an input string is passed to `parseAllocateBad1` function, parsed by `strconv.Atoi`, and then converted into an `int32` type:


```go
package main

import (
	"strconv"
)

func parseAllocateBad1(wanted string) int32 {
	parsed, err := strconv.Atoi(wanted)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}
func parseAllocateBad2(wanted string) int32 {
	parsed, err := strconv.ParseInt(wanted, 10, 64)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}

```
The bounds are not checked, so this means that if the provided number is greater than the maximum value of type `int32`, the resulting value from the conversion will be different from the actual provided value.

To avoid unexpected values, you should either use the other functions provided by the `strconv` package to parse the specific types and bit sizes as shown in the `parseAllocateGood2` function; or check bounds as in the `parseAllocateGood1` function.


```go
package main

import (
	"math"
	"strconv"
)

func main() {

}

const DefaultAllocate int32 = 256

func parseAllocateGood1(desired string) int32 {
	parsed, err := strconv.Atoi(desired)
	if err != nil {
		return DefaultAllocate
	}
	// GOOD: check for lower and upper bounds
	if parsed > 0 && parsed <= math.MaxInt32 {
		return int32(parsed)
	}
	return DefaultAllocate
}
func parseAllocateGood2(desired string) int32 {
	// GOOD: parse specifying the bit size
	parsed, err := strconv.ParseInt(desired, 10, 32)
	if err != nil {
		return DefaultAllocate
	}
	return int32(parsed)
}

func parseAllocateGood3(wanted string) int32 {
	parsed, err := strconv.ParseInt(wanted, 10, 32)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}
func parseAllocateGood4(wanted string) int32 {
	parsed, err := strconv.ParseInt(wanted, 10, 64)
	if err != nil {
		panic(err)
	}
	// GOOD: check for lower and uppper bounds
	if parsed > 0 && parsed <= math.MaxInt32 {
		return int32(parsed)
	}
	return DefaultAllocate
}

```

## Example
In the second example, assume that an input string is passed to `parseAllocateBad2` function, parsed by `strconv.ParseInt` with a bit size set to 64, and then converted into an `int32` type:


```go
package main

import (
	"strconv"
)

func parseAllocateBad1(wanted string) int32 {
	parsed, err := strconv.Atoi(wanted)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}
func parseAllocateBad2(wanted string) int32 {
	parsed, err := strconv.ParseInt(wanted, 10, 64)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}

```
If the provided number is greater than the maximum value of type `int32`, the resulting value from the conversion will be different from the actual provided value.

To avoid unexpected values, you should specify the correct bit size as in `parseAllocateGood3`; or check bounds before making the conversion as in `parseAllocateGood4`.


```go
package main

import (
	"math"
	"strconv"
)

func main() {

}

const DefaultAllocate int32 = 256

func parseAllocateGood1(desired string) int32 {
	parsed, err := strconv.Atoi(desired)
	if err != nil {
		return DefaultAllocate
	}
	// GOOD: check for lower and upper bounds
	if parsed > 0 && parsed <= math.MaxInt32 {
		return int32(parsed)
	}
	return DefaultAllocate
}
func parseAllocateGood2(desired string) int32 {
	// GOOD: parse specifying the bit size
	parsed, err := strconv.ParseInt(desired, 10, 32)
	if err != nil {
		return DefaultAllocate
	}
	return int32(parsed)
}

func parseAllocateGood3(wanted string) int32 {
	parsed, err := strconv.ParseInt(wanted, 10, 32)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}
func parseAllocateGood4(wanted string) int32 {
	parsed, err := strconv.ParseInt(wanted, 10, 64)
	if err != nil {
		panic(err)
	}
	// GOOD: check for lower and uppper bounds
	if parsed > 0 && parsed <= math.MaxInt32 {
		return int32(parsed)
	}
	return DefaultAllocate
}

```

## References
* Wikipedia [Integer overflow](https://en.wikipedia.org/wiki/Integer_overflow).
* Go language specification [Integer overflow](https://golang.org/ref/spec#Integer_overflow).
* Documentation for [strconv.Atoi](https://golang.org/pkg/strconv/#Atoi).
* Documentation for [strconv.ParseInt](https://golang.org/pkg/strconv/#ParseInt).
* Documentation for [strconv.ParseUint](https://golang.org/pkg/strconv/#ParseUint).
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).
* Common Weakness Enumeration: [CWE-681](https://cwe.mitre.org/data/definitions/681.html).