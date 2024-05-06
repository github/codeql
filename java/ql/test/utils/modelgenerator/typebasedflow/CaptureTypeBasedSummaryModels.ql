import java
import utils.modelgenerator.internal.CaptureTypeBasedSummaryModels

signature module InlineMadTestConfigSig {
  /**
   * Gets a relevant code comment, if any.
   */
  string getComment();

  /**
   * Gets an identified summary, if any.
   */
  string getCapturedSummary();
}

module InlineMadTest<InlineMadTestConfigSig Input> {
  private string expects() {
    Input::getComment().regexpCapture(" *(SPURIOUS-)?MaD=(.*)", 2) = result
  }

  query predicate unexpectedSummary(string msg) {
    exists(string flow |
      flow = Input::getCapturedSummary() and
      not flow = expects() and
      msg = "Unexpected summary found: " + flow
    )
  }

  query predicate expectedSummary(string msg) {
    exists(string e |
      e = expects() and
      not e = Input::getCapturedSummary() and
      msg = "Expected summary missing: " + e
    )
  }
}

module InlineMadTestConfig implements InlineMadTestConfigSig {
  string getComment() { result = any(Javadoc doc).getChild(0).toString() }

  string getCapturedSummary() { result = captureFlow(_) }
}

import InlineMadTest<InlineMadTestConfig>
