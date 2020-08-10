/** Provides models of commonly used functions and types in the protobuf packages. */

import go

/** Provides models of commonly used functions and types in the protobuf packages. */
module Protobuf {
  pragma[inline]
  string protobufPackages() {
    result in ["github.com/golang/protobuf/proto", "google.golang.org/protobuf/proto"]
  }

  /** The `Marshal`, `MarshalAppend`, or `MarshalState` functions in the protobuf packages. */
  private class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    string name;

    MarshalFunction() {
      name = ["Marshal", "MarshalAppend", "MarshalState"] and
      this.hasQualifiedName(protobufPackages(), name)
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() {
      if name = "MarshalAppend" then result.isParameter(1) else result.isParameter(0)
    }

    override DataFlow::FunctionOutput getOutput() {
      name = "MarshalAppend" and result.isParameter(0)
      or
      result.isResult(0)
    }

    override string getFormat() { result = "protobuf" }
  }

  /** The `Unmarshal` or `UnmarshalState` functions in the protobuf packages. */
  class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    string name;

    UnmarshalFunction() {
      name = ["Unmarshal", "UnmarshalState"] and
      this.hasQualifiedName(protobufPackages(), name)
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = getAnInput() and outp = getOutput()
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "protobuf" }
  }

  /** The `Merge` function in the protobuf packages. */
  private class MergeFunction extends TaintTracking::FunctionModel {
    MergeFunction() { this.hasQualifiedName(protobufPackages(), "Merge") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(1) and outp.isParameter(0)
    }
  }

  /** A protobuf `Message` type. */
  class MessageType extends Type {
    MessageType() {
      this.implements("google.golang.org/protobuf/reflect/protoreflect", "ProtoMessage")
    }
  }

  /** The `Clone` function in the protobuf packages. */
  private class MessageCloneFunction extends TaintTracking::FunctionModel {
    MessageCloneFunction() { this.hasQualifiedName(protobufPackages(), "Clone") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  /** A `Get` method of a protobuf `Message` type. */
  private class GetMethod extends DataFlow::FunctionModel, Method {
    GetMethod() {
      exists(string name | name.matches("Get%") | this = any(MessageType msg).getMethod(name))
    }

    override predicate hasDataFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }
}
