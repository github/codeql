import java

private signature module InlineMadTestLangSig {
  /**
   * Gets a relevant code comment, if any.
   */
  string getComment();
}

signature module InlineMadTestConfigSig {
  /**
   * Gets the kind of the captured model.
   */
  string getKind();

  /**
   * Gets a captured model, if any.
   */
  string getCapturedModel();
}

private module InlineMadTestImpl<InlineMadTestLangSig Lang, InlineMadTestConfigSig Input> {
  private string expects() {
    Lang::getComment().regexpCapture(" *(SPURIOUS-)?" + Input::getKind() + "=(.*)", 2) = result
  }

  query predicate unexpectedModel(string msg) {
    exists(string flow |
      flow = Input::getCapturedModel() and
      not flow = expects() and
      msg = "Unexpected " + Input::getKind() + " found: " + flow
    )
  }

  query predicate expectedModel(string msg) {
    exists(string e |
      e = expects() and
      not e = Input::getCapturedModel() and
      msg = "Expected " + Input::getKind() + " missing: " + e
    )
  }
}

private module InlineMadTestLang implements InlineMadTestLangSig {
  string getComment() { result = any(Javadoc doc).getChild(0).toString() }
}

module InlineMadTest<InlineMadTestConfigSig Input> {
  import InlineMadTestImpl<InlineMadTestLang, Input>
}
