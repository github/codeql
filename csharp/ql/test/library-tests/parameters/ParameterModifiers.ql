import csharp

class TestParameter extends Parameter {
  TestParameter() { this.getFile().getBaseName() = "ParameterModifiers.cs" }
}

query predicate parameterModifier(TestParameter p, int kind) { params(p, _, _, _, kind, _, _) }

query predicate parameterIsValue(TestParameter p) { p.isValue() }

query predicate parameterIsIn(TestParameter p) { p.isIn() }

query predicate parameterIsOut(TestParameter p) { p.isOut() }

query predicate parameterIsRef(TestParameter p) { p.isRef() }

query predicate parameterIsParams(TestParameter p) { p.isParams() }

query predicate parameterIsReadonlyRef(TestParameter p) { p.isReadonlyRef() }
