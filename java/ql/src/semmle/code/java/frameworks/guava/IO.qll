/** Definitions of taint steps in the IO packae of the Guava framework */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

private class GuavaIoCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "com.google.common.io;BaseEncoding;true;decode;(CharSequence);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;decodingStream;(Reader);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;decodingSource;(CharSource);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;encode;(byte[]);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;encode;(byte[],int,int);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;asCharSource;(Charset);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;concat;;;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;openStream;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;openBufferedStream;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;read;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;slice;(long,long);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;wrap;(byte[]);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;copy;(InputStream,OutputStream);;Argument[0];Argument[1];taint",
        "com.google.common.io;ByteStreams;false;limit;(InputStream,long);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;newDataInput;(byte[]);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;newDataInput;(byte[],int);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;newDataInput;(ByteArrayInputStream);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;read;(InputStream,byte[],int,int);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteStreams;false;readFully;(InputStream,byte[]);;Argument[0];Argument[1];taint",
        "com.google.common.io;ByteStreams;false;readFully;(InputStream,byte[],int,int);;Argument[0];Argument[1];taint",
        "com.google.common.io;ByteStreams;false;toByteArray;(InputStream);;Argument[0];ReturnValue;taint",
        "com.google.common.io;CharSource;true;asByteSource;(Charset);;Argument[0];ReturnValue;taint",
        "com.google.common.io;CharSource;true;concat;;;Argument[0];ReturnValue;taint",
        "com.google.common.io;CharSource;true;copyTo;(Appendable);;Argument[-1];Argument[0];taint",
        "com.google.common.io;CharSource;true;openStream;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;openBufferedStream;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;read;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;readFirstLine;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;readLines;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;wrap;(CharSequence);;Argument[0];ReturnValue;taint",
        "com.google.common.io;CharStreams;false;copy;(Readable,Appendable);;Argument[0];Argument[1];taint",
        "com.google.common.io;CharStreams;false;readLines;(Readable);;Argument[0];Argument[-1];taint",
        "com.google.common.io;CharStreams;false;toString;(Readable);;Argument[0];ReturnValue;taint",
        "com.google.common.io;Closer;true;register;;;Argument[0];ReturnValue;value",
        "com.google.common.io;Files;false;getFileExtension;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.io;Files;false;getNameWithoutExtension;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.io;Files;false;simplifyPath;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.io;MoreFiles;false;getFileExtension;(Path);;Argument[0];ReturnValue;taint",
        "com.google.common.io;MoreFiles;false;getNameWithoutExtension;(Path);;Argument[0];ReturnValue;taint",
        "com.google.common.io;LineReader;false;LineReader;(Reader);;Argument[0];ReturnValue;taint",
        "com.google.common.io;LineReader;false;readLine;();;Argument[-1];ReturnValue;taint"
      ]
  }
}
