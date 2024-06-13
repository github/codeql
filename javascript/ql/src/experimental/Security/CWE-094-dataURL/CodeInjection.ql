/**
 * @name Code injection
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
import DataFlow
import DataFlow::PathGraph

abstract class Sanitizer extends DataFlow::Node { }

/** A non-first leaf in a string-concatenation. Seen as a sanitizer for dynamic import code injection. */
class NonFirstStringConcatLeaf extends Sanitizer {
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

class UrlConstructorLabel extends FlowLabel {
  UrlConstructorLabel() { this = "UrlConstructorLabel" }
}

/**
 * A taint-tracking configuration for reasoning about code injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CodeInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DynamicImport }

  override predicate isSink(DataFlow::Node sink, FlowLabel label) {
    sink instanceof WorkerThreads and label instanceof UrlConstructorLabel
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, FlowLabel predlbl, FlowLabel succlbl
  ) {
    exists(DataFlow::NewNode newUrl | succ = newUrl |
      newUrl = DataFlow::globalVarRef("URL").getAnInstantiation() and
      pred = newUrl.getArgument(0)
    ) and
    predlbl instanceof StandardFlowLabel and
    succlbl instanceof UrlConstructorLabel
  }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This command line depends on a $@.", source.getNode(),
  "user-provided value"
