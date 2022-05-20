import csharp
import semmle.code.csharp.commons.Diagnostics

query predicate extractorElements(ExtractorMessage m, Element e) { e = m.getElement() }

query predicate extractorErrors(ExtractorError e, string origin, string stackTrace) {
  origin = e.getOrigin() and stackTrace = e.getStackTrace()
}
