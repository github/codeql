import swift

string describe(Decl decl) { result = decl.(TypeAliasDecl).getAliasedType().toString() }

from Decl decl
where decl.getLocation().getFile().getName().matches("%swift/ql/test%")
select decl, concat(describe(decl), ", ")
