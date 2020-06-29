import javascript

query ClassDefinition classDeclaration() { any() }

query Type exprType(Expr e) { result = e.getType() }

query predicate symbols(Module mod, CanonicalName name) { ast_node_symbol(mod, name) }

query predicate importTarget(Import imprt, Module mod) { imprt.getImportedModule() = mod }
