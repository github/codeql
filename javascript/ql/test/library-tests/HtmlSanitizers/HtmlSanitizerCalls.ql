import javascript

class Assertion extends DataFlow::CallNode {
  Assertion() {
    this.getCalleeName() = "checkEscaped" or
    this.getCalleeName() = "checkStripped" or
    this.getCalleeName() = "checkNotEscaped"
  }

  predicate shouldBeSanitizer() { this.getCalleeName() != "checkNotEscaped" }

  string getMessage() {
    if this.shouldBeSanitizer() and not this.getArgument(0) instanceof HtmlSanitizerCall
    then result = "Should be marked as sanitizer"
    else
      if not this.shouldBeSanitizer() and this.getArgument(0) instanceof HtmlSanitizerCall
      then result = "Should not be marked as sanitizer"
      else result = "OK"
  }
}

from Assertion assertion
select assertion, assertion.getMessage()
