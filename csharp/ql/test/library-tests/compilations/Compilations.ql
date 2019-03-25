import csharp
import semmle.code.csharp.commons.Diagnostics

query predicate diagnostics(
  Diagnostic d, string tag, int severity, string message, string fullMessage
) {
  tag = d.getTag() and
  severity = d.getSeverity() and
  message = d.getMessage() and
  fullMessage = d.getFullMessage()
}

query predicate compilationErrors(CompilerError e) { any() }

query predicate metricTests(Compilation compilation, string message) {
  if forall(int metric | metric in [0 .. 6] | compilation.getMetric(metric) > 0.0)
  then message = "Test passed"
  else message = "Test failed"
}

query predicate compilation(Compilation c, string f) { f = c.getDirectoryString() }

query predicate compilationArguments(Compilation compilation, int i, string arg) {
  arg = compilation.getArgument(i)
}

query predicate compilationFiles(Compilation compilation, int i, File f) {
  f = compilation.getFileCompiled(i)
}

query predicate compilationFolder(Compilation c, Folder f) { f = c.getFolder() }

query predicate diagnosticElements(Diagnostic d, Element e) { e = d.getElement() }
