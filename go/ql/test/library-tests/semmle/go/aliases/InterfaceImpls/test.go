package intfs

type IntAlias = int

type Target = interface {
	ImplementMe(callable func(struct{ x IntAlias }))
}

// Simple direct implementation
type Impl1 struct{}

func (recv Impl1) ImplementMe(callable func(struct{ x IntAlias })) {}

// Implementation via unalising
type Impl2 struct{}

func (recv Impl2) ImplementMe(callable func(struct{ x int })) {}

// Implementation via top-level aliasing
type Impl3 struct{}

type Impl3Alias = func(struct{ x IntAlias })

func (recv Impl3) ImplementMe(callable Impl3Alias) {}

// Implementation via aliasing the struct
type Impl4 struct{}

type Impl4Alias = struct{ x IntAlias }

func (recv Impl4) ImplementMe(callable func(Impl4Alias)) {}

// Implementation via aliasing the struct member
type Impl5 struct{}

type Impl5Alias = IntAlias

func (recv Impl5) ImplementMe(callable func(struct{ x Impl5Alias })) {}

func Caller(target Target) {
	target.ImplementMe(nil)
}
