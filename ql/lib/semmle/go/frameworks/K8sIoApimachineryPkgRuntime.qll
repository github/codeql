/** Provides models of commonly used functions in the `k8s.io/apimachinery/pkg/runtime` package. */

import go

/**
 * Provides models of commonly used functions in the `k8s.io/apimachinery/pkg/runtime` package.
 */
module K8sIoApimachineryPkgRuntime {
  /** Gets the package name `k8s.io/apimachinery/pkg/runtime`. */
  string packagePath() { result = package("k8s.io/apimachinery", "pkg/runtime") }

  private class ConvertTypeToType extends TaintTracking::FunctionModel {
    ConvertTypeToType() {
      this.hasQualifiedName(packagePath(),
        [
          "Convert_Slice_string_To_Pointer_int64", "Convert_Slice_string_To_int",
          "Convert_Slice_string_To_int64", "Convert_Slice_string_To_string",
          "Convert_runtime_Object_To_runtime_RawExtension",
          "Convert_runtime_RawExtension_To_runtime_Object", "Convert_string_To_Pointer_int64",
          "Convert_string_To_int64"
        ])
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isParameter(1)
    }
  }

  private class DecodeInto extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    DecodeInto() { this.hasQualifiedName(packagePath(), "DecodeInto") }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(1) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(2) }

    override string getFormat() {
      // The format is not fixed. It depends on parameter 1 or 2.
      none()
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class DeepCopyJSON extends TaintTracking::FunctionModel {
    DeepCopyJSON() { this.hasQualifiedName(packagePath(), ["DeepCopyJSON", "DeepCopyJSONValue"]) }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  private class Encode extends TaintTracking::FunctionModel, MarshalingFunction::Range {
    Encode() { this.hasQualifiedName(packagePath(), ["Encode", "EncodeOrDie"]) }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(1) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() {
      // The format is not fixed. It depends on the receiver.
      none()
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class ReadField extends TaintTracking::FunctionModel {
    ReadField() { this.hasQualifiedName(packagePath(), ["Field", "FieldPtr"]) }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isParameter(2)
    }
  }

  private class SetField extends TaintTracking::FunctionModel {
    SetField() { this.hasQualifiedName(packagePath(), "SetField") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isParameter(1)
    }
  }

  private class CacheableObjectCacheEncode extends TaintTracking::FunctionModel, Method,
    MarshalingFunction::Range {
    CacheableObjectCacheEncode() {
      this.implements(packagePath(), "CacheableObject", "CacheEncode")
    }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(2) }

    override string getFormat() {
      // The format is not fixed. It depends on the receiver.
      none()
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class CacheableObjectGetObject extends TaintTracking::FunctionModel, Method {
    CacheableObjectGetObject() { this.implements(packagePath(), "CacheableObject", "GetObject") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class DecoderDecode extends TaintTracking::FunctionModel, Method,
    UnmarshalingFunction::Range {
    DecoderDecode() {
      this.implements(packagePath(), "Decoder", "Decode") or
      this.hasQualifiedName(packagePath(), "WithoutVersionDecoder", "Decode")
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(2) or result.isResult(0) }

    override string getFormat() {
      // The format is not fixed. It depends on the receiver.
      none()
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class EncoderEncode extends TaintTracking::FunctionModel, Method,
    MarshalingFunction::Range {
    EncoderEncode() {
      this.implements(packagePath(), "Encoder", "Encode") or
      this.hasQualifiedName(packagePath(), "WithVersionEncoder", "Encode")
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() {
      // The format is not fixed. It depends on the receiver.
      none()
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class FramerNewFrameReader extends TaintTracking::FunctionModel, Method {
    FramerNewFrameReader() { this.implements(packagePath(), "Framer", "NewFrameReader") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  private class FramerNewFrameWriter extends TaintTracking::FunctionModel, Method {
    FramerNewFrameWriter() { this.implements(packagePath(), "Framer", "NewFrameWriter") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }

  private class ObjectDeepCopyObject extends TaintTracking::FunctionModel, Method {
    ObjectDeepCopyObject() { this.implements(packagePath(), "Object", "DeepCopyObject") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class Decode extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {
    Decode() { this.hasQualifiedName(packagePath(), "Decode") }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(1) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() {
      // The format is not fixed. It depends on the parameter 0.
      none()
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class NewEncodable extends TaintTracking::FunctionModel {
    NewEncodable() { this.hasQualifiedName(packagePath(), ["NewEncodable", "NewEncodableList"]) }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(1) and outp.isResult()
    }
  }

  private class UseOrCreateObject extends TaintTracking::FunctionModel {
    UseOrCreateObject() { this.hasQualifiedName(packagePath(), "UseOrCreateObject") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(3) and outp.isResult(0)
    }
  }

  private class ObjectConvertorConvert extends TaintTracking::FunctionModel, Method {
    ObjectConvertorConvert() { this.implements(packagePath(), "ObjectConvertor", "Convert") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isParameter(1)
    }
  }

  private class ObjectConvertorConvertToVersion extends TaintTracking::FunctionModel, Method {
    ObjectConvertorConvertToVersion() {
      this.implements(packagePath(), "ObjectConvertor", "ConvertToVersion")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
  }

  private class ObjectVersionerConvertToVersion extends TaintTracking::FunctionModel, Method {
    ObjectVersionerConvertToVersion() {
      this.implements(packagePath(), "ObjectVersioner", "ConvertToVersion")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult(0)
    }
  }

  private class ParameterCodecDecodeParameters extends TaintTracking::FunctionModel, Method,
    UnmarshalingFunction::Range {
    ParameterCodecDecodeParameters() {
      this.implements(packagePath(), "ParameterCodec", "DecodeParameters")
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(2) }

    override string getFormat() {
      // The format is not fixed. It depends on parameter 1.
      none()
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class ParameterCodecEncodeParameters extends TaintTracking::FunctionModel, Method,
    MarshalingFunction::Range {
    ParameterCodecEncodeParameters() {
      this.implements(packagePath(), "ParameterCodec", "EncodeParameters")
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() {
      // The format is not fixed. It depends on parameter 1.
      none()
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class ProtobufMarshallerMarshalTo extends TaintTracking::FunctionModel, Method,
    MarshalingFunction::Range {
    ProtobufMarshallerMarshalTo() {
      this.implements(packagePath(), "ProtobufMarshaller", "MarshalTo") or
      this.implements(packagePath(), "ProtobufReverseMarshaller", "MarshalToSizedBuffer")
    }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "protobuf" }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class RawExtensionDeepCopy extends TaintTracking::FunctionModel, Method {
    RawExtensionDeepCopy() { this.hasQualifiedName(packagePath(), "RawExtension", "DeepCopy") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class RawExtensionDeepCopyInto extends TaintTracking::FunctionModel, Method {
    RawExtensionDeepCopyInto() {
      this.hasQualifiedName(packagePath(), "RawExtension", "DeepCopyInto")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  private class RawExtensionMarshal extends TaintTracking::FunctionModel, Method,
    MarshalingFunction::Range {
    RawExtensionMarshal() { this.hasQualifiedName(packagePath(), "RawExtension", "Marshal") }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "protobuf" }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class RawExtensionUnmarshal extends TaintTracking::FunctionModel, Method,
    UnmarshalingFunction::Range {
    RawExtensionUnmarshal() { this.hasQualifiedName(packagePath(), "RawExtension", "Unmarshal") }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "protobuf" }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class UnknownDeepCopy extends TaintTracking::FunctionModel, Method {
    UnknownDeepCopy() {
      this.hasQualifiedName(packagePath(), "Unknown", ["DeepCopy", "DeepCopyObject"])
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class UnknownDeepCopyInto extends TaintTracking::FunctionModel, Method {
    UnknownDeepCopyInto() { this.hasQualifiedName(packagePath(), "Unknown", "DeepCopyInto") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  private class UnknownMarshal extends TaintTracking::FunctionModel, Method,
    MarshalingFunction::Range {
    string methodName;

    UnknownMarshal() {
      methodName in ["Marshal", "NestedMarshalTo"] and
      this.hasQualifiedName(packagePath(), "Unknown", methodName)
    }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() {
      methodName = "Marshal" and result.isResult(0)
      or
      methodName = "NestedMarshalTo" and result.isParameter(0)
    }

    override string getFormat() { result = "protobuf" }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class UnknownUnmarshal extends TaintTracking::FunctionModel, Method,
    UnmarshalingFunction::Range {
    UnknownUnmarshal() { this.hasQualifiedName(packagePath(), "Unknown", "Unmarshal") }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "protobuf" }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class UnstructuredUnstructuredContent extends TaintTracking::FunctionModel, Method {
    UnstructuredUnstructuredContent() {
      this.implements(packagePath(), "Unstructured", "UnstructuredContent")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class UnstructuredSetUnstructuredContent extends TaintTracking::FunctionModel, Method {
    UnstructuredSetUnstructuredContent() {
      this.implements(packagePath(), "Unstructured", "SetUnstructuredContent")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isParameter(0) and outp.isReceiver()
    }
  }
}
