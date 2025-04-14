import csharp
import semmle.code.csharp.dataflow.internal.ExternalFlow

bindingset[namespace0, type0, name0, signature0]
predicate interpretCallable(
  string namespace0, string namespace, string type0, string type, string name0, string name,
  string signature0, string signature
) {
  exists(Callable c, string signature1 |
    c = interpretBaseDeclaration(namespace0, type0, name0, signature0) and
    partialModel(c, namespace, type, _, name, signature1) and
    if signature0 = "" then signature = "" else signature = signature1
  )
  or
  // if the row cannot be parsed (e.g. if the element is not in the DB), return the existing row unchanged
  not exists(interpretBaseDeclaration(namespace0, type0, name0, signature0)) and
  namespace = namespace0 and
  type = type0 and
  name = name0 and
  signature = signature0
}
