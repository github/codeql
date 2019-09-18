import javascript

class Assertion extends DataFlow::CallNode {
  Assertion() {
    getCalleeName() = "checkEscaped" or
    getCalleeName() = "checkStripped" or
    getCalleeName() = "checkNotEscaped"
  }

  predicate shouldBeSanitizer() { getCalleeName() != "checkNotEscaped" }

  string getMessage() {
    if shouldBeSanitizer() and not getArgument(0) instanceof HtmlSanitizerCall
    then result = "Should be marked as sanitizer"
    else
      if not shouldBeSanitizer() and getArgument(0) instanceof HtmlSanitizerCall
      then result = "Should not be marked as sanitizer"
      else result = "OK"
  }
}

from Assertion assertion
select assertion, assertion.getMessage()
