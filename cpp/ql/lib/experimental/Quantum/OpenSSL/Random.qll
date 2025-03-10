import cpp
private import experimental.Quantum.Language
private import codeql.cryptography.Model
private import LibraryDetector
private import semmle.code.cpp.dataflow.new.DataFlow

class OpenSSLRandomNumberGeneratorInstance extends Crypto::RandomNumberGenerationInstance instanceof Call
{
  OpenSSLRandomNumberGeneratorInstance() {
    this.(Call).getTarget().getName() in ["RAND_bytes", "RAND_pseudo_bytes"] and
    isPossibleOpenSSLFunction(this.(Call).getTarget())
  }

  override Crypto::DataFlowNode getOutputNode() {
    result.asDefiningArgument() = this.(Call).getArgument(0)
  }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    ArtifactUniversalFlow::flow(this.getOutputNode(), other.getInputNode())
  }
}
