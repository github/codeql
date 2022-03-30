/** Provides models of commonly used functions and types in the protobuf packages. */

import go

/** Provides models of commonly used functions and types in the protobuf packages. */
module Protobuf {
  /** Gets the name of the modern protobuf top-level implementation package. */
  string modernProtobufPackage() { result = package("google.golang.org/protobuf", "proto") }

  /** Gets the name of the modern protobuf implementation's `protoiface` subpackage. */
  string protobufIfacePackage() {
    result = package("google.golang.org/protobuf", "runtime/protoiface")
  }

  /** Gets the name of the modern protobuf implementation's `protoreflect` subpackage. */
  string protobufReflectPackage() {
    result = package("google.golang.org/protobuf", "reflect/protoreflect")
  }

  /** Gets the name of a top-level protobuf implementation package. */
  string protobufPackages() {
    result in [package("github.com/golang/protobuf", "proto"), modernProtobufPackage()]
  }

  /** The `Marshal` and `MarshalAppend` functions in the protobuf packages. */
  private class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    string name;

    MarshalFunction() {
      name = ["Marshal", "MarshalAppend"] and
      (
        this.hasQualifiedName(protobufPackages(), name) or
        this.(Method).hasQualifiedName(modernProtobufPackage(), "MarshalOptions", name)
      )
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
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

  private Field inputMessageField() {
    result.hasQualifiedName(protobufIfacePackage(), "MarshalInput", "Message")
  }

  private Method marshalStateMethod() {
    result.hasQualifiedName(protobufIfacePackage(), "MarshalOptions", "MarshalState")
  }

  /**
   * Additional taint-flow step modeling flow from `MarshalInput.Message` to `MarshalOutput`,
   * mediated by a `MarshalOptions.MarshalState` call.
   *
   * Note we can taint the whole `MarshalOutput` as it only has one field (`Buf`), and taint-
   * tracking always considers a field of a tainted struct to itself be tainted.
   */
  private class MarshalStateStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::PostUpdateNode marshalInput, DataFlow::CallNode marshalStateCall |
        marshalStateCall = marshalStateMethod().getACall() and
        // pred -> marshalInput.Message
        any(DataFlow::Write w)
            .writesField(marshalInput.getPreUpdateNode(), inputMessageField(), pred) and
        // marshalInput -> marshalStateCall
        marshalStateCall.getArgument(0) = globalValueNumber(marshalInput).getANode() and
        // marshalStateCall -> succ
        marshalStateCall.getResult() = succ
      )
    }
  }

  /** The `Unmarshal` function in the protobuf packages. */
  class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() {
      this.hasQualifiedName(protobufPackages(), "Unmarshal") or
      this.(Method).hasQualifiedName(modernProtobufPackage(), "UnmarshalOptions", "Unmarshal")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
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
    MessageType() { this.implements(protobufReflectPackage(), "ProtoMessage") }
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

  /** A `ProtoReflect` method of a protobuf `Message` type. */
  private class ProtoReflectMethod extends DataFlow::FunctionModel, Method {
    ProtoReflectMethod() { this = any(MessageType msg).getMethod("ProtoReflect") }

    override predicate hasDataFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  /**
   * Gets the base of `node`, looking through any dereference node found.
   */
  private DataFlow::Node getBaseLookingThroughDerefs(DataFlow::ComponentReadNode node) {
    result = node.getBase().(DataFlow::PointerDereferenceNode).getOperand()
    or
    result = node.getBase() and not node.getBase() instanceof DataFlow::PointerDereferenceNode
  }

  /**
   * Gets the data-flow node representing the bottom of a stack of zero or more `ComponentReadNode`s
   * perhaps with interleaved dereferences.
   *
   * For example, in the expression a.b[c].d[e], this would return the dataflow node for the read from `a`.
   */
  private DataFlow::Node getUnderlyingNode(DataFlow::ReadNode read) {
    (result = read or result = getBaseLookingThroughDerefs+(read)) and
    not result instanceof DataFlow::ComponentReadNode
  }

  /**
   * Additional taint step tainting a Message when taint is written to any of its fields and/or elements.
   */
  private class WriteMessageFieldStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      [succ.getType(), succ.getType().getPointerType()] instanceof MessageType and
      exists(DataFlow::ReadNode base |
        succ.(DataFlow::PostUpdateNode).getPreUpdateNode() = getUnderlyingNode(base)
      |
        any(DataFlow::Write w).writesComponent(base, pred)
      )
    }
  }
}
