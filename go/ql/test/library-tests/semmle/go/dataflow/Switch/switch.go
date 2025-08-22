package main

type Type1 struct {
	field1 string
}
type Type2 struct {
	field2 string
}
type Type3 struct {
	field3 string
}

func source() string {
	return "source"
}

func sink(s string) {
}

func typeSwitch1(input any, defaultValue string) string {
	switch x := input.(type) {
	case *Type1:
		return x.field1
	case *Type2, *Type3:
		if x3, ok := x.(*Type2); ok {
			return x3.field2
		}
		if x4, ok := x.(*Type3); ok {
			return x4.field3
		}
		return ""
	default:
		_ = x
		return defaultValue
	}
}

func typeSwitch2(input any, defaultValue string) string {
	switch input.(type) {
	case *Type1:
		return input.(*Type1).field1
	case *Type2, *Type3:
		if x3, ok := input.(*Type2); ok {
			return x3.field2
		}
		if x4, ok := input.(*Type3); ok {
			return x4.field3
		}
		return ""
	default:
		_ = input
		return defaultValue
	}
}

func expressionSwitch1(input string, defaultValue string) string {
	switch input {
	case "0":
		return "0"
	case "1", "2":
		return "1 or 2"
	case "3":
		fallthrough
	default:
		return defaultValue
	}
}

func expressionSwitch2(input string, defaultValue string) string {
	switch def := defaultValue; input {
	case "0":
		return "0"
	case "1", "2":
		return "1 or 2"
	case "3":
		fallthrough
	default:
		return def
	}
}

func main() {
	sink(typeSwitch1(&Type1{source()}, "default")) // $ hasValueFlow="call to typeSwitch1"
	sink(typeSwitch1(&Type2{source()}, "default")) // $ hasValueFlow="call to typeSwitch1"
	sink(typeSwitch1(&Type3{source()}, "default")) // $ hasValueFlow="call to typeSwitch1"
	sink(typeSwitch1(nil, source()))               // $ hasValueFlow="call to typeSwitch1"

	sink(typeSwitch2(&Type1{source()}, "default")) // $ hasValueFlow="call to typeSwitch2"
	sink(typeSwitch2(&Type2{source()}, "default")) // $ hasValueFlow="call to typeSwitch2"
	sink(typeSwitch2(&Type3{source()}, "default")) // $ hasValueFlow="call to typeSwitch2"
	sink(typeSwitch2(nil, source()))               // $ hasValueFlow="call to typeSwitch2"

	sink(expressionSwitch1("1", source())) // $ SPURIOUS: hasValueFlow="call to expressionSwitch1"
	sink(expressionSwitch1("2", source())) // $ SPURIOUS: hasValueFlow="call to expressionSwitch1"
	sink(expressionSwitch1("3", source())) // $ hasValueFlow="call to expressionSwitch1"
	sink(expressionSwitch1("4", source())) // $ hasValueFlow="call to expressionSwitch1"

	sink(expressionSwitch2("1", source())) // $ SPURIOUS: hasValueFlow="call to expressionSwitch2"
	sink(expressionSwitch2("2", source())) // $ SPURIOUS: hasValueFlow="call to expressionSwitch2"
	sink(expressionSwitch2("3", source())) // $ hasValueFlow="call to expressionSwitch2"
	sink(expressionSwitch2("4", source())) // $ hasValueFlow="call to expressionSwitch2"
}
