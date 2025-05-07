import cpp
private import experimental.quantum.Language
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

  override string getGeneratorName() { result = this.(Call).getTarget().getName() }
}
