/** Definitions related to the Apache Commons IO library. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class CommonsIOSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.io;IOUtils;false;buffer;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;copy;;;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;copyLarge;;;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;read;;;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;readFully;(InputStream,byte[],int,int);;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;readFully;(InputStream,byte[]);;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;readFully;(InputStream,ByteBuffer);;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;readFully;(InputStream,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;readFully;(ReadableByteChannel,ByteBuffer);;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;readFully;(Reader,char[],int,int);;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;readFully;(Reader,char[]);;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;readLines;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;toBufferedInputStream;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;toBufferedReader;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;toByteArray;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;toCharArray;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;toInputStream;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;toString;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;false;write;;;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;writeChunked;;;Argument[0];Argument[1];taint",
        "org.apache.commons.io;IOUtils;false;writeLines;;;Argument[0];Argument[2];taint",
        "org.apache.commons.io;IOUtils;false;writeLines;;;Argument[1];Argument[2];taint"
      ]
  }
}
