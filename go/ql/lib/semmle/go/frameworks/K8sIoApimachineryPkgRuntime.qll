/** Provides models of commonly used functions in the `k8s.io/apimachinery/pkg/runtime` package. */

import go

/**
 * Provides models of commonly used functions in the `k8s.io/apimachinery/pkg/runtime` package.
 */
module K8sIoApimachineryPkgRuntime {
  /** Gets the package name `k8s.io/apimachinery/pkg/runtime`. */
  string packagePath() { result = package("k8s.io/apimachinery", "pkg/runtime") }

  private class DecodeInto extends UnmarshalingFunction::Range {
    DecodeInto() { this.hasQualifiedName(packagePath(), "DecodeInto") }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(1) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(2) }

    override string getFormat() {
      // The format is not fixed. It depends on parameter 1 or 2.
      none()
    }
  }

  private class Encode extends MarshalingFunction::Range {
    Encode() { this.hasQualifiedName(packagePath(), ["Encode", "EncodeOrDie"]) }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(1) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() {
      // The format is not fixed. It depends on the receiver.
      none()
    }
  }

  private class CacheableObjectCacheEncode extends MarshalingFunction::Range, Method {
    CacheableObjectCacheEncode() {
      this.implements(packagePath(), "CacheableObject", "CacheEncode")
    }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(2) }

    override string getFormat() {
      // The format is not fixed. It depends on the receiver.
      none()
    }
  }

  private class DecoderDecode extends UnmarshalingFunction::Range, Method {
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
  }

  private class EncoderEncode extends MarshalingFunction::Range, Method {
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
  }

  private class Decode extends UnmarshalingFunction::Range {
    Decode() { this.hasQualifiedName(packagePath(), "Decode") }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(1) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() {
      // The format is not fixed. It depends on the parameter 0.
      none()
    }
  }

  private class ParameterCodecDecodeParameters extends UnmarshalingFunction::Range, Method {
    ParameterCodecDecodeParameters() {
      this.implements(packagePath(), "ParameterCodec", "DecodeParameters")
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(2) }

    override string getFormat() {
      // The format is not fixed. It depends on parameter 1.
      none()
    }
  }

  private class ParameterCodecEncodeParameters extends MarshalingFunction::Range, Method {
    ParameterCodecEncodeParameters() {
      this.implements(packagePath(), "ParameterCodec", "EncodeParameters")
    }

    override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() {
      // The format is not fixed. It depends on parameter 1.
      none()
    }
  }

  private class ProtobufMarshallerMarshalTo extends MarshalingFunction::Range, Method {
    ProtobufMarshallerMarshalTo() {
      this.implements(packagePath(), "ProtobufMarshaller", "MarshalTo") or
      this.implements(packagePath(), "ProtobufReverseMarshaller", "MarshalToSizedBuffer")
    }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "protobuf" }
  }

  private class RawExtensionMarshal extends MarshalingFunction::Range, Method {
    RawExtensionMarshal() { this.hasQualifiedName(packagePath(), "RawExtension", "Marshal") }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "protobuf" }
  }

  private class RawExtensionUnmarshal extends UnmarshalingFunction::Range, Method {
    RawExtensionUnmarshal() { this.hasQualifiedName(packagePath(), "RawExtension", "Unmarshal") }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "protobuf" }
  }

  private class UnknownMarshal extends MarshalingFunction::Range, Method {
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
  }

  private class UnknownUnmarshal extends UnmarshalingFunction::Range, Method {
    UnknownUnmarshal() { this.hasQualifiedName(packagePath(), "Unknown", "Unmarshal") }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "protobuf" }
  }
}
