/**
 * @name Code injection from dynamically imported code
 * @description Interpreting unsanitized user input as code allows a malicious user arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id js/code-injection-dynamic-import
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript

abstract class Barrier extends DataFlow::Node { }

/** A non-first leaf in a string-concatenation. Seen as a sanitizer for dynamic import code injection. */
class NonFirstStringConcatLeaf extends Barrier {
  NonFirstStringConcatLeaf() {
    exists(StringOps::ConcatenationRoot root |
      this = root.getALeaf() and
      not this = root.getFirstLeaf()
    )
    or
    exists(DataFlow::CallNode join |
      join = DataFlow::moduleMember("path", "join").getACall() and
      this = join.getArgument([1 .. join.getNumArgument() - 1])
    )
  }
}

/**
 * The dynamic import expression input can be a `data:` URL which loads any module from that data
 */
class DynamicImport extends DataFlow::ExprNode {
  DynamicImport() { this = any(DynamicImportExpr e).getSource().flow() }
}

/**
 * The dynamic import expression input can be a `data:` URL which loads any module from that data
 */
class WorkerThreads extends DataFlow::Node {
  WorkerThreads() {
    this = API::moduleImport("node:worker_threads").getMember("Worker").getParameter(0).asSink()
  }
}

newtype TFlowState =
  TTaint() or
  TUrlConstructor()

/**
 * A taint-tracking configuration for reasoning about code injection vulnerabilities.
 */
module CodeInjectionConfig implements DataFlow::StateConfigSig {
  class FlowState extends TFlowState {
    string toString() {
      this = TTaint() and result = "taint"
      or
      this = TUrlConstructor() and result = "url-constructor"
    }
  }

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof ActiveThreatModelSource and state = TTaint()
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof DynamicImport }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof WorkerThreads and state = TUrlConstructor()
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    exists(DataFlow::NewNode newUrl | node2 = newUrl |
      newUrl = DataFlow::globalVarRef("URL").getAnInstantiation() and
      node1 = newUrl.getArgument(0)
    ) and
    state1 = TTaint() and
    state2 = TUrlConstructor()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module CodeInjectionFlow = TaintTracking::GlobalWithState<CodeInjectionConfig>;

import CodeInjectionFlow::PathGraph

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink
where CodeInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This command line depends on a $@.", source.getNode(),
  "user-provided value"
