/** Definitions of taint steps in Objects class of the JDK */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class JavaIoSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "java.lang;Appendable;true;append;;;Argument[0];Argument[-1];taint;manual",
        "java.lang;Appendable;true;append;;;Argument[-1];ReturnValue;value;manual",
        "java.io;Writer;true;write;;;Argument[0];Argument[-1];taint;manual",
        "java.io;Writer;true;toString;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;CharArrayWriter;true;toCharArray;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;ObjectInput;true;read;;;Argument[-1];Argument[0];taint;manual",
        "java.io;DataInput;true;readFully;;;Argument[-1];Argument[0];taint;manual",
        "java.io;DataInput;true;readLine;();;Argument[-1];ReturnValue;taint;manual",
        "java.io;DataInput;true;readUTF;();;Argument[-1];ReturnValue;taint;manual",
        "java.nio.channels;ReadableByteChannel;true;read;(ByteBuffer);;Argument[-1];Argument[0];taint;manual",
        "java.nio.channels;Channels;false;newChannel;(InputStream);;Argument[0];ReturnValue;taint;manual"
      ]
  }
}
