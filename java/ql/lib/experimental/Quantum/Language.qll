private import codeql.cryptography.Model
private import java as Language
private import semmle.code.java.security.InsecureRandomnessQuery
private import semmle.code.java.security.RandomQuery
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSources

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

  LocatableElement dfn_to_element(DataFlow::Node node) {
    result = node.asExpr() or
    result = node.asParameter()
  }
}

/**
 * Instantiate the model
 */
module Crypto = CryptographyBase<Language::Location, CryptoInput>;

/**
 * Definitions of various generic data sources
 */
final class DefaultFlowSource = SourceNode;

final class DefaultRemoteFlowSource = RemoteFlowSource;

class GenericLocalDataSource extends Crypto::GenericLocalDataSource {
  GenericLocalDataSource() {
    any(DefaultFlowSource src | not src instanceof DefaultRemoteFlowSource).asExpr() = this
  }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    GenericDataSourceUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

class GenericRemoteDataSource extends Crypto::GenericRemoteDataSource {
  GenericRemoteDataSource() { any(DefaultRemoteFlowSource src).asExpr() = this }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    GenericDataSourceUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

class ConstantDataSource extends Crypto::GenericConstantOrAllocationSource instanceof Literal {
  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    // TODO: separate config to avoid blowing up data-flow analysis
    GenericDataSourceUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

/**
 * Random number generation, where each instance is modelled as the expression
 * tied to an output node (i.e., the result of the source of randomness)
 */
abstract class RandomnessInstance extends Crypto::RandomNumberGenerationInstance {
  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    ArtifactUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
  }
}

class SecureRandomnessInstance extends RandomnessInstance {
  SecureRandomnessInstance() {
    exists(RandomDataSource s | this = s.getOutput() |
      s.getSourceOfRandomness() instanceof SecureRandomNumberGenerator
    )
  }
}

class InsecureRandomnessInstance extends RandomnessInstance {
  InsecureRandomnessInstance() { exists(InsecureRandomnessSource node | this = node.asExpr()) }
}

/**
 * Output artifact flow logic
 */
abstract class DigestArtifactInstance extends Crypto::DigestArtifactInstance {
  override predicate flowsTo(Crypto::FlowAwareElement other) {
    ArtifactUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override predicate isConsumerArtifact() { none() }
}

/**
 * Artifact output to node input configuration
 */
abstract class AdditionalFlowInputStep extends DataFlow::Node {
  abstract DataFlow::Node getOutput();

  final DataFlow::Node getInput() { result = this }
}

module ArtifactUniversalFlow = DataFlow::Global<ArtifactUniversalFlowConfig>;

abstract class CipherOutputArtifact extends Crypto::CipherOutputArtifactInstance {
  override predicate flowsTo(Crypto::FlowAwareElement other) {
    ArtifactUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override predicate isConsumerArtifact() { none() }
}

/**
 * Generic data source to node input configuration
 */
module GenericDataSourceUniversalFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::GenericDataSourceInstance i).getOutputNode()
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
  }
}

module ArtifactUniversalFlowConfig implements DataFlow::ConfigSig {
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
  }
}

module GenericDataSourceUniversalFlow = DataFlow::Global<GenericDataSourceUniversalFlowConfig>;

// Import library-specific modeling
import JCA
