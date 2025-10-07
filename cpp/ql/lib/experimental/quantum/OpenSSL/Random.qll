import cpp
private import experimental.quantum.Language
private import LibraryDetector
private import semmle.code.cpp.dataflow.new.DataFlow

class OpenSslRandomNumberGeneratorInstance extends Crypto::RandomNumberGenerationInstance instanceof Call
{
  OpenSslRandomNumberGeneratorInstance() {
    this.(Call).getTarget().getName() in ["RAND_bytes", "RAND_pseudo_bytes"]
  }

  override Crypto::DataFlowNode getOutputNode() {
    result.asDefiningArgument() = this.(Call).getArgument(0)
  }

  override string getGeneratorName() { result = this.(Call).getTarget().getName() }
}
