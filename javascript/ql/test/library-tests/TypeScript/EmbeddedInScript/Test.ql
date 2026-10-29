import javascript

query ClassDefinition classDeclaration() { any() }

query predicate importTarget(Import imprt, Module mod) { imprt.getImportedModule() = mod }
