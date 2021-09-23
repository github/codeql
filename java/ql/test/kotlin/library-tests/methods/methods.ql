import java

query predicate methods(Method m) { any() }

query predicate extensions(ExtensionMethod m, Type t) { m.getExtendedType() = t }
