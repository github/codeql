private import codeql.cryptography.Model
import semmle.code.cpp.ir.IR
import semmle.code.cpp.security.FlowSources as FlowSources
private import cpp as Lang

module CryptoInput implements InputSig<Lang::Location> {
  class DataFlowNode = DataFlow::Node;

  class LocatableElement = Lang::Locatable;

  class UnknownLocation = Lang::UnknownDefaultLocation;

  LocatableElement dfn_to_element(DataFlow::Node node) {
    result = node.asExpr() or
    result = node.asParameter() or
    result = node.asVariable()
  }
}

module Crypto = CryptographyBase<Lang::Location, CryptoInput>;

/**
 * Artifact output to node input configuration
 */
abstract class AdditionalFlowInputStep extends DataFlow::Node {
  abstract DataFlow::Node getOutput();

  final DataFlow::Node getInput() { result = this }
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

// // // TODO: I think this will be inefficient, no?
// // class ConstantDataSource extends Crypto::GenericConstantOrAllocationSource instanceof Literal {
// //   override DataFlow::Node getOutputNode() {
// //     result.asExpr() = this
// //   }
// //   override predicate flowsTo(Crypto::FlowAwareElement other) {
// //     // TODO: separate config to avoid blowing up data-flow analysis
// //     GenericDataSourceUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
// //   }
// //   override string getAdditionalDescription() { result = this.toString() }
// // }
// /**
//  * Definitions of various generic data sources
//  */
// // final class DefaultFlowSource = SourceNode;
// // final class DefaultRemoteFlowSource = RemoteFlowSource;
// // class GenericLocalDataSource extends Crypto::GenericLocalDataSource {
// //   GenericLocalDataSource() {
// //     any(DefaultFlowSource src | not src instanceof DefaultRemoteFlowSource).asExpr() = this
// //   }
// //   override DataFlow::Node getOutputNode() { result.asExpr() = this }
// //   override predicate flowsTo(Crypto::FlowAwareElement other) {
// //     GenericDataSourceUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
// //   }
// //   override string getAdditionalDescription() { result = this.toString() }
// // }
// // class GenericRemoteDataSource extends Crypto::GenericRemoteDataSource {
// //   GenericRemoteDataSource() { any(DefaultRemoteFlowSource src).asExpr() = this }
// //   override DataFlow::Node getOutputNode() { result.asExpr() = this }
// //   override predicate flowsTo(Crypto::FlowAwareElement other) {
// //     GenericDataSourceUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
// //   }
// //   override string getAdditionalDescription() { result = this.toString() }
// // }
// module GenericDataSourceUniversalFlow = DataFlow::Global<GenericDataSourceUniversalFlowConfig>;
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

abstract class CipherOutputArtifact extends Crypto::KeyOperationOutputArtifactInstance {
  override predicate flowsTo(Crypto::FlowAwareElement other) {
    ArtifactUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
  }
}

import OpenSSL.OpenSSL
