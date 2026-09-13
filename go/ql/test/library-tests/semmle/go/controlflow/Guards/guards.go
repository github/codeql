package guards

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
