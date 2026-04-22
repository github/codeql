/**
 * This query generates type models for PowerShell from a C# database.
 * 
 * It is not meant to be run manually. Instead, it is executed
 * by `typemodelgenFromDB.py`.
 */
import csharp
private import semmle.code.csharp.commons.QualifiedName

private module FullyQualifiedNameInput implements QualifiedNameInputSig {
  string getUnboundGenericSuffix(UnboundGeneric ug) { exists(ug) and result = "" }
}

predicate hasFullyQualifiedNameImpl(Declaration d, string namespace, string type, string name) {
  QualifiedName<FullyQualifiedNameInput>::hasQualifiedName(d, namespace, type, name)
}

predicate hasFullyQualifiedNameImpl(Declaration d, string qualifier, string name) {
  QualifiedName<FullyQualifiedNameInput>::hasQualifiedName(d, qualifier, name)
}

predicate hasFullyQualifiedName(Callable callable, string namespace, string type, string name) {
  hasFullyQualifiedNameImpl(callable.(Method).getUnboundDeclaration(), namespace, type, name)
}

Type getReturnType(Callable c) {
  result = c.(Method).getReturnType()
}

bindingset[t]
Type remap(Type t) {
  if hasFullyQualifiedNameImpl(t, "System", "ReadOnlySpan")
  then hasFullyQualifiedNameImpl(result, "System", "String")
  else (
    if t instanceof TupleType
    then hasFullyQualifiedNameImpl(result, "System", "ValueTuple")
    else result = t
  )
}

from Callable m, Type t, string namespace, string type, string name, string qualifier, string return
where
  hasFullyQualifiedName(m, namespace, type, name) and
  not type.matches("%+%") and
  not return.matches("%+%") and
  getReturnType(m) = t and
  not t instanceof VoidType and
  hasFullyQualifiedNameImpl(remap(t.getUnboundDeclaration()), qualifier, return) and
  qualifier != "" and
  m.fromSource() and
  exists(string relative |
    relative = m.getLocation().getFile().getRelativePath() and
    not relative.toLowerCase().matches("%/tests/%")
  )
select qualifier.toLowerCase() + "." + return.toLowerCase(),
  namespace.toLowerCase() + "." + type.toLowerCase(), name.toLowerCase()
