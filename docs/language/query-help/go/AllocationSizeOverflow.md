# Size computation for allocation may overflow

```
ID: go/allocation-size-overflow
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-190

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-190/AllocationSizeOverflow.ql)

Performing calculations involving the size of potentially large strings or slices can result in an overflow (for signed integer types) or a wraparound (for unsigned types). An overflow causes the result of the calculation to become negative, while a wraparound results in a small (positive) number.

This can cause further issues. If, for example, the result is then used in an allocation, it will cause a runtime panic if it is negative, and allocate an unexpectedly small buffer otherwise.


## Recommendation
Always guard against overflow in arithmetic operations involving potentially large numbers by doing one of the following:

* Validate the size of the data from which the numbers are computed.
* Define a guard on the arithmetic expression, so that the operation is performed only if the result can be known to be less than, or equal to, the maximum value for the type.
* Use a wider type (such as `uint64` instead of `int`), so that larger input values do not cause overflow.

## Example
In the following example, assume that there is a function `encryptBuffer` that encrypts byte slices whose length must be padded to be a multiple of 16. The function `encryptValue` provides a convenience wrapper around this function: when passed an arbitrary value, it first encodes that value as JSON, pads the resulting byte slice, and then passes it to `encryptBuffer`.


```go
package main

import "encoding/json"

func encryptValue(v interface{}) ([]byte, error) {
	jsonData, err := json.Marshal(v)
	if err != nil {
		return nil, err
	}
	size := len(jsonData) + (len(jsonData) % 16)
	buffer := make([]byte, size)
	copy(buffer, jsonData)
	return encryptBuffer(buffer)
}

```
When passed a value whose JSON encoding is close to the maximum value of type `int` in length, the computation of `size` will overflow, producing a negative value. When that negative value is passed to `make`, a runtime panic will occur.

To guard against this, the function should be improved to check the length of the JSON-encoded value. For example, here is a version of `encryptValue` that ensures the value is no larger than 64 MB, which fits comfortably within an `int` and avoids the overflow:


```go
package main

import (
	"encoding/json"
	"errors"
)

func encryptValueGood(v interface{}) ([]byte, error) {
	jsonData, err := json.Marshal(v)
	if err != nil {
		return nil, err
	}
	if len(jsonData) > 64*1024*1024 {
		return nil, errors.New("value too large")
	}
	size := len(jsonData) + (len(jsonData) % 16)
	buffer := make([]byte, size)
	copy(buffer, jsonData)
	return encryptBuffer(buffer)
}

```

## References
* The Go Programming Language Specification: [Integer overflow](https://golang.org/ref/spec#Integer_overflow).
* The Go Programming Language Specification: [Making slices, maps and channels](https://golang.org/ref/spec#Making_slices_maps_and_channels).
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).