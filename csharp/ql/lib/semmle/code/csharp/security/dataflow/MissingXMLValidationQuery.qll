/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input processed as XML
 * without validation against a known schema.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.system.Xml
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for untrusted user input processed as XML without validation against a known
 * schema.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for untrusted user input processed as XML without validation against a known
 * schema.
 */
abstract class Sink extends ApiSinkExprNode {
  /** Gets a string describing the reason why this is a sink. */
  abstract string getReason();
}

/**
 * A sanitizer for untrusted user input processed as XML without validation against a known schema.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * DEPRECATED: Use `MissingXxmlValidation` instead.
 *
 * A taint-tracking configuration for untrusted user input processed as XML without validation against a
 * known schema.
 */
deprecated class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "MissingXMLValidation" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking configuration for untrusted user input processed as XML without validation against a
 * known schema.
 */
private module MissingXmlValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { exists(sink.(Sink).getReason()) }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for untrusted user input processed as XML without validation against a
 * known schema.
 */
module MissingXmlValidation = TaintTracking::Global<MissingXmlValidationConfig>;

/**
 * DEPRECATED: Use `ThreatModelFlowSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/**
 * A source supported by the current threat model.
 */
class ThreatModelSource extends Source instanceof ThreatModelFlowSource { }

/**
 * The input argument to a call to `XmlReader.Create` where the input will not be validated against
 * a schema.
 */
class XmlReaderCreateCallSink extends Sink {
  XmlReaderCreateCall createCall;

  XmlReaderCreateCallSink() {
    // This is the XML that will be processed
    this.getExpr() = createCall.getArgumentForName("input")
  }

  override string getReason() {
    // No settings = no Schema validation
    result = "there is no 'XmlReaderSettings' instance specifying schema validation." and
    not exists(createCall.getSettings())
    or
    // An XmlReaderSettings instance is passed where:
    //  - The ValidationType is not set to Schema; or
    //  - The ValidationType is set to Schema, but:
    //     - The ProcessInlineSchema option is set (this allows the document to set a schema
    //       internally); or
    //     - The ProcessSchemaLocation option is set (this allows the document to reference a
    //       schema by location that this document will validate against).
    result = "the 'XmlReaderSettings' instance does not specify the 'ValidationType' as 'Schema'." and
    exists(XmlReaderSettingsCreation settingsCreation |
      settingsCreation = createCall.getSettings().getASettingsCreation()
    |
      not settingsCreation.getValidationType().hasName("Schema")
    )
    or
    exists(string badValidationFlag |
      result = "the 'XmlReaderSettings' instance specifies '" + badValidationFlag + "'." and
      exists(XmlReaderSettingsCreation settingsCreation |
        settingsCreation = createCall.getSettings().getASettingsCreation() and
        settingsCreation.getValidationType().hasName("Schema") and
        settingsCreation.getAValidationFlag().hasName(badValidationFlag)
      |
        badValidationFlag = "ProcessInlineSchema" or
        badValidationFlag = "ProcessSchemaLocation"
      )
    )
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
