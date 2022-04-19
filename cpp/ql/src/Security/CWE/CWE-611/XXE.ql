/**
 * @name External Entity Expansion
 * @description Parsing user-controlled XML documents and allowing expansion of
 *              external entity references may lead to disclosure of
 *              confidential data or denial of service.
 * @kind path-problem
 * @id cpp/external-entity-expansion
 * @problem.severity warning
 * @security-severity 9.1
 * @precision medium
 * @tags security
 *       external/cwe/cwe-611
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import DataFlow::PathGraph
import semmle.code.cpp.ir.IR

/**
 * A flow state representing a possible configuration of an XML object.
 */
abstract class XXEFlowState extends string {
  bindingset[this]
  XXEFlowState() { any() } // required characteristic predicate
}

/**
 * An `Expr` that changes the configuration of an XML object, transforming the
 * `XXEFlowState` that flows through it.
 */
abstract class XXEFlowStateTranformer extends Expr {
  /**
   * Gets the flow state that `flowstate` is transformed into.
   *
   * Due to limitations of the implementation the transformation defined by this
   * predicate must be idempotent, that is, for any input `x` it must be that:
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
 * Flow state transformer for a call to
 * `AbstractDOMParser.setDisableDefaultEntityResolution`. Transforms the flow
 * state through the qualifier according to the setting in the parameter.
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
 * Flow state transformer for a call to
 * `AbstractDOMParser.setCreateEntityReferenceNodes`. Transforms the flow
 * state through the qualifier according to the setting in the parameter.
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

/**
 * Configuration for tracking XML objects and their states.
 */
class XXEConfiguration extends DataFlow::Configuration {
  XXEConfiguration() { this = "XXEConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    // source is the write on `this` of a call to the `XercesDOMParser`
    // constructor.
    exists(CallInstruction call |
      call.getStaticCallTarget() = any(XercesDOMParserClass c).getAConstructor() and
      node.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
        call.getThisArgument() and
      encodeXercesDOMFlowState(flowstate, 0, 1) // default configuration
    )
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
  }

  override predicate isBarrier(DataFlow::Node node, string flowstate) {
    // when the flowstate is transformed at a call node, block the original
    // flowstate value.
    node.asConvertedExpr().(XXEFlowStateTranformer).transform(flowstate) != flowstate
  }
}

from XXEConfiguration conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink,
  "This $@ is not configured to prevent an External Entity Expansion (XXE) attack.", source,
  "XML parser"
