import ruby

query Method method() { any() }

query MethodBase getADeclaration(Method m) { result = m.getADeclaration() }

query string getName(Method m) { result = m.getName() }

query Module getModule(Method m) { result = m.getModule() }

query Method getMethod(Module m, string name) { result = m.getMethod(name) }

query Method lookupMethod(Module m, string name) { result = m.lookupMethod(name) }
