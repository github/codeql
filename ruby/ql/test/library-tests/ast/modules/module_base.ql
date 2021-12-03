import ruby

query predicate moduleBases(ModuleBase mb, string pClass) { pClass = mb.getAPrimaryQlClass() }

query predicate moduleBaseClasses(ModuleBase mb, ClassDeclaration c) { c = mb.getAClass() }

query predicate moduleBaseMethods(ModuleBase mb, Method m) { m = mb.getAMethod() }

query predicate moduleBaseModules(ModuleBase mb, ModuleDeclaration m) { m = mb.getAModule() }
