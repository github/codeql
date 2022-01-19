/** Definitions of taint steps in the Codec framework */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class CodecSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.codec;Encoder;true;encode;(Object);;Argument[0];ReturnValue;taint",
        "org.apache.commons.codec;Decoder;true;decode;(Object);;Argument[0];ReturnValue;taint",
        "org.apache.commons.codec;BinaryEncoder;true;encode;(byte[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.codec;BinaryDecoder;true;decode;(byte[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.codec;StringEncoder;true;encode;(String);;Argument[0];ReturnValue;taint",
        "org.apache.commons.codec;StringDecoder;true;decode;(String);;Argument[0];ReturnValue;taint",
      ]
  }
}
