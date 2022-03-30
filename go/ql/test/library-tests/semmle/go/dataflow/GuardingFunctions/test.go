package main

import (
	"errors"
)

// Utilities: a source, a sink and a barrier guard ("isBad"):

func source() string {
	return "tainted"
}

func sink(s string) {}

func isBad(s string) bool {
	return len(s)%2 == 0
}

// Candidate barrier guard functions:

// Validates when returning nil
func guard(p string) error {
	if isBad(p) {
		return errors.New("zip contents corrupted")
	}
	return nil
}

// Validates when returning false
func guardBool(p string) bool {
	return isBad(p)
}

// Validates when returning false
func guardBoolStmt(p string) bool {
	if isBad(p) {
		return true
	}
	return false
}

// Validates arg2 when returning true
func juggleParams(arg1, arg2 string) bool {
	return arg1 == "hello world" && !guardBool(arg2)
}

// Valid when returning true
func guardBoolNeg(p string) bool {
	return !isBad(p)
}

// Valid when returning false
func guardBoolCmp(p string) bool {
	return isBad(p) == true
}

// Valid when returning true
func guardBoolNegCmp(p string) bool {
	return isBad(p) != true
}

// Valid when returning false
func guardBoolLOrLhs(p string) bool {
	return isBad(p) || p == "hello world"
}

// Doesn't reliably validate p
func guardBoolLOrNegLhs(p string) bool {
	return !isBad(p) || p == "hello world"
}

// Valid when returning false
func guardBoolLOrRhs(p string) bool {
	return p == "hello world" || isBad(p)
}

// Doesn't reliably validate p
func guardBoolLOrNegRhs(p string) bool {
	return p == "hello world" || !isBad(p)
}

// Doesn't reliably validate p
func guardBoolLAndLhs(p string) bool {
	return isBad(p) && p != "hello world"
}

// Valid when returning true
func guardBoolLAndNegLhs(p string) bool {
	return !isBad(p) && p != "hello world"
}

// Doesn't reliably validate p
func guardBoolLAndRhs(p string) bool {
	return p != "hello world" && isBad(p)
}

// Valid when returning true
func guardBoolLAndNegRhs(p string) bool {
	return p != "hello world" && !isBad(p)
}

// Valid when returning false
func guardBoolProxy(p string) bool {
	return guardBool(p)
}

// Valid when returning true
func guardBoolNegProxy(p string) bool {
	return !guardBool(p)
}

// Valid when returning false
func guardBoolCmpProxy(p string) bool {
	return guardBool(p) == true
}

// Valid when returning true
func guardBoolNegCmpProxy(p string) bool {
	return guardBool(p) != true
}

// Valid when returning false
func guardBoolLOrLhsProxy(p string) bool {
	return guardBool(p) || p == "hello world"
}

// Doesn't reliably validate p
func guardBoolLOrNegLhsProxy(p string) bool {
	return !guardBool(p) || p == "hello world"
}

// Valid when returning false
func guardBoolLOrRhsProxy(p string) bool {
	return p == "hello world" || guardBool(p)
}

// Doesn't reliably validate p
func guardBoolLOrNegRhsProxy(p string) bool {
	return p == "hello world" || !guardBool(p)
}

// Doesn't reliably validate p
func guardBoolLAndLhsProxy(p string) bool {
	return guardBool(p) && p != "hello world"
}

// Valid when returning true
func guardBoolLAndNegLhsProxy(p string) bool {
	return !guardBool(p) && p != "hello world"
}

// Doesn't reliably validate p
func guardBoolLAndRhsProxy(p string) bool {
	return p != "hello world" && guardBool(p)
}

// Valid when returning true
func guardBoolLAndNegRhsProxy(p string) bool {
	return p != "hello world" && !guardBool(p)
}

// Valid when returning true
func guardProxyNilToBool(p string) bool {
	return guard(p) == nil
}

// Valid when returning false
func guardNeqProxyNilToBool(p string) bool {
	return guard(p) != nil
}

// Valid when returning false
func guardNotEqProxyNilToBool(p string) bool {
	return !(guard(p) == nil)
}

// Valid when returning false
func guardLOrLhsProxyNilToBool(p string) bool {
	return guard(p) != nil || p == "hello world"
}

// Doesn't reliably validate p
func guardLOrNegLhsProxyNilToBool(p string) bool {
	return guard(p) == nil || p == "hello world"
}

// Valid when returning false
func guardLOrRhsProxyNilToBool(p string) bool {
	return p == "hello world" || guard(p) != nil
}

// Doesn't reliably validate p
func guardLOrNegRhsProxyNilToBool(p string) bool {
	return p == "hello world" || guard(p) == nil
}

// Doesn't reliably validate p
func guardLAndLhsProxyNilToBool(p string) bool {
	return guard(p) != nil && p != "hello world"
}

// Valid when returning true
func guardLAndNegLhsProxyNilToBool(p string) bool {
	return guard(p) == nil && p != "hello world"
}

// Doesn't reliably validate p
func guardLAndRhsProxyNilToBool(p string) bool {
	return p != "hello world" && !(guard(p) == nil)
}

// Valid when returning true
func guardLAndNegRhsProxyNilToBool(p string) bool {
	return p != "hello world" && guard(p) == nil
}

type retStruct struct {
	s string
}

// Valid when returning nil
func guardBoolProxyToNil(p string) *retStruct {
	if guardBool(p) {
		return &retStruct{"bad"}
	}
	return nil
}

// Valid when returning non-nil
func guardBoolNegProxyToNil(p string) *retStruct {
	if !guardBool(p) {
		return &retStruct{"good"}
	}
	return nil
}

// Valid when returning nil
func guardBoolCmpProxyToNil(p string) *retStruct {
	if guardBool(p) == true {
		return &retStruct{"bad"}
	}
	return nil
}

// Valid when returning non-nil
func guardBoolNegCmpProxyToNil(p string) *retStruct {
	if guardBool(p) != true {
		return &retStruct{"good"}
	}
	return nil
}

// Valid when returning nil
func guardBoolLOrLhsProxyToNil(p string) *retStruct {
	if guardBool(p) || p == "hello world" {
		return &retStruct{"bad"}
	}
	return nil
}

// Doesn't reliably validate p
func guardBoolLOrNegLhsProxyToNil(p string) *retStruct {
	if !guardBool(p) || p == "hello world" {
		return &retStruct{"inconclusive"}
	}
	return nil
}

// Valid when returning nil
func guardBoolLOrRhsProxyToNil(p string) *retStruct {
	if p == "hello world" || guardBool(p) {
		return &retStruct{"bad"}
	}
	return nil
}

// Doesn't reliably validate p
func guardBoolLOrNegRhsProxyToNil(p string) *retStruct {
	if p == "hello world" || !guardBool(p) {
		return &retStruct{"inconclusive"}
	}
	return nil
}

// Doesn't reliably validate p
func guardBoolLAndLhsProxyToNil(p string) *retStruct {
	if guardBool(p) && p != "hello world" {
		return &retStruct{"inconclusive"}
	}
	return nil
}

// Valid when returning non-nil
func guardBoolLAndNegLhsProxyToNil(p string) *retStruct {
	if !guardBool(p) && p != "hello world" {
		return &retStruct{"good"}
	}
	return nil
}

// Doesn't reliably validate p
func guardBoolLAndRhsProxyToNil(p string) *retStruct {
	if p != "hello world" && guardBool(p) {
		return &retStruct{"inconclusive"}
	}
	return nil
}

// Valid when returning non-nil
func guardBoolLAndNegRhsProxyToNil(p string) *retStruct {
	if p != "hello world" && !guardBool(p) {
		return &retStruct{"good"}
	}
	return nil
}

// Valid when returning nil
func directProxyNil(p string) error {
	return guard(p)
}

// Valid when returning true
func deeplyNestedConditionalLeft(p string) bool {
	return !isBad(p) && len(p)%2 == 1 && p[0] == 'a' && p[1] == 'b'
}

// Valid when returning true
func deeplyNestedConditionalMiddle(p string) bool {
	return len(p)%2 == 1 && p[0] == 'a' && !isBad(p) && p[1] == 'b'
}

// Valid when returning true
func deeplyNestedConditionalRight(p string) bool {
	return p[1] == 'b' && len(p)%2 == 1 && p[0] == 'a' && !isBad(p)
}

// Finally, actually test the functions -- try sinking a tainted value in the is-true/false
// or is-nil/non-nil case for each candidate:

func test() {

	{
		s := source()
		if guardBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolStmt(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if juggleParams("other arg", s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolNeg(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolCmp(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolNegCmp(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLOrLhs(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolLOrNegLhs(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLOrRhs(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolLOrNegRhs(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndLhs(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndNegLhs(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndRhs(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndNegRhs(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolProxy(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolNegProxy(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolCmpProxy(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolNegCmpProxy(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLOrLhsProxy(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolLOrNegLhsProxy(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLOrRhsProxy(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolLOrNegRhsProxy(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndLhsProxy(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndNegLhsProxy(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndRhsProxy(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndNegRhsProxy(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardProxyNilToBool(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardNeqProxyNilToBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardNotEqProxyNilToBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardLOrLhsProxyNilToBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardLOrNegLhsProxyNilToBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardLOrRhsProxyNilToBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardLOrNegRhsProxyNilToBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardLAndLhsProxyNilToBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardLAndNegLhsProxyNilToBool(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardLAndRhsProxyNilToBool(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardLAndNegRhsProxyNilToBool(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guard(s) == nil {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolProxyToNil(s) == nil {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolNegProxyToNil(s) == nil {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolCmpProxyToNil(s) == nil {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolNegCmpProxyToNil(s) == nil {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolLOrLhsProxyToNil(s) == nil {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLOrNegLhsProxyToNil(s) == nil {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLOrRhsProxyToNil(s) == nil {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLOrNegRhsProxyToNil(s) == nil {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndLhsProxyToNil(s) == nil {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndNegLhsProxyToNil(s) == nil {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if guardBoolLAndRhsProxyToNil(s) == nil {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if guardBoolLAndNegRhsProxyToNil(s) == nil {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		if directProxyNil(s) == nil {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if deeplyNestedConditionalLeft(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if deeplyNestedConditionalMiddle(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if deeplyNestedConditionalRight(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	// Note we can also assign the result of a guarding function to a variable and use that in
	// the conditional.

	{
		s := source()
		isInvalid := guardBool(s)
		if isInvalid {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		isValid := !guardBool(s)
		if isValid {
			sink(s) // $ SPURIOUS: dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

}
