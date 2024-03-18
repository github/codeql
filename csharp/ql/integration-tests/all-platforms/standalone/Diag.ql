import csharp
import semmle.code.csharp.commons.Diagnostics

query predicate extractorMessages(int c) { c = count(ExtractorMessage msg) }

query predicate compilerDiagnostics(int c) { c = count(Diagnostic diag) }
