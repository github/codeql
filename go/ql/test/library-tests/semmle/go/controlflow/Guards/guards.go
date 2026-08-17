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
