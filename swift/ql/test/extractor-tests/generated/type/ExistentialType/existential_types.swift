protocol ExplicitExistential {}
protocol ImplicitExistential {}
protocol P1 {}
protocol P2 {}

func foo1(_: any ExplicitExistential) {}
func foo2(_: ImplicitExistential) {}  // valid for now, will be an error in some future swift release
func foo3(_: any P1 & P2) {}
