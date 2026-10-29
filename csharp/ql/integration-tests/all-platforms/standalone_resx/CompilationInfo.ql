import csharp
import semmle.code.csharp.commons.Diagnostics

query predicate compilationInfo(string key, string value) {
  key != "Resolved references" and
  key != "Resolved assembly conflicts" and
  not key.matches("Compiler diagnostic count for%") and
  value = any(Compilation c).getInfo(key)
}
