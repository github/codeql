/**
 * Models the Xerces XML library.
 */

import cpp
import XML
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.ir.IR

/**
 * A flow state representing the configuration of an `AbstractDOMParser` or
 * `SAXParser` object.
 */
class XercesFlowState extends TXxeFlowState {
  int disabledDefaultEntityResolution;
  int createEntityReferenceNodes;

  XercesFlowState() {
    this = TXercesFlowState(disabledDefaultEntityResolution, createEntityReferenceNodes)
  }

  int getDisabledDefaultEntityResolution() { result = disabledDefaultEntityResolution }

  int getCreateEntityReferenceNodes() { result = createEntityReferenceNodes }

  string toString() { result = "XercesFlowState" }
}

/**
 * Gets a valid flow state for `AbstractDOMParser` or `SAXParser` flow.
 */
predicate encodeXercesFlowState(
  XercesFlowState flowstate, int disabledDefaultEntityResolution, int createEntityReferenceNodes
) {
  flowstate.getDisabledDefaultEntityResolution() = disabledDefaultEntityResolution and
  flowstate.getCreateEntityReferenceNodes() = createEntityReferenceNodes
}

/**
 * The `AbstractDOMParser` class.
 */
class AbstractDomParserClass extends Class {
  AbstractDomParserClass() { this.hasName("AbstractDOMParser") }
}

/**
 * The `XercesDOMParser` class.
 */
class XercesDomParserClass extends Class {
  XercesDomParserClass() { this.hasName("XercesDOMParser") }
}

/**
 * The `XercesDOMParser` interface for the Xerces XML library.
 */
class XercesDomParserLibrary extends XmlLibrary {
  XercesDomParserLibrary() { this = "XercesDomParserLibrary" }

  override predicate configurationSource(DataFlow::Node node, TXxeFlowState flowstate) {
    // source is the write on `this` of a call to the `XercesDOMParser`
    // constructor.
    exists(Call call |
      call.getTarget() = any(XercesDomParserClass c).getAConstructor() and
      node.asExpr() = call and
      encodeXercesFlowState(flowstate, 0, 1) // default configuration
    )
  }

  override predicate configurationSink(DataFlow::Node node, TXxeFlowState flowstate) {
    // sink is the read of the qualifier of a call to `AbstractDOMParser.parse`.
    exists(Call call |
      call.getTarget().getClassAndName("parse") instanceof AbstractDomParserClass and
      call.getQualifier() = node.asIndirectExpr()
    ) and
    flowstate instanceof XercesFlowState and
    not encodeXercesFlowState(flowstate, 1, 1) // safe configuration
  }
}

/**
 * The `DOMLSParser` class.
 */
class DomLSParserClass extends Class {
  DomLSParserClass() { this.hasName("DOMLSParser") }
}

/**
 * The `createLSParser` function that returns a newly created `DOMLSParser`
 * object.
 */
class CreateLSParser extends Function {
  CreateLSParser() {
    this.hasName("createLSParser") and
    this.getUnspecifiedType().(PointerType).getBaseType() instanceof DomLSParserClass // returns a `DOMLSParser *`.
  }
}

/**
 * The createLSParser interface for the Xerces XML library.
 */
class CreateLSParserLibrary extends XmlLibrary {
  CreateLSParserLibrary() { this = "CreateLSParserLibrary" }

  override predicate configurationSource(DataFlow::Node node, TXxeFlowState flowstate) {
    // source is the result of a call to `createLSParser`.
    exists(Call call |
      call.getTarget() instanceof CreateLSParser and
      call = node.asIndirectExpr() and
      encodeXercesFlowState(flowstate, 0, 1) // default configuration
    )
  }

  override predicate configurationSink(DataFlow::Node node, TXxeFlowState flowstate) {
    // sink is the read of the qualifier of a call to `DOMLSParserClass.parse`.
    exists(Call call |
      call.getTarget().getClassAndName("parse") instanceof DomLSParserClass and
      call.getQualifier() = node.asIndirectExpr()
    ) and
    flowstate instanceof XercesFlowState and
    not encodeXercesFlowState(flowstate, 1, 1) // safe configuration
  }
}

/**
 * The `SAXParser` class.
 */
class SaxParserClass extends Class {
  SaxParserClass() { this.hasName("SAXParser") }
}

/**
 * The `SAX2XMLReader` class.
 */
class Sax2XmlReader extends Class {
  Sax2XmlReader() { this.hasName("SAX2XMLReader") }
}

/**
 * The SAXParser interface for the Xerces XML library.
 */
class SaxParserLibrary extends XmlLibrary {
  SaxParserLibrary() { this = "SaxParserLibrary" }

  override predicate configurationSource(DataFlow::Node node, TXxeFlowState flowstate) {
    // source is the write on `this` of a call to the `SAXParser`
    // constructor.
    exists(Call call |
      call.getTarget() = any(SaxParserClass c).getAConstructor() and
      node.asExpr() = call and
      encodeXercesFlowState(flowstate, 0, 1) // default configuration
    )
  }

  override predicate configurationSink(DataFlow::Node node, TXxeFlowState flowstate) {
    // sink is the read of the qualifier of a call to `SAXParser.parse`.
    exists(Call call |
      call.getTarget().getClassAndName("parse") instanceof SaxParserClass and
      call.getQualifier() = node.asIndirectExpr()
    ) and
    flowstate instanceof XercesFlowState and
    not encodeXercesFlowState(flowstate, 1, 1) // safe configuration
  }
}

/**
 * The `createXMLReader` function that returns a newly created `SAX2XMLReader`
 * object.
 */
class CreateXmlReader extends Function {
  CreateXmlReader() {
    this.hasName("createXMLReader") and
    this.getUnspecifiedType().(PointerType).getBaseType() instanceof Sax2XmlReader // returns a `SAX2XMLReader *`.
  }
}

/**
 * The SAX2XMLReader interface for the Xerces XML library.
 */
class Sax2XmlReaderLibrary extends XmlLibrary {
  Sax2XmlReaderLibrary() { this = "Sax2XmlReaderLibrary" }

  override predicate configurationSource(DataFlow::Node node, TXxeFlowState flowstate) {
    // source is the result of a call to `createXMLReader`.
    exists(Call call |
      call.getTarget() instanceof CreateXmlReader and
      call = node.asIndirectExpr() and
      encodeXercesFlowState(flowstate, 0, 1) // default configuration
    )
  }

  override predicate configurationSink(DataFlow::Node node, TXxeFlowState flowstate) {
    // sink is the read of the qualifier of a call to `SAX2XMLReader.parse`.
    exists(Call call |
      call.getTarget().getClassAndName("parse") instanceof Sax2XmlReader and
      call.getQualifier() = node.asIndirectExpr()
    ) and
    flowstate instanceof XercesFlowState and
    not encodeXercesFlowState(flowstate, 1, 1) // safe configuration
  }
}

/**
 * A flow state transformer for a call to
 * `AbstractDOMParser.setDisableDefaultEntityResolution` or
 * `SAXParser.setDisableDefaultEntityResolution`. Transforms the flow
 * state through the qualifier according to the setting in the parameter.
 */
class DisableDefaultEntityResolutionTransformer extends XxeFlowStateTransformer {
  Expr newValue;

  DisableDefaultEntityResolutionTransformer() {
    exists(Call call, Function f |
      call.getTarget() = f and
      (
        f.getDeclaringType() instanceof AbstractDomParserClass or
        f.getDeclaringType() instanceof SaxParserClass
      ) and
      f.hasName("setDisableDefaultEntityResolution") and
      this = call.getQualifier() and
      newValue = call.getArgument(0)
    )
  }

  final override TXxeFlowState transform(TXxeFlowState flowstate) {
    exists(int createEntityReferenceNodes |
      encodeXercesFlowState(flowstate, _, createEntityReferenceNodes) and
      (
        globalValueNumber(newValue).getAnExpr().getValue().toInt() = 1 and // true
        encodeXercesFlowState(result, 1, createEntityReferenceNodes)
        or
        not globalValueNumber(newValue).getAnExpr().getValue().toInt() = 1 and // false or unknown
        encodeXercesFlowState(result, 0, createEntityReferenceNodes)
      )
    )
  }
}

/**
 * A flow state transformer for a call to
 * `AbstractDOMParser.setCreateEntityReferenceNodes`. Transforms the flow
 * state through the qualifier according to the setting in the parameter.
 */
class CreateEntityReferenceNodesTransformer extends XxeFlowStateTransformer {
  Expr newValue;

  CreateEntityReferenceNodesTransformer() {
    exists(Call call, Function f |
      call.getTarget() = f and
      f.getClassAndName("setCreateEntityReferenceNodes") instanceof AbstractDomParserClass and
      this = call.getQualifier() and
      newValue = call.getArgument(0)
    )
  }

  final override TXxeFlowState transform(TXxeFlowState flowstate) {
    exists(int disabledDefaultEntityResolution |
      encodeXercesFlowState(flowstate, disabledDefaultEntityResolution, _) and
      (
        globalValueNumber(newValue).getAnExpr().getValue().toInt() = 1 and // true
        encodeXercesFlowState(result, disabledDefaultEntityResolution, 1)
        or
        not globalValueNumber(newValue).getAnExpr().getValue().toInt() = 1 and // false or unknown
        encodeXercesFlowState(result, disabledDefaultEntityResolution, 0)
      )
    )
  }
}

/**
 * The `XMLUni.fgXercesDisableDefaultEntityResolution` constant.
 */
class FeatureDisableDefaultEntityResolution extends Variable {
  FeatureDisableDefaultEntityResolution() {
    this.getName() = "fgXercesDisableDefaultEntityResolution" and
    this.getDeclaringType().getName() = "XMLUni"
  }
}

/**
 * A flow state transformer for a call to `SAX2XMLReader.setFeature`
 * specifying the feature `XMLUni::fgXercesDisableDefaultEntityResolution`.
 * Transforms the flow state through the qualifier according to this setting.
 */
class SetFeatureTransformer extends XxeFlowStateTransformer {
  Expr newValue;

  SetFeatureTransformer() {
    exists(Call call, Function f |
      call.getTarget() = f and
      f.getClassAndName("setFeature") instanceof Sax2XmlReader and
      this = call.getQualifier() and
      globalValueNumber(call.getArgument(0)).getAnExpr().(VariableAccess).getTarget() instanceof
        FeatureDisableDefaultEntityResolution and
      newValue = call.getArgument(1)
    )
  }

  final override TXxeFlowState transform(TXxeFlowState flowstate) {
    exists(int createEntityReferenceNodes |
      encodeXercesFlowState(flowstate, _, createEntityReferenceNodes) and
      (
        globalValueNumber(newValue).getAnExpr().getValue().toInt() = 1 and // true
        encodeXercesFlowState(result, 1, createEntityReferenceNodes)
        or
        not globalValueNumber(newValue).getAnExpr().getValue().toInt() = 1 and // false or unknown
        encodeXercesFlowState(result, 0, createEntityReferenceNodes)
      )
    )
  }
}

/**
 * The `DOMLSParser.getDomConfig` function.
 */
class GetDomConfig extends Function {
  GetDomConfig() { this.getClassAndName("getDomConfig") instanceof DomLSParserClass }
}

/**
 * The `DOMConfiguration.setParameter` function.
 */
class DomConfigurationSetParameter extends Function {
  DomConfigurationSetParameter() {
    this.getClassAndName("setParameter").getName() = "DOMConfiguration"
  }
}

/**
 * A flow state transformer for a call to `DOMConfiguration.setParameter`
 * specifying the feature `XMLUni::fgXercesDisableDefaultEntityResolution`.
 * This is a slightly more complex transformer because the qualifier is a
 * `DOMConfiguration` pointer returned by `DOMLSParser.getDomConfig` - and it
 * is *that* qualifier we want to transform the flow state of.
 */
class DomConfigurationSetParameterTransformer extends XxeFlowStateTransformer {
  Expr newValue;

  DomConfigurationSetParameterTransformer() {
    exists(FunctionCall getDomConfigCall, FunctionCall setParameterCall |
      // this is the qualifier of a call to `DOMLSParser.getDomConfig`.
      getDomConfigCall.getTarget() instanceof GetDomConfig and
      this = getDomConfigCall.getQualifier() and
      // `setParameterCall` is a call to `setParameter` on the return value of
      // the same call to `DOMLSParser.getDomConfig`.
      setParameterCall.getTarget() instanceof DomConfigurationSetParameter and
      globalValueNumber(setParameterCall.getQualifier()).getAnExpr() = getDomConfigCall and
      // the parameter being set is
      // `XMLUni::fgXercesDisableDefaultEntityResolution`.
      globalValueNumber(setParameterCall.getArgument(0)).getAnExpr().(VariableAccess).getTarget()
        instanceof FeatureDisableDefaultEntityResolution and
      // the value being set is `newValue`.
      newValue = setParameterCall.getArgument(1)
    )
  }

  final override TXxeFlowState transform(TXxeFlowState flowstate) {
    exists(int createEntityReferenceNodes |
      encodeXercesFlowState(flowstate, _, createEntityReferenceNodes) and
      (
        globalValueNumber(newValue).getAnExpr().getValue().toInt() = 1 and // true
        encodeXercesFlowState(result, 1, createEntityReferenceNodes)
        or
        not globalValueNumber(newValue).getAnExpr().getValue().toInt() = 1 and // false or unknown
        encodeXercesFlowState(result, 0, createEntityReferenceNodes)
      )
    )
  }
}
