/**
 * Provides a taint tracking configuration for reasoning about shell command
 * constructed from library input vulnerabilities
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `UnsafeShellCommandConstructionCustomizations` should be imported instead.
 */

import codeql.ruby.AST as Ast
import codeql.ruby.DataFlow
import UnsafeShellCommandConstructionCustomizations::UnsafeShellCommandConstruction
private import codeql.ruby.TaintTracking
private import CommandInjectionCustomizations::CommandInjection as CommandInjection
private import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting shell command constructed from library input vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeShellCommandConstruction" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof CommandInjection::Sanitizer or // using all sanitizers from `rb/command-injection`
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  // override to require the path doesn't have unmatched return steps
  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }

  // A direct step from a write to an instance field in a constructor to a read of that same field.
  // Corresponds to `DataFlow::localFieldStep` in the JS analysis.
  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::ModuleNode clz, string field, Ast::Method constructor |
      clz.getAnOwnInstanceVariableWriteValue(field) = pred and
      constructor = pred.asExpr().getExpr().getEnclosingCallable() and
      constructor.getName() = "initialize" and
      not succ.asExpr().getExpr().getEnclosingCallable() = constructor and
      (
        clz.getAnOwnInstanceVariableRead(field) = succ
        or
        // TODO: have getAnOwnInstanceVariableRead return this when `attr_reader` is used
        exists(DataFlow::MethodNode instMeth | instMeth = clz.getAnInstanceMethod() |
          // the parent thing is to recognize reads in blocks. It's ugly, so do something else. TODO:
          // TODO: Also add a test for reads inside blocks.
          succ.asExpr().getExpr().getParent*().(Ast::Expr).getEnclosingCallable() =
            instMeth.asExpr().getExpr() and
          succ.(DataFlow::CallNode).getMethodName() = field.suffix(1)
        )
      )
    )
  }
}
