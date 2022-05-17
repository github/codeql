import swift

from FuncDecl decl, int index, ParamDecl param
where param = decl.getParam(index)
select decl, index, param
