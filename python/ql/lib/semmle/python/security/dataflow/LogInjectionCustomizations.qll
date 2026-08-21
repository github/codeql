/**
 * Provides default sources, sinks and sanitizers for detecting
 * "log injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.security.Sanitizers

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "log injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module LogInjection {
  /**
   * A data flow source for "log injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "log injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "log injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A logging operation, considered as a flow sink.
   */
  class LoggingAsSink extends Sink {
    LoggingAsSink() {
      this = any(Logging write).getAnInput() and
      // since the inner implementation of the `logging.Logger.warn` function is
      // ```py
      // class Logger:
      //     def warn(self, msg, *args, **kwargs):
      //         warnings.warn("The 'warn' method is deprecated, "
      //             "use 'warning' instead", DeprecationWarning, 2)
      //         self.warning(msg, *args, **kwargs)
      // ```
      // any time we would report flow to such a logging sink, we can ALSO report
      // the flow to the `self.warning` sink -- obviously we don't want that.
      //
      // However, simply removing taint edges out of a sink is not a good enough solution,
      // since we would only flag one of the `logging.info` calls in the following example
      // due to use-use flow
      // ```py
      // logger.warn(user_controlled)
      // logger.warn(user_controlled)
      // ```
      //
      // The same approach is used in the command injection query.
      not exists(Module loggingInit |
        loggingInit.getName() = "logging.__init__" and
        this.getScope().getEnclosingModule() = loggingInit and
        // do allow this call if we're analyzing logging/__init__.py as part of CPython though
        not exists(loggingInit.getFile().getRelativePath())
      )
    }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { ModelOutput::sinkNode(this, "log-injection") }
  }

  /**
   * A value of a simple type, such as an `int` or a `uuid.UUID`, considered as a
   * sanitizer.
   *
   * Such a value has a machine-generated string representation that can never
   * contain a line break, so it cannot be used to forge a log entry. The Java and
   * C# log injection queries use the same sanitizer.
   */
  class SimpleTypeAsSanitizer extends Sanitizer instanceof SimpleTypeSanitizer { }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }

  /** DEPRECATED: Use ConstCompareAsSanitizerGuard instead. */
  deprecated class StringConstCompareAsSanitizerGuard = ConstCompareAsSanitizerGuard;

  /**
   * A call to replace line breaks, considered as a sanitizer.
   */
  class ReplaceLineBreaksSanitizer extends Sanitizer, DataFlow::CallCfgNode {
    // Note: This sanitizer is not 100% accurate, since:
    // - we do not check that all kinds of line breaks are replaced
    // - we do not check that one kind of line breaks is not replaced by another
    //
    // However, we lack a simple way to do better, and the query would likely
    // be too noisy without this.
    //
    // TODO: Consider rewriting using flow states.
    ReplaceLineBreaksSanitizer() {
      this.getFunction().(DataFlow::AttrRead).getAttributeName() = "replace" and
      this.getArg(0).asExpr().(StringLiteral).getText() in ["\r\n", "\n"]
    }
  }

  /**
   * Gets the pattern of a call to `re.sub` or `re.subn`, whether the pattern is
   * passed directly or was compiled with `re.compile`.
   */
  private string getARegexSubstitutionPattern(DataFlow::CallCfgNode call) {
    call = API::moduleImport("re").getMember(["sub", "subn"]).getACall() and
    result = call.getArg(0).asExpr().(StringLiteral).getText()
    or
    exists(API::CallNode compile |
      compile = API::moduleImport("re").getMember("compile").getACall() and
      call = compile.getReturn().getMember(["sub", "subn"]).getACall() and
      result = compile.getArg(0).asExpr().(StringLiteral).getText()
    )
  }

  /**
   * Holds if `call` removes or escapes the characters that could be used to forge a
   * log entry.
   *
   * Like `ReplaceLineBreaksSanitizer`, this is deliberately generous: we do not
   * verify that every kind of line break is handled, only that the value has been
   * put through an operation whose purpose is to neutralize them.
   */
  private predicate stripsControlCharacters(DataFlow::CallCfgNode call) {
    exists(string method | method = call.getFunction().(DataFlow::AttrRead).getAttributeName() |
      // `x.replace("\n", "")`
      method = "replace" and
      call.getArg(0).asExpr().(StringLiteral).getText() in ["\r\n", "\n", "\r"]
      or
      // `x.translate(table)`. The table is assumed to escape control characters, as
      // `str.translate` has no other common use on a log message.
      method = "translate"
      or
      // `x.encode("unicode_escape")`
      method = "encode" and
      call.getArg(0).asExpr().(StringLiteral).getText() = "unicode_escape"
    )
    or
    // A substitution whose pattern mentions a line break or a control character class.
    getARegexSubstitutionPattern(call)
        .matches(["%\\n%", "%\\r%", "%\\x0%", "%\\s%", "%cntrl%", "%\n%"])
    or
    // Conversions that render a control character inert by escaping it.
    call = API::builtin(["repr", "ascii"]).getACall()
    or
    call = API::moduleImport("json").getMember("dumps").getACall()
    or
    call = API::moduleImport("urllib.parse").getMember(["quote", "quote_plus"]).getACall()
  }

  /**
   * A call that strips control characters from its input, considered as a sanitizer.
   *
   * This subsumes `ReplaceLineBreaksSanitizer`, which is retained because it is part
   * of the public API of this module.
   */
  class StripControlCharactersSanitizer extends Sanitizer, DataFlow::CallCfgNode {
    StripControlCharactersSanitizer() { stripsControlCharacters(this) }
  }

  /**
   * Gets a callable that `call` may invoke, where the callable is defined in the
   * module being analyzed.
   *
   * Local flow does not cross a scope boundary, so a module-level definition that is
   * referenced from inside a function or a method has to be resolved by name.
   */
  private Scope getALocallyResolvedCallee(DataFlow::CallCfgNode call) {
    exists(DataFlow::LocalSourceNode callee | callee.flowsTo(call.getFunction()) |
      callee.asExpr() = result.(Function).getDefinition()
      or
      callee.asExpr().(ClassExpr).getInnerScope() = result
    )
    or
    exists(DataFlow::ModuleVariableNode var |
      var.getARead() = call.getFunction() and
      result.getName() = var.getVariable().getId() and
      result.getEnclosingScope() = var.getModule()
    )
  }

  /** Gets a method of `cls` that renders a log record. */
  private Function getARecordRenderingMethod(Class cls) {
    result = cls.getAMethod() and
    result.getName() in ["format", "formatMessage"]
  }

  /**
   * Gets a function called, directly or indirectly, from the record-rendering method
   * `f`.
   *
   * Only calls that resolve to a definition in the module being analyzed are
   * followed, which covers the common case of a formatter delegating to a helper
   * defined alongside it.
   */
  private Function getATransitiveCallee(Function f) {
    f = getARecordRenderingMethod(_) and
    result = f
    or
    exists(DataFlow::CallCfgNode call |
      call.getScope() = getATransitiveCallee(f) and
      result = getALocallyResolvedCallee(call)
    )
  }

  /**
   * Holds if `cls` is a `logging.Formatter` subclass that strips control characters
   * from the records it renders.
   *
   * Such a formatter sanitizes when the record is written rather than where it is
   * created, so no sanitizing call appears between the source and the logging call.
   */
  private predicate isSanitizingFormatter(Class cls) {
    cls.getABase() =
      API::moduleImport("logging").getMember("Formatter").getAValueReachableFromSource().asExpr() and
    exists(DataFlow::CallCfgNode strip |
      stripsControlCharacters(strip) and
      strip.getScope() = getATransitiveCallee(getARecordRenderingMethod(cls))
    )
  }

  /**
   * Holds if a `logging.Formatter` that strips control characters is installed on a
   * handler.
   *
   * This is a property of the application as a whole rather than of an individual
   * logging call. We do not determine which loggers the formatter ends up attached
   * to, as that would require resolving handler registration, which is typically
   * spread across module-level configuration code and often iterates over
   * `logging.getLogger().handlers`. Such a formatter is nearly always installed on
   * the root logger, where it applies to every record that propagates to it, so its
   * presence is treated as sanitizing all logging calls. The trade-off is a false
   * negative for an application that also logs through a deliberately unsanitized
   * handler.
   */
  private predicate hasSanitizingFormatter() {
    exists(DataFlow::MethodCallNode setFormatter, DataFlow::CallCfgNode instantiation |
      setFormatter.getMethodName() = "setFormatter" and
      instantiation.flowsTo(setFormatter.getArg(0)) and
      isSanitizingFormatter(getALocallyResolvedCallee(instantiation))
    )
  }

  /**
   * A logging operation in an application that installs a `logging.Formatter`
   * stripping control characters, considered as a sanitizer.
   */
  class LoggingSanitizedByFormatter extends Sanitizer {
    LoggingSanitizedByFormatter() {
      hasSanitizingFormatter() and
      this instanceof LoggingAsSink
    }
  }

  /**
   * A sanitizer defined via models-as-data with kind "log-injection".
   */
  class SanitizerFromModel extends Sanitizer {
    SanitizerFromModel() { ModelOutput::barrierNode(this, "log-injection") }
  }
}
