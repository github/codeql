import csharp
import semmle.code.csharp.commons.Diagnostics

query predicate compilationMessages(Diagnostic diag) { any() }

query predicate extractorMessages(ExtractorMessage msg) { any() }
