import csharp
import semmle.code.csharp.commons.Diagnostics

query predicate extractorMessages(ExtractorMessage msg, int severity, string elementText) {
  msg.getSeverity() = severity and msg.getElementText() = elementText
}
