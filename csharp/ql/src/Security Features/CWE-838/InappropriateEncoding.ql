/**
 * @name Inappropriate encoding
 * @description Using an inappropriate encoding may give unintended results and may
 *              pose a security risk.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision low
 * @id cs/inappropriate-encoding
 * @tags security
 *       external/cwe/cwe-838
 */

import csharp
import semmle.code.csharp.frameworks.System
import semmle.code.csharp.frameworks.system.Net
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.frameworks.system.web.UI
import semmle.code.csharp.security.dataflow.SqlInjectionQuery as SqlInjection
import semmle.code.csharp.security.dataflow.flowsinks.Html
import semmle.code.csharp.security.dataflow.UrlRedirectQuery as UrlRedirect
import semmle.code.csharp.security.Sanitizers
import EncodingConfigurations::Flow::PathGraph

signature module EncodingConfigSig {
  /** Holds if `n` is a node whose value must be encoded. */
  predicate requiresEncoding(DataFlow::Node n);

  /** Holds if `e` is a possible valid encoded value. */
  predicate isPossibleEncodedValue(Expr e);
}

/**
 * A configuration for specifying expressions that must be encoded.
 */
module RequiresEncodingConfig<EncodingConfigSig EncodingConfig> implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // all encoded values that do not match this configuration are
    // considered sources
    exists(Expr e | e = source.asExpr() |
      e instanceof EncodedValue and
      not EncodingConfig::isPossibleEncodedValue(e)
    )
  }

  predicate isSink(DataFlow::Node sink) { EncodingConfig::requiresEncoding(sink) }

  predicate isBarrier(DataFlow::Node sanitizer) {
    EncodingConfig::isPossibleEncodedValue(sanitizer.asExpr())
  }

  int fieldFlowBranchLimit() { result = 0 }
}

/** An encoded value, for example through a call to `HttpServerUtility.HtmlEncode`. */
class EncodedValue extends Expr {
  EncodedValue() {
    EncodingConfigurations::SqlExprEncodingConfig::isPossibleEncodedValue(this)
    or
    EncodingConfigurations::HtmlExprEncodingConfig::isPossibleEncodedValue(this)
    or
    EncodingConfigurations::UrlExprEncodingConfig::isPossibleEncodedValue(this)
    or
    this = any(SystemWebHttpUtility c).getAJavaScriptStringEncodeMethod().getACall()
    or
    // Also try to identify user-defined encoders, which are likely wrong
    exists(Method m, string name, string regexp |
      this.(MethodCall).getTarget() = m and
      m.fromSource() and
      m.getName().toLowerCase() = name and
      name.toLowerCase().regexpMatch(regexp) and
      regexp = ".*(encode|saniti(s|z)e|cleanse|escape).*"
    )
  }
}

module EncodingConfigurations {
  module SqlExprEncodingConfig implements EncodingConfigSig {
    predicate requiresEncoding(DataFlow::Node n) { n instanceof SqlInjection::Sink }

    predicate isPossibleEncodedValue(Expr e) { none() }
  }

  /** An encoding configuration for SQL expressions. */
  module SqlExprConfig implements DataFlow::ConfigSig {
    import RequiresEncodingConfig<SqlExprEncodingConfig> as Super

    // no override for `isPossibleEncodedValue` as SQL parameters should
    // be used instead of explicit encoding
    predicate isSource(DataFlow::Node source) {
      Super::isSource(source)
      or
      // consider quote-replacing calls as additional sources for
      // SQL expressions (e.g., `s.Replace("\"", "\"\"")`)
      source.asExpr() =
        any(MethodCall mc |
          mc.getTarget() = any(SystemStringClass c).getReplaceMethod() and
          mc.getArgument(0).getValue().regexpMatch("\"|'|`")
        )
    }

    predicate isSink = Super::isSink/1;

    predicate isBarrier = Super::isBarrier/1;

    int fieldFlowBranchLimit() { result = Super::fieldFlowBranchLimit() }
  }

  module SqlExpr = TaintTracking::Global<SqlExprConfig>;

  module HtmlExprEncodingConfig implements EncodingConfigSig {
    predicate requiresEncoding(DataFlow::Node n) { n instanceof HtmlSink }

    predicate isPossibleEncodedValue(Expr e) { e instanceof HtmlSanitizedExpr }
  }

  /** An encoding configuration for HTML expressions. */
  module HtmlExprConfig = RequiresEncodingConfig<HtmlExprEncodingConfig>;

  module HtmlExpr = TaintTracking::Global<HtmlExprConfig>;

  module UrlExprEncodingConfig implements EncodingConfigSig {
    predicate requiresEncoding(DataFlow::Node n) { n instanceof UrlRedirect::Sink }

    predicate isPossibleEncodedValue(Expr e) { e instanceof UrlSanitizedExpr }
  }

  /** An encoding configuration for URL expressions. */
  module UrlExprConfig = RequiresEncodingConfig<UrlExprEncodingConfig>;

  module UrlExpr = TaintTracking::Global<UrlExprConfig>;

  module Flow =
    DataFlow::MergePathGraph3<SqlExpr::PathNode, HtmlExpr::PathNode, UrlExpr::PathNode,
      SqlExpr::PathGraph, HtmlExpr::PathGraph, UrlExpr::PathGraph>;

  /**
   * Holds if `encodedValue` is a possibly ill-encoded value that reaches
   * `sink`, where `sink` is an expression of kind `kind` that is required
   * to be encoded.
   */
  predicate hasWrongEncoding(Flow::PathNode encodedValue, Flow::PathNode sink, string kind) {
    SqlExpr::flowPath(encodedValue.asPathNode1(), sink.asPathNode1()) and
    kind = "SQL expression"
    or
    HtmlExpr::flowPath(encodedValue.asPathNode2(), sink.asPathNode2()) and
    kind = "HTML expression"
    or
    UrlExpr::flowPath(encodedValue.asPathNode3(), sink.asPathNode3()) and
    kind = "URL expression"
  }
}

from
  EncodingConfigurations::Flow::PathNode encodedValue, EncodingConfigurations::Flow::PathNode sink,
  string kind
where EncodingConfigurations::hasWrongEncoding(encodedValue, sink, kind)
select sink.getNode(), encodedValue, sink, "This " + kind + " may include data from a $@.",
  encodedValue.getNode(), "possibly inappropriately encoded value"
