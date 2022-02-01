/**
 * @name Capturing a foreach variable
 * @description Code that captures a 'foreach' variable and uses it outside the loop behaves differently in C# version 4 and C# version 5
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/captured-foreach-variable
 * @tags portability
 *       maintainability
 *       language-features
 *       external/cwe/cwe-758
 */

import csharp
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.code.csharp.frameworks.system.Collections
import semmle.code.csharp.frameworks.system.collections.Generic

predicate lambdaCaptures(AnonymousFunctionExpr lambda, Variable v) {
  exists(VariableAccess va | va.getEnclosingCallable() = lambda | va.getTarget() = v)
}

predicate lambdaCapturesLoopVariable(AnonymousFunctionExpr lambda, ForeachStmt loop, Variable v) {
  lambdaCaptures(lambda, v) and
  inForeachStmtBody(loop, lambda) and
  loop.getVariable() = v
}

predicate inForeachStmtBody(ForeachStmt loop, Element e) {
  e = loop.getBody()
  or
  exists(Element mid |
    inForeachStmtBody(loop, mid) and
    e = mid.getAChild()
  )
}

class LambdaDataFlowConfiguration extends DataFlow::Configuration {
  LambdaDataFlowConfiguration() { this = "LambdaDataFlowConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    lambdaCapturesLoopVariable(source.asExpr(), _, _)
  }

  override predicate isSink(DataFlow::Node sink) { exists(getAssignmentTarget(sink.asExpr())) }

  predicate capturesLoopVarAndIsStoredIn(
    AnonymousFunctionExpr lambda, Variable loopVar, Element storage
  ) {
    exists(DataFlow::Node sink | this.hasFlow(DataFlow::exprNode(lambda), sink) |
      storage = getAssignmentTarget(sink.asExpr())
    ) and
    exists(ForeachStmt loop | lambdaCapturesLoopVariable(lambda, loop, loopVar) |
      not declaredInsideLoop(loop, storage)
    )
  }
}

Element getAssignmentTarget(Expr e) {
  exists(Assignment a | a.getRValue() = e |
    result = a.getLValue().(PropertyAccess).getTarget() or
    result = a.getLValue().(FieldAccess).getTarget() or
    result = a.getLValue().(LocalVariableAccess).getTarget() or
    result = a.getLValue().(EventAccess).getTarget()
  )
  or
  exists(AddEventExpr aee |
    e = aee.getRValue() and
    result = aee.getLValue().getTarget()
  )
  or
  result = getCollectionAssignmentTarget(e)
}

Element getCollectionAssignmentTarget(Expr e) {
  // Store into collection via method
  exists(DataFlowPrivate::PostUpdateNode postNode |
    FlowSummaryImpl::Private::Steps::summarySetterStep(DataFlow::exprNode(e), _, postNode) and
    result.(Variable).getAnAccess() = postNode.getPreUpdateNode().asExpr()
  )
  or
  // Array initializer
  e = result.(ArrayCreation).getInitializer().getAnElement()
  or
  // Collection initializer
  e =
    result
        .(ObjectCreation)
        .getInitializer()
        .(CollectionInitializer)
        .getElementInitializer(_)
        .getAnArgument()
  or
  // Store values using indexer
  exists(IndexerAccess ia, AssignExpr ae |
    ia.getQualifier() = result.(Variable).getAnAccess() and
    ia = ae.getLValue() and
    e = ae.getRValue()
  )
}

// Variable v is declared inside the loop body
predicate declaredInsideLoop(ForeachStmt loop, LocalVariable v) {
  exists(LocalVariableDeclStmt decl | decl.getVariableDeclExpr(_).getVariable() = v |
    inForeachStmtBody(loop, decl)
  )
}

from LambdaDataFlowConfiguration c, AnonymousFunctionExpr lambda, Variable loopVar, Element storage
where c.capturesLoopVarAndIsStoredIn(lambda, loopVar, storage)
select lambda, "Function which may be stored in $@ captures variable $@", storage,
  storage.toString(), loopVar, loopVar.getName()
