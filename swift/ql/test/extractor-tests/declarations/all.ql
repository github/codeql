import swift

from Decl decl
where decl.getLocation().getFile().getName().matches("%swift/ql/test%")
select decl
