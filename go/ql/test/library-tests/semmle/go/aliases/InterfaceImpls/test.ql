import go

query predicate callTargets(DataFlow::CallNode cn, FuncDef target, string targetName) {
  target = cn.getACallee() and targetName = target.getName()
}

from InterfaceType i, Type impl
where
  i.hasMethod("ImplementMe", _) and
  impl.implements(i)
select i, impl.pp()
