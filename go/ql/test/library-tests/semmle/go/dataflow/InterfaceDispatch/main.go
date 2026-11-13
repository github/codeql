package main

type Greeter interface {
	Greet() string
}

type SafeGreeter struct{}
type TaintedGreeter struct{}

func source() string { return "tainted" }
func sink(string)    {}

func (SafeGreeter) Greet() string    { return "safe" }
func (TaintedGreeter) Greet() string { return source() }

func capturedOverwrite() {
	var g Greeter = SafeGreeter{}
	set := func() { g = TaintedGreeter{} }
	set()
	sink(g.Greet()) // $ hasValueFlow="call to Greet"
}

func readOnlyLoop(b bool) {
	var g Greeter = SafeGreeter{}
	for b {
		x := g
		sink(x.Greet())
	}
	x := g
	sink(x.Greet())
}

func overwriteLoop(b bool) {
	var g Greeter = SafeGreeter{}
	for b {
		g = TaintedGreeter{}
	}
	sink(g.Greet()) // $ hasValueFlow="call to Greet"
}

func unknownReceiver(g Greeter, b bool) {
	for b {
		g = SafeGreeter{}
	}
	sink(g.Greet()) // $ hasValueFlow="call to Greet"
}

func main() {}
