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

// TODO: currently the file name is Xerces-specific but the query ID isn't.
// Decide which design to go with.
import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import DataFlow::PathGraph
import semmle.code.cpp.ir.IR

/**
 * A flow state representing a possible configuration of an XML object.
 */
abstract class XXEFlowState extends string {
  bindingset[this]
  XXEFlowState() { any() } // required constructor
}

/**
 * An `Expr` that changes the configuration of an XML object, transforming the
 * `XXEFlowState` that flows through it.
 */
abstract class XXEFlowStateTranformer extends Expr {
  /**
   * Gets the flow state that `flowstate` is transformed into.
   *
   * Due to limitations of the implementation the result must always map to
   * itself, that is, it must be that:
   * ```
   * transform(tranform(x)) = tranform(x)
   * ```
   */
  abstract XXEFlowState transform(XXEFlowState flowstate);
}

/**
 * The `AbstractDOMParser` class.
 */
class AbstractDOMParserClass extends Class {
  AbstractDOMParserClass() { this.hasName("AbstractDOMParser") }
}

/**
 * The `XercesDOMParser` class.
 */
class XercesDOMParserClass extends Class {
  XercesDOMParserClass() { this.hasName("XercesDOMParser") }
}

/**
 * Gets a valid flow state for `XercesDOMParser` flow.
 *
 * These flow states take the form `XercesDOM-A-B`, where:
 *  - A is 1 if `setDisableDefaultEntityResolution` is `true`, 0 otherwise.
 *  - B is 1 if `setCreateEntityReferenceNodes` is `true`, 0 otherwise.
 */
predicate encodeXercesDOMFlowState(string flowstate, int a, int b) {
  flowstate = "XercesDOM-0-0" and a = 0 and b = 0
  or
  flowstate = "XercesDOM-0-1" and a = 0 and b = 1
  or
  flowstate = "XercesDOM-1-0" and a = 1 and b = 0
  or
  flowstate = "XercesDOM-1-1" and a = 1 and b = 1
}

/**
 * A flow state representing the configuration of a `XercesDOMParser` object.
 */
class XercesDOMParserFlowState extends XXEFlowState {
  XercesDOMParserFlowState() { encodeXercesDOMFlowState(this, _, _) }
}

/**
 * The qualifier of a call to `AbstractDOMParser.setDisableDefaultEntityResolution`.
 */
class DisableDefaultEntityResolutionTranformer extends XXEFlowStateTranformer {
  Expr newValue;

  DisableDefaultEntityResolutionTranformer() {
    exists(Call call, Function f |
      call.getTarget() = f and
      f.getDeclaringType() instanceof AbstractDOMParserClass and
      f.hasName("setDisableDefaultEntityResolution") and
      this = call.getQualifier() and
      newValue = call.getArgument(0)
    )
  }

  final override XXEFlowState transform(XXEFlowState flowstate) {
    exists(int a, int b |
      encodeXercesDOMFlowState(flowstate, a, b) and
      (
        newValue.getValue().toInt() = 1 and // true
        encodeXercesDOMFlowState(result, 1, b)
        or
        not newValue.getValue().toInt() = 1 and // false or unknown
        encodeXercesDOMFlowState(result, 0, b)
      )
    )
  }
}

/**
 * The qualifier of a call to `AbstractDOMParser.setDisableDefaultEntityResolution`.
 */
class CreateEntityReferenceNodesTranformer extends XXEFlowStateTranformer {
  Expr newValue;

  CreateEntityReferenceNodesTranformer() {
    exists(Call call, Function f |
      call.getTarget() = f and
      f.getDeclaringType() instanceof AbstractDOMParserClass and
      f.hasName("setCreateEntityReferenceNodes") and
      this = call.getQualifier() and
      newValue = call.getArgument(0)
    )
  }

  final override XXEFlowState transform(XXEFlowState flowstate) {
    exists(int a, int b |
      encodeXercesDOMFlowState(flowstate, a, b) and
      (
        newValue.getValue().toInt() = 1 and // true
        encodeXercesDOMFlowState(result, a, 1)
        or
        not newValue.getValue().toInt() = 1 and // false or unknown
        encodeXercesDOMFlowState(result, a, 0)
      )
    )
  }
}

/**
 * The `AbstractDOMParser.parse` method.
 */
class ParseFunction extends Function {
  ParseFunction() {
    this.getDeclaringType() instanceof AbstractDOMParserClass and
    this.hasName("parse")
  }
}

/*
 * class CreateLSParser extends Function {
 *  CreateLSParser() { this.hasName("createLSParser") }
 * }
 *
 * class SetSecurityManager extends Function {
 *  SetSecurityManager() { this.hasQualifiedName(_, "AbstractDOMParser", "setSecurityManager") }
 * }
 *
 * class SAXParser extends Class {
 *  SAXParser() { this.hasName("SAXParser") }
 * }
 */

/**
 * Configuration for tracking Xerces library XML objects and their states.
 */
class XercesXXEConfiguration extends DataFlow::Configuration {
  XercesXXEConfiguration() { this = "XercesXXEConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    // source is the write on `this` of a call to the XercesDOMParser
    // constructor.
    exists(CallInstruction call |
      call.getStaticCallTarget() = any(XercesDOMParserClass c).getAConstructor() and
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
        call.getThisArgument() and
      encodeXercesDOMFlowState(flowstate, 0, 1) // default configuration
    )
    /*
     *   or
     *    exists(Call call |
     *      call.getTarget() instanceof CreateLSParser and
     *      call = node.asExpr() and
     *      flowstate = "XercesDOM"
     *    )
     *    or
     *    exists(CallInstruction call |
     *      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
     *        call.getThisArgument() and
     *      call.getStaticCallTarget().(Constructor).getDeclaringType() instanceof SAXParser and
     *      flowstate = "SAXParser"
     *    )
     */

    }

  override predicate isSink(DataFlow::Node node, string flowstate) {
    // sink is the read of the qualifier of a call to `parse`.
    exists(Call call |
      call.getTarget() instanceof ParseFunction and
      call.getQualifier() = node.asConvertedExpr()
    ) and
    flowstate instanceof XercesDOMParserFlowState and
    not encodeXercesDOMFlowState(flowstate, 1, 1) // safe configuration
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, string state1, DataFlow::Node node2, string state2
  ) {
    // create additional flow steps for `XXEFlowStateTranformer`s
    state2 = node2.asConvertedExpr().(XXEFlowStateTranformer).transform(state1) and
    DataFlow::simpleLocalFlowStep(node1, node2)
    /*
     * exists(CallInstruction call |
     *      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
     *        call.getThisArgument() and
     *      call.getStaticCallTarget().(Constructor).getDeclaringType() instanceof SAXParser and
     *      flowstate = "SAXParser"
     *    )
     */

    }

  override predicate isBarrierOut(DataFlow::Node node, string flowstate) {
    // when the flowstate is transformed at a call node, block the original
    // flowstate value.
    node.asConvertedExpr().(XXEFlowStateTranformer).transform(flowstate) != flowstate
    /*
     * or
     *    exists(Call setSecurityManager |
     *      // todo: security manager setup
     *      flowstate = TODO
     *      setSecurityManager.getQualifier() = node.asDefiningArgument() and
     *      setSecurityManager.getTarget() instanceof SetSecurityManager
     *    )
     */

    }
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
  "This $@ is not configured to prevent an External Entity Expansion (XXE) attack.", source,
  "XML parser"
