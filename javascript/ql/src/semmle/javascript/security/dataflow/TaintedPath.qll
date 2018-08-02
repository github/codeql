/**
 * Provides a taint tracking configuration for reasoning about tainted-path
 * vulnerabilities.
 */

import javascript

module TaintedPath {
  /**
   * A data flow source for tainted-path vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for tainted-path vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for tainted-path vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about tainted-path vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "TaintedPath" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof StrongPathCheck
    }

  }

  /**
   * A source of remote user input, considered as a flow source for
   * tainted-path vulnerabilities.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An expression whose value is interpreted as a path to a module, making it
   * a data flow sink for tainted-path vulnerabilities.
   */
  class ModulePathSink extends Sink, DataFlow::ValueNode {
    ModulePathSink() {
      astNode = any(Require rq).getArgument(0) or
      astNode = any(ExternalModuleReference rq).getExpression() or
      astNode = any(AMDModuleDefinition amd).getDependencies()
    }
  }

  /**
   * A path argument to a file system access.
   */
  class FsPathSink extends Sink, DataFlow::ValueNode {
    FsPathSink() {
      this = any(FileSystemAccess fs).getAPathArgument()
    }
  }

  /**
   * A path argument to the Express `res.render` method.
   */
  class ExpressRenderSink extends Sink, DataFlow::ValueNode {
    ExpressRenderSink() {
      exists (MethodCallExpr mce |
        Express::isResponse(mce.getReceiver()) and
        mce.getMethodName() = "render" and
        astNode = mce.getArgument(0)
      )
    }
  }

  /**
   * A `templateUrl` member of an AngularJS directive.
   */
  class AngularJSTemplateUrlSink extends Sink, DataFlow::ValueNode {
    AngularJSTemplateUrlSink() {
      this = any(AngularJS::CustomDirective d).getMember("templateUrl")
    }
  }

  /**
   * Holds if `check` evaluating to `outcome` is not sufficient to sanitize `path`.
   */
  predicate weakCheck(Expr check, boolean outcome, VarAccess path) {
    // `path.startsWith`, `path.endsWith`, `fs.existsSync(path)`
    exists (Expr base, string m | check.(MethodCallExpr).calls(base, m) |
      path = base and
      (m = "startsWith" or m = "endsWith")
      or
      path = check.(MethodCallExpr).getArgument(0) and
      m.regexpMatch("exists(Sync)?")
    ) and
    (outcome = true or outcome = false)
    or
    // `path.indexOf` comparisons
    check.(Comparison).getAnOperand().(MethodCallExpr).calls(path, "indexOf") and
    (outcome = true or outcome = false)
    or
    // `path != null`, `path != undefined`, `path != "somestring"`
    exists (EqualityTest eq, Expr op |
      eq = check and eq.hasOperands(path, op) and outcome = eq.getPolarity().booleanNot() |
      op instanceof NullLiteral or
      op instanceof SyntacticConstants::UndefinedConstant or
      exists(op.getStringValue())
    )
    or
    // `path`
    check = path and
    (outcome = true or outcome = false)
  }

  /**
   * A conditional involving the path, that is not considered to be a weak check.
   */
  class StrongPathCheck extends TaintTracking::SanitizerGuardNode {
    VarAccess path;
    boolean sanitizedOutcome;

    StrongPathCheck() {
      exists (ConditionGuardNode cgg | asExpr() = cgg.getTest() |
        asExpr() = path.getParentExpr*() and
        path = any(SsaVariable v).getAUse() and
        (sanitizedOutcome = true or sanitizedOutcome = false) and
        not weakCheck(asExpr(), sanitizedOutcome, path)
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      path = e and
      outcome = sanitizedOutcome
    }
  }
}

/** DEPRECATED: Use `TaintedPath::Source` instead. */
deprecated class TaintedPathSource = TaintedPath::Source;

/** DEPRECATED: Use `TaintedPath::Sink` instead. */
deprecated class TaintedPathSink = TaintedPath::Sink;

/** DEPRECATED: Use `TaintedPath::Sanitizer` instead. */
deprecated class TaintedPathSanitizer = TaintedPath::Sanitizer;

/** DEPRECATED: Use `TaintedPath::Configuration` instead. */
deprecated class TaintedPathTrackingConfig = TaintedPath::Configuration;
