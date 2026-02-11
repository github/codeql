import swift

from ModuleDecl decl
where not decl.isBuiltinModule() and not decl.isSystemModule()
select decl
