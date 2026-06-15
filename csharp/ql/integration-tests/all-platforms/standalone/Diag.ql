import csharp
import semmle.code.csharp.commons.Diagnostics

query predicate extractorMessages(int c) { c = count(ExtractorMessage msg) }

query predicate compilerDiagnostics(int c) { c = count(Diagnostic diag) }

query predicate extractorMessagesLeachedLimit(ExtractorMessage msg) {
  msg.getText().indexOf("Stopped logging") = 0
}

query predicate compilationInfo(string key, float value) {
  exists(Compilation c, string infoValue |
    infoValue = c.getInfo(key) and
    key.matches(["Compiler diagnostic count for%", "Extractor message count for group%"])
  |
    value = infoValue.toFloat()
  )
}
