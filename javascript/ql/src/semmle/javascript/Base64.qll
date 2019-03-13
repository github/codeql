/**
 * Provides classes and predicates for working with base64 encoders and decoders.
 */

import javascript

module Base64 {
  /** A call to a base64 encoder. */
  class Encode extends DataFlow::Node {
    Encode::Range encode;

    Encode() { this = encode }

    /** Gets the input passed to the encoder. */
    DataFlow::Node getInput() { result = encode.getInput() }

    /** Gets the base64-encoded output of the encoder. */
    DataFlow::Node getOutput() { result = encode.getOutput() }
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
  class Decode extends DataFlow::Node {
    Decode::Range encode;

    Decode() { this = encode }

    /** Gets the base64-encoded input passed to the decoder. */
    DataFlow::Node getInput() { result = encode.getInput() }

    /** Gets the output of the decoder. */
    DataFlow::Node getOutput() { result = encode.getOutput() }
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
  private class Base64DecodingStep extends TaintTracking::AdditionalTaintStep {
    Decode dec;

    Base64DecodingStep() { this = dec }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = dec.getInput() and
      succ = dec.getOutput()
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

/** A call to `Buffer.from` with encoding `base64`. */
private class Buffer_from extends Base64::Encode::Range, DataFlow::CallNode {
  Buffer_from() {
    this = DataFlow::globalVarRef("Buffer").getAMemberCall("from") and
    getArgument(1).mayHaveStringValue("base64")
  }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::Node getOutput() { result = this }
}

/**
 * A call to `Buffer.prototype.toString` with encoding `base64`, approximated by
 * looking for calls to `toString` where the first argument is the string `"base64"`.
 */
private class Buffer_toString extends Base64::Decode::Range, DataFlow::MethodCallNode {
  Buffer_toString() {
    getMethodName() = "toString" and
    getArgument(0).mayHaveStringValue("base64")
  }

  override DataFlow::Node getInput() { result = getReceiver() }

  override DataFlow::Node getOutput() { result = this }
}

/**
 * A call to a base64 encoding function from one of the npm packages
 * `base-64`, `js-base64`, `Base64`, or `base64-js`.
 */
private class NpmBase64Encode extends Base64::Encode::Range, DataFlow::CallNode {
  NpmBase64Encode() {
    exists(string mod, string meth |
      mod = "base-64" and meth = "encode"
      or
      mod = "Base64" and meth = "btoa"
      or
      mod = "base64-js" and meth = "toByteArray"
    |
      this = DataFlow::moduleMember(mod, meth).getACall()
    )
    or
    exists(string meth | meth = "encode" or meth = "encodeURI" |
      this = DataFlow::moduleMember("js-base64", "Base64").getAMemberCall(meth)
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
    exists(string mod, string meth |
      mod = "base-64" and meth = "decode"
      or
      mod = "Base64" and meth = "atob"
      or
      mod = "base64-js" and meth = "fromByteArray"
    |
      this = DataFlow::moduleMember(mod, meth).getACall()
    )
    or
    this = DataFlow::moduleMember("js-base64", "Base64").getAMemberCall("decode")
  }

  override DataFlow::Node getInput() { result = getArgument(0) }

  override DataFlow::Node getOutput() { result = this }
}
