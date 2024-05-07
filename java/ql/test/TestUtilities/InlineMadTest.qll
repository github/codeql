import java as J

private signature module InlineMadTestLangSig {
  /**
   * A base class of callables for modeling.
   */
  class Callable;

  /**
   * Gets a relevant code comment for `c`, if any.
   */
  string getComment(Callable c);
}

private module InlineMadTestImpl<InlineMadTestLangSig Lang> {
  private class Callable = Lang::Callable;

  signature module InlineMadTestConfigSig {
    /**
     * Gets the kind of a captured model.
     */
    string getKind();

    /**
     * Gets a captured model for `c`, if any.
     */
    string getCapturedModel(Callable c);
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

private module InlineMadTestLang implements InlineMadTestLangSig {
  class Callable = J::Callable;

  string getComment(Callable c) {
    exists(J::Javadoc doc |
      hasJavadoc(c, doc) and
      isNormalComment(doc) and
      result = doc.getChild(0).toString()
    )
  }
}

import InlineMadTestImpl<InlineMadTestLang>
