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
        meth = ["debug", "error", "info", "log", "trace", "warn"] and
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

/**
 * A taint step through a case changing function.
 */
private class CaseChangingStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::SourceNode callee, DataFlow::CallNode call |
      callee = DataFlow::moduleMember("change-case", _) or
      callee = DataFlow::moduleMember("camel-case", "camelCase") or
      callee = DataFlow::moduleMember("pascal-case", "pascalCase") or
      callee = DataFlow::moduleMember("snake-case", "snakeCase") or
      callee = DataFlow::moduleImport("kebab-case") or
      callee = DataFlow::moduleMember("kebab-case", "reverse") or
      callee = DataFlow::moduleMember("param-case", "paramCase") or
      callee = DataFlow::moduleMember("path-case", "pathCase") or
      callee = DataFlow::moduleMember("sentence-case", "sentenceCase") or
      callee = DataFlow::moduleMember("title-case", "titleCase") or
      callee = DataFlow::moduleMember("upper-case", ["upperCase", "localeUpperCase"]) or
      callee = DataFlow::moduleMember("lower-case", ["lowerCase", "localeLowerCase"]) or
      callee = DataFlow::moduleMember("no-case", "noCase") or
      callee = DataFlow::moduleMember("constant-case", "constantCase") or
      callee = DataFlow::moduleMember("dot-case", "dotCase") or
      callee = DataFlow::moduleMember("upper-case-first", "upperCaseFirst") or
      callee = DataFlow::moduleMember("lower-case-first", "lowerCaseFirst") or
      callee = DataFlow::moduleMember("header-case", "headerCase") or
      callee = DataFlow::moduleMember("capital-case", "capitalCase") or
      callee = DataFlow::moduleMember("swap-case", "swapCase") or
      callee = DataFlow::moduleMember("sponge-case", "spongeCase") or
      callee = DataFlow::moduleImport(["titleize", "camelcase", "decamelize"])
    |
      call = callee.getACall() and
      pred = call.getArgument(0) and
      succ = call
    )
  }
}
