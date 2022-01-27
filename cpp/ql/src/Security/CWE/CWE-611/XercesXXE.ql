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
    this.hasQualifiedName(_, "AbstractOMParser", "setDisableDefaultEntityResolution")
  }
}

class SetCreateEntityReferenceNodes extends Function {
  SetCreateEntityReferenceNodes() {
    this.hasQualifiedName(_, "AbstractDOMParser", "setCreateEntityReferenceNodes")
  }
}

class CreateLSParser extends Function {
  CreateLSParser() {
    this.hasName("createLSParser")
  }
}

class SetSecurityManager extends Function {
  SetSecurityManager() {
    this.hasQualifiedName(_, "AbstractDOMParser", "setSecurityManager")
  }
}

class SAXParser extends Class {
  SAXParser() { this.hasName("SAXParser") }
}

class XercesXXEConfiguration extends DataFlow::Configuration {
  XercesXXEConfiguration() { this = "XercesXXEConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    exists(CallInstruction call |
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() = call.getThisArgument() and
      call.getStaticCallTarget().(Constructor).getDeclaringType() instanceof XercesDOMParser and
      flowstate = "XercesDOM"
    )
    or
    exists(Call call |
      call.getTarget() instanceof CreateLSParser and
      call = node.asExpr() and
      flowstate = "XercesDOM"
    )
    or
    exists(CallInstruction call |
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() = call.getThisArgument() and
      call.getStaticCallTarget().(Constructor).getDeclaringType() instanceof SAXParser and
      flowstate = "SAXParser"
    )
  }

  override predicate isSink(DataFlow::Node node) {
    exists(Call call, ReadSideEffectInstruction instr |
      call.getTarget().hasName("parse") and
      call.getQualifier() = instr.getArgumentDef().getUnconvertedResultExpression() and
      node.asOperand() = instr.getSideEffectOperand()
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, string state1, DataFlow::Node node2, string state2) {
    exists(Call call |
      node1.asConvertedExpr() = call.getQualifier() and
      node2.asDefiningArgument() = call.getQualifier() and
      (
        call.getTarget() instanceof DisableDefaultEntityResolution and
        state1 = "XercesDOM" and
        state2 = "XercesDOM-DDER"
        or
        call.getTarget() instanceof SetCreateEntityReferenceNodes and
        state1 = "XercesDOM" and
        state2 = "XercesDOM-SCERN"
      )
    )
  }

  override predicate isBarrier(DataFlow::Node node, string flowstate) {
    exists(Call call |
      (
        flowstate = "XercesDOM-DDER" and
        call.getTarget() instanceof SetCreateEntityReferenceNodes
        or
        flowstate = "XercesDOM-SCERN" and
        call.getTarget() instanceof DisableDefaultEntityResolution
      ) and
      call.getQualifier() = node.asDefiningArgument()
    )
    or
    exists(Call setSecurityManager |
      // todo: security manager setup
      setSecurityManager.getQualifier() = node.asDefiningArgument() and
      setSecurityManager.getTarget() instanceof SetSecurityManager
    )
    //or
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
