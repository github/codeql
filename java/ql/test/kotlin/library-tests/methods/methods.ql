import java

query predicate methods(RefType declType, Method m, string signature, string modifiers) {
  m.fromSource() and
  declType = m.getDeclaringType() and
  signature = m.getSignature() and
  modifiers = concat(string s | m.hasModifier(s) | s, ", ")
}

query predicate constructors(RefType declType, Constructor c, string signature) { c.fromSource() and declType = c.getDeclaringType() and signature = c.getSignature() }

query predicate extensions(ExtensionMethod m, Type t) { m.getExtendedType() = t and m.fromSource() }
