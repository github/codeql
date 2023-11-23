import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink
import semmle.code.csharp.commons.Diagnostics

query predicate compilationErrors(CompilerError e) { any() }

query predicate methodCalls(MethodCall mc) { any() }

query predicate methodCallsTargets(MethodCall mc, Method m) { mc.getTarget() = m }

query predicate field(Field f, string t) {
  f.getType().getFullyQualifiedName() = t and f.fromSource()
}

query predicate ambiguousAlternativeTypes(Type t, Type alternative) {
  t.getAnAmbiguousAlternativeType() = alternative
}
