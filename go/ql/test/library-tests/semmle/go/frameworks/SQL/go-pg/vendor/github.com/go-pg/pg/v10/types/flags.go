package types

import "reflect"

const (
	quoteFlag = 1 << iota
	arrayFlag
	subArrayFlag
)

func hasFlag(flags, flag int) bool {
	return flags&flag == flag
}

func shouldQuoteArray(flags int) bool {
	return hasFlag(flags, quoteFlag) && !hasFlag(flags, subArrayFlag)
}

func nilable(v reflect.Value) bool {
	switch v.Kind() {
	case reflect.Chan, reflect.Func, reflect.Interface, reflect.Map, reflect.Ptr, reflect.Slice:
		return true
	}
	return false
}
