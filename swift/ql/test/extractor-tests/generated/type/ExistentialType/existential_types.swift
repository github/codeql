protocol ExplicitExistential {}
protocol ImplicitExistential {}

func foo1(_: any ExplicitExistential) {}
func foo2(_: ImplicitExistential) {}  // valid for now, will be an error in some future swift release
