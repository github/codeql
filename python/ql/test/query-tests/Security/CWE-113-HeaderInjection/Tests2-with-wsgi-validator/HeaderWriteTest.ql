import python
import semmle.python.security.dataflow.HttpHeaderInjectionCustomizations
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts

query predicate source(HttpHeaderInjection::Source src) {
  src.getLocation().getFile().getBaseName() in ["wsgiref_tests.py", "flask_tests.py"]
}

query predicate sink(HttpHeaderInjection::Sink sink) { any() }

query predicate headerWrite(
  Http::Server::ResponseHeaderWrite write, DataFlow::Node name, DataFlow::Node val,
  boolean nameVuln, boolean valVuln
) {
  name = write.getNameArg() and
  val = write.getValueArg() and
  (if write.nameAllowsNewline() then nameVuln = true else nameVuln = false) and
  (if write.valueAllowsNewline() then valVuln = true else valVuln = false)
}
