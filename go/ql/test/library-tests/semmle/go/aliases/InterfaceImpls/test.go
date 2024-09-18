package intfs

// Tests that dataflow and interface implementation behave as expected when an interface
// is implemented using an identical type (in the structural sense defined by the go spec)
// where the two types differ at surface level, i.e. aliases must be followed to determine
// that they are identical.

type IntAlias = int

type Target = interface {
	ImplementMe(callable func(struct{ x IntAlias }))
}

func source() func(struct{ x IntAlias })   { return nil }
func sink(fptr func(struct{ x IntAlias })) {}

// Simple direct implementation
type Impl1 struct{}

func (recv Impl1) ImplementMe(callable func(struct{ x IntAlias })) { sink(callable) } // $ hasValueFlow="callable"

// Implementation via unaliasing
type Impl2 struct{}

func (recv Impl2) ImplementMe(callable func(struct{ x int })) { sink(callable) } // $ hasValueFlow="callable"

// Implementation via top-level aliasing
type Impl3 struct{}

type Impl3Alias = func(struct{ x IntAlias })

func (recv Impl3) ImplementMe(callable Impl3Alias) { sink(callable) } // $ hasValueFlow="callable"

// Implementation via aliasing the struct
type Impl4 struct{}

type Impl4Alias = struct{ x IntAlias }

func (recv Impl4) ImplementMe(callable func(Impl4Alias)) { sink(callable) } // $ hasValueFlow="callable"

// Implementation via aliasing the struct member
type Impl5 struct{}

type Impl5Alias = IntAlias

func (recv Impl5) ImplementMe(callable func(struct{ x Impl5Alias })) { sink(callable) } // $ hasValueFlow="callable"

// Implementation via defining the method on an alias
type Impl6 struct{}

type Impl6Alias = Impl6

func (recv Impl6Alias) ImplementMe(callable func(struct{ x int })) { sink(callable) } // $ hasValueFlow="callable"

func Caller(target Target) {
	callable := source()
	target.ImplementMe(callable)
}
