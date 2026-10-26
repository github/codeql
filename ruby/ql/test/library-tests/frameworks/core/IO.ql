import codeql.ruby.frameworks.core.IO::IO
import codeql.ruby.DataFlow

query predicate ioPOpenCalls(POpenCall c) { any() }

query DataFlow::Node ioPOpenCallArguments(POpenCall c, boolean shellInterpreted) {
  result = c.getAnArgument() and
  if c.isShellInterpreted(result) then shellInterpreted = true else shellInterpreted = false
}
