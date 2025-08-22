/**
 * Provides some simple predicates for models as data related tests using
 * inline expectations (as comments in the source code).
 */
signature module InlineMadTestLangSig {
  /**
   * A base class of callables for modeling.
   */
  class Callable;

  /**
   * Gets a relevant code comment for `c`, if any.
   */
  string getComment(Callable c);
}

module InlineMadTestImpl<InlineMadTestLangSig Lang> {
  private class Callable = Lang::Callable;

  signature module InlineMadTestConfigSig {
    /**
     * Gets a captured model for `c`, if any.
     */
    string getCapturedModel(Callable c);

    /**
     * Gets the kind of a captured model.
     */
    string getKind();
  }

  module InlineMadTest<InlineMadTestConfigSig Input> {
    private string expects(Callable c) {
      Lang::getComment(c).regexpCapture(" *(SPURIOUS-)?" + Input::getKind() + "=(.*)", 2) = result
    }

    query predicate unexpectedModel(string msg) {
      exists(Callable c, string flow |
        flow = Input::getCapturedModel(c) and
        not flow = expects(c) and
        msg = "Unexpected " + Input::getKind() + " found: " + flow
      )
    }

    query predicate expectedModel(string msg) {
      exists(Callable c, string e |
        e = expects(c) and
        not e = Input::getCapturedModel(c) and
        msg = "Expected " + Input::getKind() + " missing: " + e
      )
    }
  }
}
