private import java as Language
private import semmle.code.java.security.InsecureRandomnessQuery
private import semmle.code.java.security.RandomQuery
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSources
private import codeql.quantum.experimental.Model

private class UnknownLocation extends Language::Location {
  UnknownLocation() { this.getFile().getAbsolutePath() = "" }
}

/**
 * A dummy location which is used when something doesn't have a location in
 * the source code but needs to have a `Location` associated with it. There
 * may be several distinct kinds of unknown locations. For example: one for
 * expressions, one for statements and one for other program elements.
 */
private class UnknownDefaultLocation extends UnknownLocation {
  UnknownDefaultLocation() { locations_default(this, _, 0, 0, 0, 0) }
}

module CryptoInput implements InputSig<Language::Location> {
  class DataFlowNode = DataFlow::Node;

  class LocatableElement = Language::Element;

  class UnknownLocation = UnknownDefaultLocation;

  string locationToFileBaseNameAndLineNumberString(Location location) {
    result = location.getFile().getBaseName() + ":" + location.getStartLine()
  }

  LocatableElement dfn_to_element(DataFlow::Node node) {
    result = node.asExpr() or
    result = node.asParameter()
  }

  predicate artifactOutputFlowsToGenericInput(
    DataFlow::Node artifactOutput, DataFlow::Node otherInput
  ) {
    ArtifactFlow::flow(artifactOutput, otherInput)
  }
}

// Instantiate the `CryptographyBase` module
module Crypto = CryptographyBase<Language::Location, CryptoInput>;

// Definitions of various generic sources
final class DefaultFlowSource = SourceNode;

final class DefaultRemoteFlowSource = RemoteFlowSource;

private class GenericUnreferencedParameterSource extends Crypto::GenericUnreferencedParameterSource {
  GenericUnreferencedParameterSource() {
    exists(Parameter p | this = p and not exists(p.getAnArgument()))
  }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override DataFlow::Node getOutputNode() { result.asParameter() = this }

  override string getAdditionalDescription() { result = this.toString() }
}

private class GenericLocalDataSource extends Crypto::GenericLocalDataSource {
  GenericLocalDataSource() {
    any(DefaultFlowSource src | not src instanceof DefaultRemoteFlowSource).asExpr() = this
  }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

private class GenericRemoteDataSource extends Crypto::GenericRemoteDataSource {
  GenericRemoteDataSource() { any(DefaultRemoteFlowSource src).asExpr() = this }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

private class ConstantDataSource extends Crypto::GenericConstantSourceInstance instanceof Literal {
  ConstantDataSource() {
    // TODO: this is an API specific workaround for JCA, as 'EC' is a constant that may be used
    // where typical algorithms are specified, but EC specifically means set up a
    // default curve container, that will later be specified explicitly (or if not a default)
    // curve is used.
    this.getValue() != "EC"
  }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    // TODO: separate config to avoid blowing up data-flow analysis
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

/**
 * An instance of random number generation, modelled as the expression
 * tied to an output node (i.e., the result of the source of randomness)
 */
abstract class RandomnessInstance extends Crypto::RandomNumberGenerationInstance {
  override DataFlow::Node getOutputNode() { result.asExpr() = this }
}

private class SecureRandomnessInstance extends RandomnessInstance {
  RandomDataSource source;

  SecureRandomnessInstance() {
    this = source.getOutput() and
    source.getSourceOfRandomness() instanceof SecureRandomNumberGenerator
  }

  override string getGeneratorName() { result = source.getSourceOfRandomness().getQualifiedName() }
}

private class InsecureRandomnessInstance extends RandomnessInstance {
  RandomDataSource source;

  InsecureRandomnessInstance() {
    any(InsecureRandomnessSource src).asExpr() = this and source.getOutput() = this
  }

  override string getGeneratorName() { result = source.getSourceOfRandomness().getQualifiedName() }
}

/**
 * An additional flow step in generic data-flow configurations.
 * Where a step is an edge between nodes `n1` and `n2`,
 * `this` = `n1` and `getOutput()` = `n2`.
 *
 * FOR INTERNAL MODELING USE ONLY.
 */
abstract class AdditionalFlowInputStep extends DataFlow::Node {
  abstract DataFlow::Node getOutput();

  final DataFlow::Node getInput() { result = this }
}

/**
 * Generic data source to node input configuration
 */
module GenericDataSourceFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::GenericSourceInstance i).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Crypto::FlowAwareElement other).getInputNode()
  }

  predicate isBarrierOut(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getInputNode()
  }

  predicate isBarrierIn(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getOutputNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.(AdditionalFlowInputStep).getOutput() = node2
    or
    exists(MethodCall m |
      m.getMethod().hasQualifiedName("java.lang", "String", "getBytes") and
      node1.asExpr() = m.getQualifier() and
      node2.asExpr() = m
    )
  }
}

module ArtifactFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::ArtifactInstance artifact).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Crypto::FlowAwareElement other).getInputNode()
  }

  predicate isBarrierOut(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getInputNode()
  }

  predicate isBarrierIn(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getOutputNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.(AdditionalFlowInputStep).getOutput() = node2
    or
    exists(MethodCall m |
      m.getMethod().hasQualifiedName("java.lang", "String", "getBytes") and
      node1.asExpr() = m.getQualifier() and
      node2.asExpr() = m
    )
  }
}

module GenericDataSourceFlow = TaintTracking::Global<GenericDataSourceFlowConfig>;

module ArtifactFlow = DataFlow::Global<ArtifactFlowConfig>;

// Import library-specific modeling
import JCA
