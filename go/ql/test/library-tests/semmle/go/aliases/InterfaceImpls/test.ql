import go

query predicate callTargets(DataFlow::CallNode cn, FuncDef target, string targetName) {
  target = cn.getACallee() and targetName = target.getName()
}

from InterfaceType i, Type impl
where
  i.hasMethod("ImplementMe", _) and
  impl.implements(i) and
  // Avoid duplicates caused by different types which are the same
  // when you ignore aliases.
  impl = impl.getDeepUnaliasedType() and
  i = i.getDeepUnaliasedType()
select i.pp(), impl.pp()
