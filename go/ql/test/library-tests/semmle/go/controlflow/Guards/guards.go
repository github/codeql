package guards

import (
	"errors"
	"fmt"
)

func sink(string) {}

func taglessSwitch(value int) {
	switch {
	case value < 0:
		sink("negative")
	case value == 0:
		sink("zero")
	default:
		sink("positive")
	}
}

func taggedSwitch(value int) {
	switch value {
	case 0:
		sink("tagged zero")
	case 1, 2:
		sink("tagged one or two")
	default:
		sink("tagged other")
	}
}

func taggedBooleanSwitch(value bool, number int) {
	switch false {
	case value:
		sink("tagged false boolean")
	}
	switch true {
	case value:
		sink("tagged true boolean")
	}
	switch false {
	case number < 10:
		sink("tagged false comparison")
	}
}

func compoundCondition(a, b, c bool) {
	if a && (b || c) {
		sink("compound true")
	} else {
		sink("compound false")
	}
}

func conversions(wide int16, narrow int8) {
	if int32(wide) == 0 {
		sink("upcast")
	}
	if int8(wide) == 0 {
		sink("downcast")
	}
	if int16(narrow) == 0 {
		sink("upcast narrow")
	}
}

func nonStrictComparisons(value int) {
	if value <= 10 {
		sink("at most ten")
	} else {
		sink("above ten")
	}
	if 10 <= value {
		sink("at least ten")
	} else {
		sink("below ten")
	}
}

func ssaGuards(value bool) {
	copy := value
	if copy {
		sink("ssa copy")
	}

	phi := false
	if value {
		phi = true
	}
	if phi {
		sink("ssa phi")
	}
}

func nilGuards(pointer *int, value any) {
	if pointer == nil {
		sink("nil pointer")
	} else {
		sink("non-nil pointer")
	}

	if pointer == (*int)(nil) {
		sink("typed nil pointer") // pointer is null
	}

	if value == new(int) {
		sink("new result") // value is not null
	}

	if value == make(chan int) {
		sink("make result") // value is not null
	}

	if value == &struct{}{} {
		sink("composite literal")
	}

	if value == errors.New("error") {
		sink("errors new") // value is not null
	}

	if value == fmt.Errorf("error") {
		sink("fmt errorf") // value is not null
	}

	if value == returnsNonNil() {
		sink("source non-nil return") // value is not null
	}
}

func returnsNonNil() *int {
	return new(int)
}

func defaultCase(value int) {
	switch value {
	case 0:
		sink("non-default case")
	default:
		sink("default case") // default case matches
	}
}

func defaultBeforeCase(value int) {
	switch value {
	default:
		sink("default before case") // default case matches
	case 0:
		sink("case after default")
	}
}

func defaultOnly(value int) {
	switch value {
	default:
		sink("default only") // default case matches
	}
}

func expressionlessDefault(value bool) {
	switch {
	case value:
		sink("expressionless case")
	default:
		sink("expressionless default") // default case matches
	}
}

func fallthroughToDefault(value int) {
	switch value {
	case 0:
		fallthrough
	default:
		sink("fallthrough default") // No default-match fact: this is also reached by fallthrough.
	}
}

func isNotNil(pointer *int) bool {
	return pointer != nil
}

func wrapperGuard(pointer *int) {
	if isNotNil(pointer) {
		sink("non-variadic wrapper")
	}
}

func namedResultIsNotNil(pointer *int) (valid bool) {
	valid = pointer != nil
	return
}

func namedResultWrapper(pointer *int) {
	if namedResultIsNotNil(pointer) {
		sink("named result wrapper") // pointer is not null
	}
}

func conditionalNamedResultIsNotNil(pointer *int) (valid bool) {
	if pointer == nil {
		return
	}
	valid = true
	return
}

func conditionalNamedResultWrapper(pointer *int) {
	if conditionalNamedResultIsNotNil(pointer) {
		sink("conditional named result wrapper") // pointer is not null
	}
}

type pointerValidator interface {
	isNotNil(*int) bool
}

type concreteValidator struct{}

func (concreteValidator) isNotNil(pointer *int) bool {
	return pointer != nil
}

func methodWrapper(validator concreteValidator, pointer *int) {
	if validator.isNotNil(pointer) {
		sink("method wrapper") // pointer is not null
	}
}

func methodExpressionWrapper(validator concreteValidator, pointer *int) {
	if concreteValidator.isNotNil(validator, pointer) {
		sink("method expression wrapper") // pointer is not null
	}
}

func interfaceMethodWrapper(validator pointerValidator, pointer *int) {
	if validator.isNotNil(pointer) {
		sink("interface method wrapper") // No pointer fact: the concrete target is unknown.
	}
}

type receiverValidator struct{}

func (validator *receiverValidator) isNotNil() bool {
	return validator != nil
}

func receiverMethodWrapper(validator *receiverValidator) {
	if validator.isNotNil() {
		sink("receiver method wrapper") // validator is not null
	}
}

func receiverMethodExpressionWrapper(validator *receiverValidator) {
	if (*receiverValidator).isNotNil(validator) {
		sink("receiver method expression wrapper") // validator is not null
	}
}

type promotedReceiverValidator struct {
	*receiverValidator
}

func promotedReceiverMethodWrapper(validator promotedReceiverValidator) {
	if validator.isNotNil() {
		sink("promoted receiver method wrapper") // No fact for the outer validator.
	}
}

func implicitAddressReceiverMethodWrapper(validator receiverValidator) {
	if validator.isNotNil() {
		sink("implicit address receiver method wrapper") // No fact for the addressed value.
	}
}

type booleanReceiverValidator bool

func (validator booleanReceiverValidator) isTrue() bool {
	return validator == true
}

func implicitDereferenceReceiverMethodWrapper(validator *booleanReceiverValidator) {
	if validator.isTrue() {
		sink("implicit dereference receiver method wrapper") // No Boolean fact for the pointer.
	}
}

func alwaysTrue(*int) bool {
	return true
}

func indirectWrapper(pointer *int, useValidation bool) {
	check := alwaysTrue
	if useValidation {
		check = isNotNil
	}
	if check(pointer) {
		sink("indirect wrapper") // No pointer fact: the possible target may not validate it.
	}
}

func hasArgs(values ...*int) bool {
	return values != nil
}

func variadicWrapper(pointer *int, pointers []*int) {
	if hasArgs(pointer) {
		sink("implicit variadic wrapper") // No pointer fact: only the synthetic slice is non-null.
	}
	if hasArgs(pointers...) {
		sink("explicit variadic wrapper")
	}
}

func ensureNotNil(pointer *int) {
	if pointer == nil {
		panic("nil pointer")
	}
}

func exceptionGuard(pointer *int) {
	ensureNotNil(pointer)
	sink("after assertion") // pointer is not null
}

func valueSink(string, any) {}

func modelBoolGuard(pointer *int) bool {
	return pointer != nil
}

func modelZeroGuard(pointer *int) int {
	return 0
}

func modelNotZeroGuard(pointer *int) int {
	return 1
}

func modelNullGuard(pointer *int) *int {
	return nil
}

func modelNotNullGuard(pointer *int) *int {
	return pointer
}

func modelExceptionGuard(pointer *int) {}

func modelGuards(pointer *int) {
	if modelBoolGuard(pointer) {
		valueSink("model bool", pointer)
	}
	if modelZeroGuard(pointer) == 0 {
		valueSink("model zero", pointer) // model-zero barrier
	}
	if modelNotZeroGuard(pointer) != 0 {
		valueSink("model not zero", pointer) // model-not-zero barrier
	}
	if modelNullGuard(pointer) == nil {
		valueSink("model null", pointer) // model-null barrier
	}
	if modelNotNullGuard(pointer) != nil {
		valueSink("model not null", pointer) // model-not-null barrier
	}
	modelExceptionGuard(pointer)
	valueSink("model no exception", pointer) // model-no-exception barrier
}
