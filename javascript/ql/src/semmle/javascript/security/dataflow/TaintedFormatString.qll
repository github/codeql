/**
 * Provides a taint-tracking configuration for reasoning about format injections.
 */

import javascript
import semmle.javascript.security.dataflow.DOM

module TaintedFormatString {
  /**
   * A data flow source for format injections.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for format injections.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for format injections.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for format injections.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() {
      this = "TaintedFormatString"
    }

    override
    predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override
    predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override
    predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  /** A source of remote user input, considered as a flow source for format injection. */
  class RemoteSource extends Source {
    RemoteSource() {
      this instanceof RemoteFlowSource
    }
  }

  /**
   * A format argument to a printf-like function, considered as a flow sink for format injection.
   */
  class FormatSink extends Sink {
    FormatSink() {
      exists (DataFlow::CallNode call, int argIdx |
        // built-in Node.js functions
        exists (string mod, string meth |
          mod = "console" and
          (meth = "debug" or meth = "error" or meth = "info" or
           meth = "log" or meth = "trace" or meth = "warn") and
          argIdx = 0
          or
          mod = "console" and meth = "assert" and argIdx = 1
          or
          mod = "util" and (meth = "format" or meth = "log") and argIdx = 0
          or
          mod = "util" and meth = "formatWithOptions" and argIdx = 1
          |
          // `console` and `util` are available both as modules...
          call = DataFlow::moduleMember(mod, meth).getACall()
          or
          // ...and as globals
          call = DataFlow::globalVarRef(mod).getAMemberCall(meth)
        )
        or
        // https://www.npmjs.com/package/printf
        call = DataFlow::moduleImport("printf").getACall() and
        argIdx in [0..1]
        or
        // https://www.npmjs.com/package/printj
        exists (string fn | fn = "sprintf" or fn = "vsprintf" |
          call = DataFlow::moduleMember("printj", fn).getACall() and
          argIdx = 0
        )
        or
        // https://www.npmjs.com/package/format-util
        call = DataFlow::moduleImport("format-util").getACall() and
        argIdx = 0
        or
        // https://www.npmjs.com/package/string-template
        call = DataFlow::moduleImport("string-template").getACall() and
        argIdx = 0
        or
        call = DataFlow::moduleImport("string-template/compile").getACall() and
        argIdx = 0
        or
        // https://www.npmjs.com/package/sprintf-js
        exists (string meth | meth = "sprintf" or meth = "vsprintf" |
          call = DataFlow::moduleMember("sprintf-js", meth).getACall() and
          argIdx = 0
        )
        |
        this = call.getArgument(argIdx) and
        // exclude trivial case where there are no arguments to interpolate
        exists(call.getArgument(argIdx+1))
      )
    }
  }
}
