@differentiable(reverse, wrt: (self, 0), where T: Differentiable)
func differentiate<T>(_ value: T) {}
@differentiable(reverse, wrt: value)
func scalar(_ value: Float) -> Float { value }
@derivative(of: scalar, wrt: 0)
func scalarDerivative(_ value: Float) {}
@derivative(of: Module.Foo.bar(_:), wrt: (self, 0))
func qualifiedDerivative() {}
@derivative(of: Foo.bar().get)
func accessorDerivative() {}
@transpose(of: scalar)
func transposed() {}
@derivative(of: subscript)
func differentiatedSubscript(index: Int) {}
