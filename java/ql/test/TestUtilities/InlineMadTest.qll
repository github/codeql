import java

private signature module InlineMadTestLangSig {
  /**
   * Gets a relevant code comment for `c`, if any.
   */
  string getComment(Callable c);
}

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

private module InlineMadTestImpl<InlineMadTestLangSig Lang, InlineMadTestConfigSig Input> {
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

private module InlineMadTestLang implements InlineMadTestLangSig {
  string getComment(Callable c) {
    exists(Javadoc doc |
      hasJavadoc(c, doc) and
      isNormalComment(doc) and
      result = doc.getChild(0).toString()
    )
  }
}

module InlineMadTest<InlineMadTestConfigSig Input> {
  import InlineMadTestImpl<InlineMadTestLang, Input>
}
