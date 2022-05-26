import swift

from FuncDecl decl, string name
where
  decl.getLocation().getFile().getName().matches("%swift/ql/test%") and
  name = decl.getName()
select decl, name
