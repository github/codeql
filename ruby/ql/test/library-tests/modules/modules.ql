import ruby

query Module getModule() { any() }

query ModuleBase getADeclaration(Module m) { result = m.getADeclaration() }

query Module getSuperClass(Module m) { result = m.getSuperClass() }

query Module getAPrependedModule(Module m) { result = m.getAPrependedModule() }

query Module getAnIncludedModule(Module m) { result = m.getAnIncludedModule() }
