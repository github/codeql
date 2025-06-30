private import cpp as Language
import semmle.code.cpp.dataflow.new.TaintTracking
import codeql.quantum.experimental.Model
private import OpenSSL.GenericSourceCandidateLiteral

module CryptoInput implements InputSig<Language::Location> {
  class DataFlowNode = DataFlow::Node;

  class LocatableElement = Language::Locatable;

  class UnknownLocation = Language::UnknownDefaultLocation;

  LocatableElement dfn_to_element(DataFlow::Node node) {
    result = node.asExpr() or
    result = node.asParameter() or
    result = node.asVariable() or
    result = node.asDefiningArgument()
    // TODO: do we need asIndirectExpr()?
  }

  string locationToFileBaseNameAndLineNumberString(Location location) {
    result = location.getFile().getBaseName() + ":" + location.getStartLine()
  }

  predicate artifactOutputFlowsToGenericInput(
    DataFlow::Node artifactOutput, DataFlow::Node otherInput
  ) {
    ArtifactFlow::flow(artifactOutput, otherInput)
  }
}

module Crypto = CryptographyBase<Language::Location, CryptoInput>;

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

module ArtifactFlow = DataFlow::Global<ArtifactFlowConfig>;

/**
 * An artifact output to node input configuration
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

module GenericDataSourceFlow = TaintTracking::Global<GenericDataSourceFlowConfig>;

private class ConstantDataSource extends Crypto::GenericConstantSourceInstance instanceof OpenSslGenericSourceCandidateLiteral
{
  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    // TODO: separate config to avoid blowing up data-flow analysis
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
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

module ArtifactUniversalFlow = DataFlow::Global<ArtifactUniversalFlowConfig>;

import OpenSSL.OpenSSL
