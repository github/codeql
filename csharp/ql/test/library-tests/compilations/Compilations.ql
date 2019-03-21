import csharp
import semmle.code.csharp.commons.Diagnostics

query predicate diags(Diagnostic d, string id, int severity, string message, string fullMessage) {
  id = d.getId() and
  severity = d.getSeverity() and
  message = d.getMessage() and
  fullMessage = d.getFullMessage()
}

query predicate metricTests(Compilation compilation, string message) {
  message = "Test passed" and
  forall(int metric | metric in [0 .. 6] | compilation.getMetric(metric) > 0.0)
}

query predicate compilation(Compilation c, string f) { f = c.getDirectoryString() }

query predicate compilationArguments(Compilation compilation, int i, string arg) {
  arg = compilation.getArgument(i)
}

query predicate compilationFiles(Compilation compilation, int i, File f) {
  f = compilation.getFile(i)
}

query predicate compilationFolder(Compilation c, Folder f) { f = c.getFolder() }
