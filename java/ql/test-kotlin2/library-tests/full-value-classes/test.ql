import java

string backingField(Property p) {
  if exists(p.getBackingField()) then result = p.getBackingField().toString() else result = "<none>"
}

query predicate classes(Class c, string classModifiers) {
  c.fromSource() and
  not c.isCompilerGenerated() and
  c.getLocation().getStartLine() > 0 and
  classModifiers = concat(string m | c.hasModifier(m) | m, ", ")
}

query predicate supertypes(Class c, Class supertype) {
  c.fromSource() and
  supertype.fromSource() and
  extendsReftype(c, supertype)
}

query predicate properties(
  Property p, string propertyType, string propertyModifiers, Method getter, string field
) {
  p.fromSource() and
  propertyType = p.getGetter().getReturnType().toString() and
  propertyModifiers = concat(string m | p.hasModifier(m) | m, ", ") and
  getter = p.getGetter() and
  field = backingField(p)
}

query predicate constructors(Constructor c, string signature) {
  c.fromSource() and
  signature = c.getSignature()
}

query predicate constructorCalls(ConstructorCall call, Constructor target) {
  call.getEnclosingCallable().fromSource() and
  target = call.getConstructor() and
  target.getSourceDeclaration().fromSource()
}
