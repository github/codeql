/**
 * Provides classes for modeling string formatting libraries.
 */

import javascript

/**
 * A printf-style call that substitutes the embedded format specifiers of a format string for the format arguments.
 */
abstract class PrintfStyleCall extends DataFlow::CallNode {
  /**
   * Gets the format string.
   */
  abstract DataFlow::Node getFormatString();

  /**
   * Gets the ith argument to the format string.
   */
  abstract DataFlow::Node getFormatArgument(int i);

  /**
   * Holds if this call returns the formatted string.
   */
  abstract predicate returnsFormatted();
}

private class LibraryFormatter extends PrintfStyleCall {
  int formatIndex;
  boolean returns;

  LibraryFormatter() {
    // built-in Node.js functions
    exists(string mod, string meth |
      returns = false and
      mod = "console" and
      (
        (
          meth = "debug" or
          meth = "error" or
          meth = "info" or
          meth = "log" or
          meth = "trace" or
          meth = "warn"
        ) and
        formatIndex = 0
        or
        meth = "assert" and formatIndex = 1
      )
      or
      returns = true and
      mod = "util" and
      (
        (meth = "format" or meth = "log") and
        formatIndex = 0
        or
        meth = "formatWithOptions" and formatIndex = 1
      )
    |
      // `console` and `util` are available both as modules...
      this = DataFlow::moduleMember(mod, meth).getACall()
      or
      // ...and as globals
      this = DataFlow::globalVarRef(mod).getAMemberCall(meth)
    )
    or
    returns = true and
    (
      // https://www.npmjs.com/package/printf
      this = DataFlow::moduleImport("printf").getACall() and
      formatIndex in [0 .. 1]
      or
      // https://www.npmjs.com/package/printj
      exists(string fn | fn = "sprintf" or fn = "vsprintf" |
        this = DataFlow::moduleMember("printj", fn).getACall() and
        formatIndex = 0
      )
      or
      // https://www.npmjs.com/package/format-util
      this = DataFlow::moduleImport("format-util").getACall() and
      formatIndex = 0
      or
      // https://www.npmjs.com/package/string-template
      this = DataFlow::moduleImport("string-template").getACall() and
      formatIndex = 0
      or
      this = DataFlow::moduleImport("string-template/compile").getACall() and
      formatIndex = 0
      or
      // https://www.npmjs.com/package/sprintf-js
      exists(string meth | meth = "sprintf" or meth = "vsprintf" |
        this = DataFlow::moduleMember("sprintf-js", meth).getACall() and
        formatIndex = 0
      )
    )
  }

  override DataFlow::Node getFormatString() { result = getArgument(formatIndex) }

  override DataFlow::Node getFormatArgument(int i) {
    i >= 0 and
    result = getArgument(formatIndex + 1 + i)
  }

  override predicate returnsFormatted() { returns = true }
}
