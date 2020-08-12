/** Provides models of commonly used functions and types in the protobuf packages. */

import go

/** Provides models of commonly used functions and types in the protobuf packages. */
module Protobuf {
  string protobufPackages() {
    result in ["github.com/golang/protobuf/proto", "google.golang.org/protobuf/proto"]
  }

  /** The `Marshal` and `MarshalAppend` functions in the protobuf packages. */
  private class MarshalFunction extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    string name;

    MarshalFunction() {
      name = ["Marshal", "MarshalAppend"] and
      (
        this.hasQualifiedName(protobufPackages(), name) or
        this.(Method).hasQualifiedName("google.golang.org/protobuf/proto", "MarshalOptions", name)
      )
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

  private Field inputMessageField() {
    result
        .hasQualifiedName("google.golang.org/protobuf/runtime/protoiface", "MarshalInput", "Message")
  }

  private Method marshalStateMethod() {
    result
        .hasQualifiedName("google.golang.org/protobuf/runtime/protoiface", "MarshalOptions",
          "MarshalState")
  }

  /**
   * Additional taint-flow step modelling flow from MarshalInput.Message to MarshalOutput,
   * mediated by a MarshalOptions.MarshalState call.
   *
   * Note we can taint the whole MarshalOutput as it only has one field (Buf), and taint-
   * tracking always considers a field of a tainted struct to itself be tainted.
   */
  private class MarshalStateStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(
        DataFlow::Node marshalInput, DataFlow::Node passedMarshalInput,
        DataFlow::CallNode marshalStateCall
      |
        marshalStateCall = marshalStateMethod().getACall() and
        // pred -> marshalInput.Message
        any(DataFlow::Write w)
            .writesField(marshalInput.(DataFlow::PostUpdateNode).getPreUpdateNode(),
              inputMessageField(), pred) and
        // marshalInput -> passedMarshalInput
        passedMarshalInput.asExpr().getGlobalValueNumber() =
          marshalInput.asExpr().getGlobalValueNumber() and
        // passedMarshalInput -> marshalStateCall
        marshalStateCall.getArgument(0) = passedMarshalInput and
        // marshalStateCall -> succ
        marshalStateCall.getResult() = succ
      )
    }
  }

  /** The `Unmarshal` function in the protobuf packages. */
  class UnmarshalFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    UnmarshalFunction() {
      this.hasQualifiedName(protobufPackages(), "Unmarshal") or
      this
          .(Method)
          .hasQualifiedName("google.golang.org/protobuf/proto", "UnmarshalOptions", "Unmarshal")
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

  /** A `ProtoReflect` method of a protobuf `Message` type. */
  private class ProtoReflectMethod extends DataFlow::FunctionModel, Method {
    ProtoReflectMethod() { this = any(MessageType msg).getMethod("ProtoReflect") }

    override predicate hasDataFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  /**
   * Gets a field of a Message type.
   */
  private Field getAMessageField() {
    result = any(MessageType msg).getField(_)
    or
    exists(Type base | base.getPointerType() instanceof MessageType | result = base.getField(_))
  }

  /**
   * Additional taint step tainting a Message when taint is written to any of its fields.
   */
  private class WriteMessageFieldStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      any(DataFlow::Write w)
          .writesField(succ.(DataFlow::PostUpdateNode).getPreUpdateNode(), getAMessageField(), pred)
    }
  }
}
