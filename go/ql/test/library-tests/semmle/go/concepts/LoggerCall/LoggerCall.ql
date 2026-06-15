import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module LoggerTest implements TestSig {
  string getARelevantTag() { result = ["type-logger", "logger"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(LoggerCall log |
      log.getLocation() = location and
      element = log.toString() and
      (
        value = log.getAValueFormattedMessageComponent().toString() and
        tag = "logger"
        or
        value = log.getAMessageComponent().toString() and
        not value = log.getAValueFormattedMessageComponent().toString() and
        tag = "type-logger"
      )
    )
  }
}

import MakeTest<LoggerTest>
