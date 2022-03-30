/**
 * Provides classes and predicates for working with base64 encoders and decoders.
 */

import javascript

module Base64 {
  /** A call to a base64 encoder. */
  class Encode extends DataFlow::Node instanceof Encode::Range {
    /** Gets the input passed to the encoder. */
    DataFlow::Node getInput() { result = super.getInput() }

    /** Gets the base64-encoded output of the encoder. */
    DataFlow::Node getOutput() { result = super.getOutput() }
  }

  module Encode {
    /**
     * A data flow node that should be considered a call to a base64 encoder.
     *
     * New base64 encoding functions can be supported by extending this class.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the input passed to the encoder. */
      abstract DataFlow::Node getInput();

      /** Gets the base64-encoded output of the encoder. */
      abstract DataFlow::Node getOutput();
    }
  }

  /** A call to a base64 decoder. */
  class Decode extends DataFlow::Node instanceof Decode::Range {
    /** Gets the base64-encoded input passed to the decoder. */
    DataFlow::Node getInput() { result = super.getInput() }

    /** Gets the output of the decoder. */
    DataFlow::Node getOutput() { result = super.getOutput() }
  }

  module Decode {
    /**
     * A data flow node that should be considered a call to a base64 decoder.
     *
     * New base64 decoding functions can be supported by extending this class.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the base64-encoded input passed to the decoder. */
      abstract DataFlow::Node getInput();

      /** Gets the output of the decoder. */
      abstract DataFlow::Node getOutput();
    }
  }

  /**
   * A base64 decoding step, viewed as a taint-propagating data flow edge.
   *
   * Note that we currently do not model base64 encoding as a taint-propagating data flow edge
   * to avoid false positives.
   */
  private class Base64DecodingStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Decode dec |
        pred = dec.getInput() and
        succ = dec.getOutput()
      )
    }
  }
}

/** A call to `btoa`. */
private class Btoa extends Base64::Encode::Range, DataFlow::CallNode {
  Btoa() { this = DataFlow::globalVarRef("btoa").getACall() }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::Node getOutput() { result = this }
}

/** A call to `atob`. */
private class Atob extends Base64::Decode::Range, DataFlow::CallNode {
  Atob() { this = DataFlow::globalVarRef("atob").getACall() }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::Node getOutput() { result = this }
}

/**
 * A call to `Buffer.prototype.toString` with encoding `base64`, approximated by
 * looking for calls to `toString` where the first argument is the string `"base64"`.
 */
private class Buffer_toString extends Base64::Encode::Range, DataFlow::MethodCallNode {
  Buffer_toString() {
    getMethodName() = "toString" and
    getArgument(0).mayHaveStringValue("base64")
  }

  override DataFlow::Node getInput() { result = getReceiver() }

  override DataFlow::Node getOutput() { result = this }
}

/** A call to `Buffer.from` with encoding `base64`. */
private class Buffer_from extends Base64::Decode::Range, DataFlow::CallNode {
  Buffer_from() {
    this = DataFlow::globalVarRef("Buffer").getAMemberCall("from") and
    getArgument(1).mayHaveStringValue("base64")
  }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::Node getOutput() { result = this }
}

/**
 * A call to a base64 encoding function from one of the npm packages
 * `base-64`, `js-base64`, `Base64`, or `base64-js`.
 */
private class NpmBase64Encode extends Base64::Encode::Range, DataFlow::CallNode {
  NpmBase64Encode() {
    exists(DataFlow::SourceNode enc |
      enc = DataFlow::moduleImport("b64u") or
      enc = DataFlow::moduleImport("b64url") or
      enc = DataFlow::moduleImport("btoa") or
      enc = DataFlow::moduleMember("Base64", "btoa") or
      enc = DataFlow::moduleMember("abab", "btoa") or
      enc = DataFlow::moduleMember("b2a", "btoa") or
      enc = DataFlow::moduleMember("b64-lite", "btoa") or
      enc = DataFlow::moduleMember("b64-lite", "toBase64") or
      enc = DataFlow::moduleMember("b64u", "encode") or
      enc = DataFlow::moduleMember("b64u", "toBase64") or
      enc = DataFlow::moduleMember("b64u-lite", "toBase64Url") or
      enc = DataFlow::moduleMember("b64u-lite", "toBinaryString") or
      enc = DataFlow::moduleMember("b64url", "encode") or
      enc = DataFlow::moduleMember("b64url", "toBase64") or
      enc = DataFlow::moduleMember("base-64", "encode") or
      enc = DataFlow::moduleMember("base64-js", "toByteArray") or
      enc = DataFlow::moduleMember("base64-url", "encode") or
      enc = DataFlow::moduleMember("base64url", "encode") or
      enc = DataFlow::moduleMember("base64url", "toBase64") or
      enc = DataFlow::moduleMember("js-base64", "Base64").getAPropertyRead("encode") or
      enc = DataFlow::moduleMember("js-base64", "Base64").getAPropertyRead("encodeURI") or
      enc = DataFlow::moduleMember("urlsafe-base64", "encode") or
      enc = DataFlow::moduleMember("react-native-base64", ["encode", "encodeFromByteArray"])
    |
      this = enc.getACall()
    )
  }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::Node getOutput() { result = this }
}

/**
 * A call to a base64 decoding function from one of the npm packages
 * `base-64`, `js-base64`, `Base64`, or `base64-js`.
 */
private class NpmBase64Decode extends Base64::Decode::Range, DataFlow::CallNode {
  NpmBase64Decode() {
    exists(DataFlow::SourceNode dec |
      dec = DataFlow::moduleImport("atob") or
      dec = DataFlow::moduleMember("Base64", "atob") or
      dec = DataFlow::moduleMember("abab", "atob") or
      dec = DataFlow::moduleMember("b2a", "atob") or
      dec = DataFlow::moduleMember("b64-lite", "atob") or
      dec = DataFlow::moduleMember("b64-lite", "fromBase64") or
      dec = DataFlow::moduleMember("b64u", "decode") or
      dec = DataFlow::moduleMember("b64u", "fromBase64") or
      dec = DataFlow::moduleMember("b64u-lite", "fromBase64Url") or
      dec = DataFlow::moduleMember("b64u-lite", "fromBinaryString") or
      dec = DataFlow::moduleMember("b64url", "decode") or
      dec = DataFlow::moduleMember("b64url", "fromBase64") or
      dec = DataFlow::moduleMember("base-64", "decode") or
      dec = DataFlow::moduleMember("base64-js", "fromByteArray") or
      dec = DataFlow::moduleMember("base64-url", "decode") or
      dec = DataFlow::moduleMember("base64url", "decode") or
      dec = DataFlow::moduleMember("base64url", "fromBase64") or
      dec = DataFlow::moduleMember("js-base64", "Base64").getAPropertyRead("decode") or
      dec = DataFlow::moduleMember("urlsafe-base64", "decode") or
      dec = DataFlow::moduleMember("react-native-base64", "decode")
    |
      this = dec.getACall()
    )
  }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::Node getOutput() { result = this }
}
