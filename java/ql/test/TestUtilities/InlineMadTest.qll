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
  bindingset[kind]
  private string expects(string kind) {
    Input::getComment().regexpCapture(" *(SPURIOUS-)?" + kind + "=(.*)", 2) = result
  }

  query predicate unexpectedSummary(string msg) {
    exists(string flow |
      flow = Input::getCapturedSummary() and
      not flow = expects("summary") and
      msg = "Unexpected summary found: " + flow
    )
  }

  query predicate expectedSummary(string msg) {
    exists(string e |
      e = expects("summary") and
      not e = Input::getCapturedSummary() and
      msg = "Expected summary missing: " + e
    )
  }
}
