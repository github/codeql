import javascript

query predicate abseval(
  VariableDeclarator vd, DataFlow::AnalyzedNode init, BindingPattern var, AbstractValue val
) {
  init = vd.getInit().analyze() and
  var = vd.getBindingPattern() and
  val = init.getAValue()
}

query predicate abstractValues(AbstractValue val) { any() }

query predicate getAPrototype(AbstractValue av, DefiniteAbstractValue proto) {
  av.getAPrototype() = proto
}

private import semmle.javascript.dataflow.Refinements

query predicate refinement_eval(Refinement ref, RefinementContext ctxt, RefinementValue val) {
  ref.eval(ctxt) = val
}

query predicate types(
  VariableDeclarator vd, DataFlow::AnalyzedNode init, BindingPattern var, string types
) {
  init = vd.getInit().analyze() and
  var = vd.getBindingPattern() and
  types = init.ppTypes()
}
