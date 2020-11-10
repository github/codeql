/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe jQuery plugins, as well as extension points for adding your
 * own.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
import semmle.javascript.security.dataflow.Xss

module UnsafeJQueryPlugin {
  private import DataFlow::FlowLabel

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
   * An argument that may act as a HTML fragment rather than a CSS selector, as a sink for remote unsafe jQuery plugins.
   */
  class AmbiguousHtmlOrSelectorArgument extends DataFlow::Node,
    DomBasedXss::JQueryHtmlOrSelectorArgument {
    AmbiguousHtmlOrSelectorArgument() {
      // any fixed prefix makes the call unambiguous
      not exists(getAPrefix())
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
          getName().regexpMatch(optionsPattern) and
          this = method.getAParameter()
        ) else (
          // ... otherwise, use the last parameter, unless it looks like a DOM node
          this = method.getLastParameter() and
          not getName().regexpMatch("(?i)(e(l(em(ent(s)?)?)?)?)")
        )
      )
    }

    /**
     * Gets the plugin method that these options are used in.
     */
    JQuery::JQueryPluginMethod getPlugin() { result = method }
  }

  /**
   * Expression of form `isElement(x)`, which sanitizes `x`.
   */
  class IsElementSanitizer extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
    IsElementSanitizer() {
      // common ad hoc sanitizing calls
      exists(string name | getCalleeName() = name |
        name = "isElement" or name = "isDocument" or name = "isWindow"
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = true and e = getArgument(0).asExpr()
    }
  }

  /**
   * Expression like `typeof x.<?> !== "undefined"` or `x.<?>`, which sanitizes `x`, as it is unlikely to be a string afterwards.
   */
  class PropertyPresenceSanitizer extends TaintTracking::SanitizerGuardNode, DataFlow::ValueNode {
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
          exists(Expr op1, Expr op2 | test.hasOperands(op1, op2) |
            read.asExpr() = op1.(TypeofExpr).getOperand() and
            op2.mayHaveStringValue(any(InferredType t | t = TTUndefined()).getTypeofTag())
          )
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

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = polarity and
      e = input.asExpr()
    }
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
   * An argument that may act as a HTML fragment rather than a CSS selector, as a sink for remote unsafe jQuery plugins.
   */
  class AmbiguousHtmlOrSelectorArgumentAsSink extends Sink {
    AmbiguousHtmlOrSelectorArgumentAsSink() {
      this instanceof AmbiguousHtmlOrSelectorArgument and not isLikelyIntentionalHtmlSink(this)
    }
  }

  /**
   * A hint that a value is expected to be treated as a HTML fragment later.
   */
  class IntentionalHtmlFragmentHint extends Sanitizer {
    IntentionalHtmlFragmentHint() {
      this.(DataFlow::PropRead).getPropertyName().regexpMatch("(?i).*(html|template).*")
    }
  }

  /**
   * Holds if there exists a jQuery plugin that likely expects `sink` to be treated as a HTML fragment.
   */
  predicate isLikelyIntentionalHtmlSink(DataFlow::Node sink) {
    exists(
      JQuery::JQueryPluginMethod plugin, DataFlow::PropWrite defaultDef,
      DataFlow::PropRead finalRead
    |
      hasDefaultOption(plugin, defaultDef) and
      defaultDef = getALikelyHTMLWrite(finalRead.getPropertyName()) and
      finalRead.flowsTo(sink) and
      sink.getTopLevel() = plugin.getTopLevel()
    )
  }

  /**
   * Gets a property-write that writes a HTML-like constant string to `prop`.
   */
  pragma[noinline]
  private DataFlow::PropWrite getALikelyHTMLWrite(string prop) {
    exists(string default |
      result.getRhs().mayHaveStringValue(default) and
      default.regexpMatch("\\s*<.*") and
      result.getPropertyName() = prop
    )
  }
}
