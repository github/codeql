import java

query predicate methods(Method m, string signature) { m.fromSource() and signature = m.getSignature() }

query predicate constructors(Constructor c, string signature) { c.fromSource() and signature = c.getSignature() }

query predicate extensions(ExtensionMethod m, Type t) { m.getExtendedType() = t and m.fromSource() }
