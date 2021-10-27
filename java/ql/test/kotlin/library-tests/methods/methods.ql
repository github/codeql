import java

query predicate methods(Method m) { m.fromSource() }

query predicate constructors(Constructor c) { c.fromSource() }

query predicate extensions(ExtensionMethod m, Type t) { m.getExtendedType() = t and m.fromSource() }
