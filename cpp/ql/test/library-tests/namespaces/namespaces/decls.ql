import cpp

string qual(Declaration d) {
  if exists(d.getQualifiedName()) then result = d.getQualifiedName() else result = "<none>"
}

newtype TMaybeNamespace =
  SomeNamespace(Namespace ns) or
  NoNamespace()

class MaybeNamespace extends TMaybeNamespace {
  string toString() {
    this = NoNamespace() and result = "<none>"
    or
    exists(Namespace ns | this = SomeNamespace(ns) and result = ns.toString())
  }

  Location getLocation() {
    exists(Namespace ns | this = SomeNamespace(ns) and result = ns.getLocation())
  }
}

from MaybeNamespace n, Declaration d
where
  n = SomeNamespace(d.getNamespace())
  or
  n = NoNamespace() and not exists(d.getNamespace())
select n, d, qual(d), any(boolean b | if d.isTopLevel() then b = true else b = false)
