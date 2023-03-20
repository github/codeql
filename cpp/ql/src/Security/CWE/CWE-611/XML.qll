/**
 * Provides a abstract classes for modeling XML libraries. This design is
 * currently specialized for the purposes of the XXE query.
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import Xerces
import Libxml2

/**
 * A flow state representing a possible configuration of an XML object.
 */
newtype TXxeFlowState =
  /**
   * Flow state for `AbstractDOMParser` or `SAXParser`, where:
   *  - `disabledDefaultEntityResolution` is 1 if `setDisableDefaultEntityResolution`
   *    is `true`, 0 otherwise.
   *  - `createEntityReferenceNodes` is 1 if `setCreateEntityReferenceNodes`
   *    is `true`, 0 otherwise.
   */
  TXercesFlowState(int disabledDefaultEntityResolution, int createEntityReferenceNodes) {
    disabledDefaultEntityResolution in [0, 1] and
    createEntityReferenceNodes in [0, 1]
  } or
  /** Flow state for libxml2 */
  TLibXml2FlowState()

/**
 * An XML library or interface.
 */
abstract class XmlLibrary extends string {
  bindingset[this]
  XmlLibrary() { any() } // required characteristic predicate

  /**
   * Holds if `node` is the source node for a potentially unsafe configuration
   * object for this XML library, along with `flowstate` representing its
   * initial state.
   */
  abstract predicate configurationSource(DataFlow::Node node, TXxeFlowState flowstate);

  /**
   * Holds if `node` is  the sink node where an unsafe configuration object is
   * used to interpret XML.
   */
  abstract predicate configurationSink(DataFlow::Node node, TXxeFlowState flowstate);
}

/**
 * An `Expr` that changes the configuration of an XML object, transforming the
 * `XxeFlowState` that flows through it.
 */
abstract class XxeFlowStateTransformer extends Expr {
  /**
   * Gets the flow state that `flowstate` is transformed into.
   *
   * Due to limitations of the implementation the transformation defined by this
   * predicate must be idempotent, that is, for any input `x` it must be that:
   * ```
   * transform(transform(x)) = transform(x)
   * ```
   */
  abstract TXxeFlowState transform(TXxeFlowState flowstate);
}
