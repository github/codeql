/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe jQuery plugins, as well as extension points for adding your
 * own.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
import semmle.javascript.security.dataflow.DomBasedXssCustomizations

module UnsafeJQueryPlugin {
  /**
   * A data flow source for unsafe jQuery plugins.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the plugin that this source is used in.
     */
    abstract JQuery::JQueryPluginMethod getPlugin();
  }

  /**
   * A data flow sink for unsafe jQuery plugins.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for unsafe jQuery plugins.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A barrier guard for XSS in unsafe jQuery plugins.
   */
  abstract class BarrierGuard extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for data flow, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e) { none() }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }
  }

  /** A subclass of `BarrierGuard` that is used for backward compatibility with the old data flow library. */
  deprecated final private class BarrierGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof BarrierGuard
  {
    override predicate sanitizes(boolean outcome, Expr e) {
      BarrierGuard.super.sanitizes(outcome, e)
    }
  }

  /**
   * The receiver of a function, seen as a sanitizer.
   *
   * Plugins often do `$(this)` to coerce an existing DOM element to a jQuery object.
   */
  private class ThisSanitizer extends Sanitizer instanceof DataFlow::ThisNode { }

  /**
   * An argument that may act as an HTML fragment rather than a CSS selector, as a sink for remote unsafe jQuery plugins.
   */
  class AmbiguousHtmlOrSelectorArgument extends DataFlow::Node,
    DomBasedXss::JQueryHtmlOrSelectorArgument
  {
    AmbiguousHtmlOrSelectorArgument() {
      // any fixed prefix makes the call unambiguous
      not exists(this.getAPrefix())
    }
  }

  /**
   * Gets an operand to `extend`.
   */
  private DataFlow::SourceNode getAnExtendOperand(DataFlow::TypeBackTracker t, ExtendCall extend) {
    t.start() and
    result.flowsTo(extend.getAnOperand())
    or
    exists(DataFlow::TypeBackTracker t2 | result = getAnExtendOperand(t2, extend).backtrack(t2, t))
  }

  /**
   * Gets an operand to `extend`.
   */
  private DataFlow::SourceNode getAnExtendOperand(ExtendCall extend) {
    result = getAnExtendOperand(DataFlow::TypeBackTracker::end(), extend)
  }

  /**
   * Holds if `plugin` has a default option defined at `def`.
   */
  private predicate hasDefaultOption(JQuery::JQueryPluginMethod plugin, DataFlow::PropWrite def) {
    exists(ExtendCall extend, JQueryPluginOptions options, DataFlow::SourceNode default |
      options.getPlugin() = plugin and
      options = getAnExtendOperand(extend) and
      default = getAnExtendOperand(extend) and
      default.getAPropertyWrite() = def
    )
  }

  /**
   * The client-provided options object for a jQuery plugin.
   */
  class JQueryPluginOptions extends DataFlow::ParameterNode {
    JQuery::JQueryPluginMethod method;

    JQueryPluginOptions() {
      exists(string optionsPattern |
        optionsPattern = "(?i)(opt(ion)?s?)" and
        if method.getAParameter().getName().regexpMatch(optionsPattern)
        then (
          // use the last parameter named something like "options" if it exists ...
          this.getName().regexpMatch(optionsPattern) and
          this = method.getAParameter()
        ) else (
          // ... otherwise, use the last parameter, unless it looks like a DOM node
          this = method.getLastParameter() and
          not this.getName().regexpMatch("(?i)(e(l(em(ent(s)?)?)?)?)")
        )
      )
    }

    /**
     * Gets the plugin method that these options are used in.
     */
    JQuery::JQueryPluginMethod getPlugin() { result = method }
  }

  /**
   * An expression of form `isElement(x)`, which sanitizes `x`.
   */
  class IsElementSanitizer extends BarrierGuard, DataFlow::CallNode {
    IsElementSanitizer() {
      // common ad hoc sanitizing calls
      exists(string name | this.getCalleeName() = name |
        name = "isElement" or name = "isDocument" or name = "isWindow"
      )
    }

    override predicate blocksExpr(boolean outcome, Expr e) {
      outcome = true and e = this.getArgument(0).asExpr()
    }
  }

  /**
   * An expression like `typeof x.<?> !== "undefined"` or `x.<?>`, which sanitizes `x`, as it is unlikely to be a string afterwards.
   */
  class PropertyPresenceSanitizer extends BarrierGuard, DataFlow::ValueNode {
    DataFlow::Node input;
    boolean polarity;

    PropertyPresenceSanitizer() {
      exists(DataFlow::PropRead read, string name |
        not name = "length" and read.accesses(input, name)
      |
        exists(EqualityTest test |
          polarity = test.getPolarity().booleanNot() and
          this = test.flow()
        |
          exists(Expr undef | test.hasOperands(read.asExpr(), undef) |
            SyntacticConstants::isUndefined(undef)
          )
          or
          TaintTracking::isTypeofGuard(test, read.asExpr(), "undefined")
        )
        or
        polarity = true and
        this = read
      )
    }

    /**
     * Gets the property read that is used to sanitize the base value.
     */
    DataFlow::PropRead getPropRead() { result = this }

    override predicate blocksExpr(boolean outcome, Expr e) {
      outcome = polarity and
      e = input.asExpr()
    }
  }

  /** A guard that checks whether `x` is a number. */
  class NumberGuard extends BarrierGuard instanceof DataFlow::CallNode {
    Expr x;
    boolean polarity;

    NumberGuard() { TaintTracking::isNumberGuard(this, x, polarity) }

    override predicate blocksExpr(boolean outcome, Expr e) { e = x and outcome = polarity }
  }

  /**
   * The client-provided options object for a jQuery plugin, considered as a source for unsafe jQuery plugins.
   */
  class JQueryPluginOptionsAsSource extends Source, JQueryPluginOptions {
    override JQuery::JQueryPluginMethod getPlugin() {
      result = JQueryPluginOptions.super.getPlugin()
    }
  }

  /**
   * An argument that may act as an HTML fragment rather than a CSS selector, as a sink for remote unsafe jQuery plugins.
   */
  class AmbiguousHtmlOrSelectorArgumentAsSink extends Sink instanceof AmbiguousHtmlOrSelectorArgument
  {
    AmbiguousHtmlOrSelectorArgumentAsSink() { not isLikelyIntentionalHtmlSink(this) }
  }

  /**
   * A hint that a value is expected to be treated as an HTML fragment later.
   */
  class IntentionalHtmlFragmentHint extends Sanitizer {
    IntentionalHtmlFragmentHint() {
      this.(DataFlow::PropRead).getPropertyName().regexpMatch("(?i).*(html|template).*")
    }
  }

  /**
   * Holds if there exists a jQuery plugin that likely expects `sink` to be treated as an HTML fragment.
   */
  predicate isLikelyIntentionalHtmlSink(DataFlow::Node sink) {
    exists(
      JQuery::JQueryPluginMethod plugin, DataFlow::PropWrite defaultDef,
      DataFlow::PropRead finalRead
    |
      hasDefaultOption(plugin, defaultDef) and
      defaultDef = getALikelyHtmlWrite(finalRead.getPropertyName()) and
      finalRead.flowsTo(sink) and
      sink.getTopLevel() = plugin.getTopLevel()
    )
  }

  /**
   * Gets a property-write that writes an HTML-like constant string to `prop`.
   */
  pragma[noinline]
  private DataFlow::PropWrite getALikelyHtmlWrite(string prop) {
    exists(string default |
      result.getRhs().mayHaveStringValue(default) and
      default.regexpMatch("\\s*<.*") and
      result.getPropertyName() = prop
    )
  }
}
