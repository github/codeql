/**
 * @name External Entity Expansion
 * @description TODO
 * @kind path-problem
 * @id cpp/external-entity-expansion
 * @problem.severity warning
 * @security-severity TODO
 * @precision TODO
 * @tags security
 *       external/cwe/cwe-611
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import DataFlow::PathGraph
import semmle.code.cpp.ir.IR

class AbstractDOMParser extends Class {
  AbstractDOMParser() { this.hasName("AbstractDOMParser") }
}

class XercesDOMParser extends Class {
  XercesDOMParser() { this.hasName("XercesDOMParser") }
}

class DisableDefaultEntityResolution extends Function {
  DisableDefaultEntityResolution() {
    this.getDeclaringType() instanceof AbstractDOMParser and
    this.hasName("setDisableDefaultEntityResolution")
  }
}

class SetCreateEntityReferenceNodes extends Function {
  SetCreateEntityReferenceNodes() {
    this.getDeclaringType() instanceof AbstractDOMParser and
    this.hasName("setCreateEntityReferenceNodes")
  }
}

class Parse extends Function {
  Parse() {
    this.getDeclaringType() instanceof AbstractDOMParser and
    this.hasName("parse")
  }
}

/*
class CreateLSParser extends Function {
  CreateLSParser() { this.hasName("createLSParser") }
}

class SetSecurityManager extends Function {
  SetSecurityManager() { this.hasQualifiedName(_, "AbstractDOMParser", "setSecurityManager") }
}

class SAXParser extends Class {
  SAXParser() { this.hasName("SAXParser") }
}
*/
class XercesXXEConfiguration extends DataFlow::Configuration {
  XercesXXEConfiguration() { this = "XercesXXEConfiguration" }

  override predicate isSource(DataFlow::Node node/*, string flowstate*/) {
    // source is the write on `this` of a call to the XercesDOMParser
    // constructor.
    exists(CallInstruction call |
      call.getStaticCallTarget() = any(XercesDOMParser c).getAConstructor() and
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
        call.getThisArgument()/* and
      flowstate = "XercesDOM"*/
    )
    /*exists(Call call |
      call.getTarget() = any(XercesDOMParser c).getAConstructor() and
      node.asExpr() = call
    )*/
 /*   or
    exists(Call call |
      call.getTarget() instanceof CreateLSParser and
      call = node.asExpr() and
      flowstate = "XercesDOM"
    )
    or
    exists(CallInstruction call |
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
        call.getThisArgument() and
      call.getStaticCallTarget().(Constructor).getDeclaringType() instanceof SAXParser and
      flowstate = "SAXParser"
    )*/
  }

  override predicate isSink(DataFlow::Node node) {
    // sink is the read of the qualifier of a call to `parse`.
    exists(Call call/*, ReadSideEffectInstruction instr*/ |
      call.getTarget() instanceof Parse and
      call.getQualifier() = node.asConvertedExpr()
      /*instr.getArgumentDef().getUnconvertedResultExpression() and
      node.asOperand() = instr.getSideEffectOperand()*/
    )
  }

  /*override predicate isAdditionalFlowStep(
    DataFlow::Node node1, string state1, DataFlow::Node node2, string state2
  ) {
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
  }*/

  /*override predicate isBarrier(DataFlow::Node node, string flowstate) {
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
      flowstate = TODO
      setSecurityManager.getQualifier() = node.asDefiningArgument() and
      setSecurityManager.getTarget() instanceof SetSecurityManager
    )
  }*/
}

/*
 * TODO:
 * parser created
 * needs doSchema set?
 * needs validation set?
 * needs namespaces?
 * (
 * no security manager
 * OR
 * no
 */

from XercesXXEConfiguration conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink,
  "This $@ is not configured to prevent an External Entity Expansion (XXE) attack.", source, "XML parser"
