import javascript

query predicate xUnitAnnotationfrom(XUnitAnnotation ann, XUnitTarget target) {
  ann.getTarget() = target
}

query predicate xUnitAttribute(XUnitAttribute attr, string name, int numParam) {
  name = attr.getName() and numParam = attr.getNumParameter()
}

query predicate xUnitAttributeParameters(XUnitAttribute attr, int i, Expr param) {
  attr.getParameter(i) = param
}

query predicate xUnitFixture(XUnitFixture f, XUnitAnnotation ann) { f.getAnAnnotation() = ann }

query predicate xUnitTarget(XUnitTarget target) { any() }
