import javascript
import semmle.javascript.security.dataflow.TaintedPath::TaintedPath

class Assertion extends LineComment {
  boolean shouldHaveAlert;

  Assertion() {
    if getText().matches("%NOT OK%")
    then shouldHaveAlert = true
    else (
      getText().matches("%OK%") and shouldHaveAlert = false
    )
  }

  predicate shouldHaveAlert() { shouldHaveAlert = true }

  predicate hasAlert() {
    exists(Configuration cfg, DataFlow::Node src, DataFlow::Node sink, Location loc |
      cfg.hasFlow(src, sink) and
      loc = sink.getAstNode().getLocation() and
      loc.getFile() = getFile() and
      loc.getEndLine() = getLocation().getEndLine()
    )
  }
}

from Assertion assertion, string message
where
  assertion.shouldHaveAlert() and not assertion.hasAlert() and message = "Missing alert"
  or
  not assertion.shouldHaveAlert() and assertion.hasAlert() and message = "Spurious alert"
select assertion, message
