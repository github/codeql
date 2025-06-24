private import csharp as Language
private import semmle.code.csharp.dataflow.DataFlow
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
  class DataFlowNode = Language::DataFlow::Node;

  class LocatableElement = Language::Element;

  class UnknownLocation = UnknownDefaultLocation;

  string locationToFileBaseNameAndLineNumberString(Language::Location location) {
    result = location.getFile().getBaseName() + ":" + location.getStartLine()
  }

  LocatableElement dfn_to_element(Language::DataFlow::Node node) {
    result = node.asExpr() or
    result = node.asParameter()
  }

  predicate artifactOutputFlowsToGenericInput(
    Language::DataFlow::Node artifactOutput, Language::DataFlow::Node otherInput
  ) {
    ArtifactFlow::flow(artifactOutput, otherInput)
  }
}

// Instantiate the `CryptographyBase` module
module Crypto = CryptographyBase<Language::Location, CryptoInput>;

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
  }
}

module GenericDataSourceFlow = TaintTracking::Global<GenericDataSourceFlowConfig>;

module ArtifactFlow = DataFlow::Global<ArtifactFlowConfig>;

/**
 * A method access that returns random data or writes random data to an argument.
 */
abstract class RandomnessSource extends MethodCall {
  /**
   * Gets the expression representing the output of this source.
   */
  abstract Expr getOutput();

  /**
   * Gets the type of the source of randomness used by this call.
   */
  Type getGenerator() { result = this.getQualifier().getType() }
}

/**
 * A call to `System.Security.Cryptography.RandomNumberGenerator.GetBytes`.
 */
class SecureRandomnessSource extends RandomnessSource {
  SecureRandomnessSource() {
    this.getTarget()
        .hasFullyQualifiedName("System.Security.Cryptography", "RandomNumberGenerator", "GetBytes")
  }

  override Expr getOutput() { result = this.getArgument(0) }
}

/**
 * A call to `System.Random.NextBytes`.
 */
class InsecureRandomnessSource extends RandomnessSource {
  InsecureRandomnessSource() {
    this.getTarget().hasFullyQualifiedName("System", "Random", "NextBytes")
  }

  override Expr getOutput() { result = this.getArgument(0) }
}

/**
 * An instance of random number generation, modelled as the expression
 * tied to an output node (i.e., the RNG output)
 */
abstract class RandomnessInstance extends Crypto::RandomNumberGenerationInstance {
  override DataFlow::Node getOutputNode() { result.asExpr() = this }
}

/**
 * An output instance from the system cryptographically secure RNG.
 */
class SecureRandomnessInstance extends RandomnessInstance {
  RandomnessSource source;

  SecureRandomnessInstance() {
    source instanceof SecureRandomnessSource and
    this = source.getOutput()
  }

  override string getGeneratorName() { result = source.getGenerator().getName() }
}

/**
 * An output instance from an insecure RNG.
 */
class InsecureRandomnessInstance extends RandomnessInstance {
  RandomnessSource source;

  InsecureRandomnessInstance() {
    not source instanceof SecureRandomnessSource and
    this = source.getOutput()
  }

  override string getGeneratorName() { result = source.getGenerator().getName() }
}

import dotnet
