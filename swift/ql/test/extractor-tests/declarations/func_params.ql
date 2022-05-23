import swift

from FuncDecl decl, int index, ParamDecl param
where
  decl.getLocation().getFile().getName().matches("%swift/ql/test%") and
  param = decl.getParam(index)
select decl, index, param
