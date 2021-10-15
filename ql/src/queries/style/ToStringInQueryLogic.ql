/**
 * @name Using 'toString' in query logic
 * @description A query should not depend on the output of 'toString'.
 * @kind problem
 * @problem.severity error
 * @id ql/to-string-in-logic
 * @precision medium
 * @tags maintainability
 */

import ql
import codeql_ql.ast.internal.Builtins
import codeql.dataflow.DataFlow

class ToString extends Predicate {
  ToString() { this.getName() = "toString" }
}

class ToStringCall extends Call {
  ToStringCall() { this.getTarget() instanceof ToString }
}

class NodesPredicate extends Predicate {
  NodesPredicate() { this.getName() = "nodes" }
}

class EdgesPredicate extends Predicate {
  EdgesPredicate() { this.getName() = "edges" }
}

class RegexpReplaceAll extends BuiltinPredicate {
  RegexpReplaceAll() { this.getName() = "regexpReplaceAll" }
}

class RegexpReplaceAllCall extends MemberCall {
  RegexpReplaceAllCall() { this.getTarget() instanceof RegexpReplaceAll }
}

class ToSelectConf extends DataFlow::Configuration {
  ToSelectConf() { this = "ToSelectConf" }

  override predicate isSource(DataFlow::Node source) {
    exists(ToStringCall toString |
      source.asExpr() = toString and
      not toString.getEnclosingPredicate() instanceof ToString
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(Select s).getExpr(_) or
    sink.getEnclosingCallable().asPredicate() instanceof NodesPredicate or
    sink.getEnclosingCallable().asPredicate() instanceof EdgesPredicate
  }

  override predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    nodeFrom.getType() instanceof StringClass and
    nodeTo.getType() instanceof StringClass and
    exists(BinOpExpr binop |
      nodeFrom.asExpr() = binop.getAnOperand() and
      nodeTo.asExpr() = binop
    )
    or
    nodeTo.asExpr().(RegexpReplaceAllCall).getBase() = nodeFrom.asExpr()
  }
}

predicate flowsToSelect(Expr e) {
  exists(DataFlow::Node source |
    source.asExpr() = e and
    any(ToSelectConf conf).hasFlow(source, _)
  )
}

from ToStringCall call
where
  // The call doesn't flow to a select
  not flowsToSelect(call) and
  // It's not part of a toString call
  not call.getEnclosingPredicate() instanceof ToString and
  // It's in a query
  call.getLocation().getFile().getBaseName().matches("%.ql") and
  // ... and not in a test
  not call.getLocation()
      .getFile()
      .getAbsolutePath()
      .toLowerCase()
      .matches(["%test%", "%consistency%", "%meta%"])
select call, "Query logic depends on implementation of 'toString'."
