/** Definitions of taint steps in the IO package of the Guava framework */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class GuavaIoCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "com.google.common.io;BaseEncoding;true;decode;(CharSequence);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;decodingStream;(Reader);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;decodingSource;(CharSource);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;encode;(byte[]);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;encode;(byte[],int,int);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;withSeparator;(String,int);;Argument[0];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;decode;(CharSequence);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;decodingStream;(Reader);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;decodingSource;(CharSource);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;encode;(byte[]);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;upperCase;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;lowerCase;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;withPadChar;(char);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;omitPadding;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;BaseEncoding;true;encode;(byte[],int,int);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;asCharSource;(Charset);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;concat;(ByteSource[]);;Argument[0].ArrayElement;ReturnValue;taint",
        "com.google.common.io;ByteSource;true;concat;(Iterable);;Argument[0].Element;ReturnValue;taint",
        "com.google.common.io;ByteSource;true;concat;(Iterator);;Argument[0].Element;ReturnValue;taint",
        "com.google.common.io;ByteSource;true;copyTo;(OutputStream);;Argument[-1];Argument[0];taint",
        "com.google.common.io;ByteSource;true;openStream;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;openBufferedStream;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;read;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;slice;(long,long);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteSource;true;wrap;(byte[]);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;copy;(InputStream,OutputStream);;Argument[0];Argument[1];taint",
        "com.google.common.io;ByteStreams;false;copy;(ReadableByteChannel,WritableByteChannel);;Argument[0];Argument[1];taint",
        "com.google.common.io;ByteStreams;false;limit;(InputStream,long);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;newDataInput;(byte[]);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;newDataInput;(byte[],int);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;newDataInput;(ByteArrayInputStream);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;newDataOutput;(ByteArrayOutputStream);;Argument[0];ReturnValue;taint",
        "com.google.common.io;ByteStreams;false;read;(InputStream,byte[],int,int);;Argument[0];Argument[1];taint",
        "com.google.common.io;ByteStreams;false;readFully;(InputStream,byte[]);;Argument[0];Argument[1];taint",
        "com.google.common.io;ByteStreams;false;readFully;(InputStream,byte[],int,int);;Argument[0];Argument[1];taint",
        "com.google.common.io;ByteStreams;false;toByteArray;(InputStream);;Argument[0];ReturnValue;taint",
        "com.google.common.io;CharSource;true;asByteSource;(Charset);;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;concat;(CharSource[]);;Argument[0].ArrayElement;ReturnValue;taint",
        "com.google.common.io;CharSource;true;concat;(Iterable);;Argument[0].Element;ReturnValue;taint",
        "com.google.common.io;CharSource;true;concat;(Iterator);;Argument[0].Element;ReturnValue;taint",
        "com.google.common.io;CharSource;true;copyTo;(Appendable);;Argument[-1];Argument[0];taint",
        "com.google.common.io;CharSource;true;openStream;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;openBufferedStream;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;read;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;readFirstLine;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;readLines;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;lines;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;CharSource;true;wrap;(CharSequence);;Argument[0];ReturnValue;taint",
        "com.google.common.io;CharStreams;false;copy;(Readable,Appendable);;Argument[0];Argument[1];taint",
        "com.google.common.io;CharStreams;false;readLines;(Readable);;Argument[0];ReturnValue;taint",
        "com.google.common.io;CharStreams;false;toString;(Readable);;Argument[0];ReturnValue;taint",
        "com.google.common.io;Closer;true;register;;;Argument[0];ReturnValue;value",
        "com.google.common.io;Files;false;getFileExtension;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.io;Files;false;getNameWithoutExtension;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.io;Files;false;simplifyPath;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.io;MoreFiles;false;getFileExtension;(Path);;Argument[0];ReturnValue;taint",
        "com.google.common.io;MoreFiles;false;getNameWithoutExtension;(Path);;Argument[0];ReturnValue;taint",
        "com.google.common.io;LineReader;false;LineReader;(Readable);;Argument[0];Argument[-1];taint",
        "com.google.common.io;LineReader;true;readLine;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteArrayDataOutput;true;toByteArray;();;Argument[-1];ReturnValue;taint",
        "com.google.common.io;ByteArrayDataOutput;true;write;(byte[]);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;write;(byte[],int,int);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;write;(int);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeByte;(int);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeBytes;(String);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeChar;(int);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeChars;(String);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeDouble;(double);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeFloat;(float);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeInt;(int);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeLong;(long);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeShort;(int);;Argument[0];Argument[-1];taint",
        "com.google.common.io;ByteArrayDataOutput;true;writeUTF;(String);;Argument[0];Argument[-1];taint"
      ]
  }
}

private class GuavaIoSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; kind`
        "com.google.common.io;Resources;false;asByteSource;(URL);;Argument[0];url-open-stream",
        "com.google.common.io;Resources;false;asCharSource;(URL,Charset);;Argument[0];url-open-stream",
        "com.google.common.io;Resources;false;copy;(URL,OutputStream);;Argument[0];url-open-stream",
        "com.google.common.io;Resources;false;asByteSource;(URL);;Argument[0];url-open-stream",
        "com.google.common.io;Resources;false;readLines;;;Argument[0];url-open-stream",
        "com.google.common.io;Resources;false;toByteArray;(URL);;Argument[0];url-open-stream",
        "com.google.common.io;Resources;false;toString;(URL,Charset);;Argument[0];url-open-stream"
      ]
  }
}
