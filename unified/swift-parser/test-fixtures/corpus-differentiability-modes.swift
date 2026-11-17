func linear(_ fn: @escaping @differentiable(_linear) (Float) -> Float)
    -> @differentiable(_linear) (Float) -> Float {
    fn
}
@differentiable(_forward, wrt: 0)
func forward(_ value: Float) -> Float { value }
@derivative(of: subscript.get)
func differentiatedGetter() {}
@derivative(of: Container.subscript.get)
func differentiatedMemberGetter() {}
@transpose(of: A.+, wrt: 0)
func transposedOperator(_ value: A) -> A { value }
@derivative(of: Module.A..+, wrt: 0)
func differentiatedDotOperator() {}
