/** Definitions of taint steps in Objects class of the JDK */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class JavaIoSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "java.lang;Appendable;true;append;;;Argument[0];Argument[-1];taint",
        "java.lang;Appendable;true;append;;;Argument[-1];ReturnValue;value",
        "java.io;Writer;true;write;;;Argument[0];Argument[-1];taint",
        "java.io;Writer;true;toString;;;Argument[-1];ReturnValue;taint",
        "java.io;CharArrayWriter;true;toCharArray;;;Argument[-1];ReturnValue;taint",
        "java.nio.channels;ReadableByteChannel;true;read;(ByteBuffer);;Argument[-1];Argument[0];taint",
        "java.nio.channels;Channels;false;newChannel;(InputStream);;Argument[0];ReturnValue;taint"
      ]
  }
}
