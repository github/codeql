import csharp

query predicate sealed(Modifiable m) { m.getDeclaringType().fromSource() and m.isSealed() }
