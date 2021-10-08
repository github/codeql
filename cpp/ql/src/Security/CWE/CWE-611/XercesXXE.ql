/**
 * @name External Entity Expansion
 * @description
 * @kind path-problem
 * @id cpp/external-entity-expansion
 * @problem.severity warning
 * @tags security
 *       external/cwe/cwe-611
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import DataFlow::PathGraph
import semmle.code.cpp.ir.IR

class XercesDOMParser extends Class {
  XercesDOMParser() { this.hasName("XercesDOMParser") }
}

class AbstractDOMParser extends Class {
  AbstractDOMParser() { this.hasName("AbstractDOMParser") }
}

class DisableDefaultEntityResolution extends Function {
  DisableDefaultEntityResolution() {
    this.hasQualifiedName(_, "XercesDOMParser", "disableDefaultEntityResolution")
  }
}

class SetCreateEntityReferenceNodes extends Function {
  SetCreateEntityReferenceNodes() {
    this.hasQualifiedName(_, "XercesDOMParser", "setCreateEntityReferenceNodes")
  }
}

class CreateLSParser extends Function {
  CreateLSParser() {
    this.hasName("createLSParser")
  }
}

class XercesXXEConfiguration extends DataFlow::Configuration {
  XercesXXEConfiguration() { this = "XercesXXEConfiguration" }

  override predicate isSource(DataFlow::Node node) {
    exists(CallInstruction call |
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() = call.getThisArgument() and
      call.getStaticCallTarget().(Constructor).getDeclaringType() instanceof XercesDOMParser
    )
    or
    exists(Call call |
      call.getTarget() instanceof CreateLSParser and
      call = node.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node node) {
    exists(Call call, ReadSideEffectInstruction instr |
      call.getTarget().hasName("parse") and
      call.getQualifier() = instr.getArgumentDef().getUnconvertedResultExpression() and
      node.asOperand() = instr.getSideEffectOperand()
    )
  }

  override predicate isBarrier(DataFlow::Node node) {
    exists(Call first, Call second |
      (
        first.getTarget() instanceof DisableDefaultEntityResolution and
        second.getTarget() instanceof SetCreateEntityReferenceNodes
        or
        first.getTarget() instanceof SetCreateEntityReferenceNodes and
        second.getTarget() instanceof DisableDefaultEntityResolution
      ) and
      DataFlow::localExprFlow(first.getQualifier(), second.getQualifier()) and
      second.getQualifier() = node.asDefiningArgument()
    )
    or
    exists(Call setSecurityManager |
      // todo: security manager setup
      setSecurityManager.getQualifier() = node.asDefiningArgument()
    )
  }
}

/*
 * parser created
 * needs doSchema set?
 * needs validation set?
 * needs namespaces?
 * (
 * no security manager
 * OR
 * no
 */

from DataFlow::PathNode source, DataFlow::PathNode sink, XercesXXEConfiguration conf
where conf.hasFlowPath(source, sink)
select sink, source, sink,
  "This $@ is not configured to prevent an External Entity Expansion attack.", source, "XML parser"
