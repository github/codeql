import ruby
import codeql.ruby.ast.internal.Module as M

query MethodBase getMethod(Module m, string name) {
  result = M::ExposedForTestingOnly::getMethod(m, name)
}

query MethodBase lookupMethod(Module m, string name) { result = M::lookupMethod(m, name) }
