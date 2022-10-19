/** Provides classes and predicates to work with File objects. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class CreateFileSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.io;FileOutputStream;false;FileOutputStream;;;Argument[0];create-file;manual",
        "java.io;RandomAccessFile;false;RandomAccessFile;;;Argument[0];create-file;manual",
        "java.io;FileWriter;false;FileWriter;;;Argument[0];create-file;manual",
        "java.io;PrintStream;false;PrintStream;(File);;Argument[0];create-file;manual",
        "java.io;PrintStream;false;PrintStream;(File,String);;Argument[0];create-file;manual",
        "java.io;PrintStream;false;PrintStream;(File,Charset);;Argument[0];create-file;manual",
        "java.io;PrintStream;false;PrintStream;(String);;Argument[0];create-file;manual",
        "java.io;PrintStream;false;PrintStream;(String,String);;Argument[0];create-file;manual",
        "java.io;PrintStream;false;PrintStream;(String,Charset);;Argument[0];create-file;manual",
        "java.io;PrintWriter;false;PrintWriter;(File);;Argument[0];create-file;manual",
        "java.io;PrintWriter;false;PrintWriter;(File,String);;Argument[0];create-file;manual",
        "java.io;PrintWriter;false;PrintWriter;(File,Charset);;Argument[0];create-file;manual",
        "java.io;PrintWriter;false;PrintWriter;(String);;Argument[0];create-file;manual",
        "java.io;PrintWriter;false;PrintWriter;(String,String);;Argument[0];create-file;manual",
        "java.io;PrintWriter;false;PrintWriter;(String,Charset);;Argument[0];create-file;manual",
        "java.nio.file;Files;false;copy;;;Argument[1];create-file;manual",
        "java.nio.file;Files;false;createDirectories;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;createDirectory;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;createFile;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;createLink;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;createSymbolicLink;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;createTempDirectory;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;createTempFile;(Path,String,String,FileAttribute[]);;Argument[0];create-file;manual",
        "java.nio.file;Files;false;move;;;Argument[1];create-file;manual",
        "java.nio.file;Files;false;newBufferedWriter;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;newOutputStream;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;write;;;Argument[0];create-file;manual",
        "java.nio.file;Files;false;writeString;;;Argument[0];create-file;manual"
      ]
  }
}

private class WriteFileSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.io;FileOutputStream;false;write;;;Argument[0];write-file;manual",
        "java.io;RandomAccessFile;false;write;;;Argument[0];write-file;manual",
        "java.io;RandomAccessFile;false;writeBytes;;;Argument[0];write-file;manual",
        "java.io;RandomAccessFile;false;writeChars;;;Argument[0];write-file;manual",
        "java.io;RandomAccessFile;false;writeUTF;;;Argument[0];write-file;manual",
        "java.io;Writer;true;append;;;Argument[0];write-file;manual",
        "java.io;Writer;true;write;;;Argument[0];write-file;manual",
        "java.io;PrintStream;true;append;;;Argument[0];write-file;manual",
        "java.io;PrintStream;true;format;(String,Object[]);;Argument[0..1];write-file;manual",
        "java.io;PrintStream;true;format;(Locale,String,Object[]);;Argument[1..2];write-file;manual",
        "java.io;PrintStream;true;print;;;Argument[0];write-file;manual",
        "java.io;PrintStream;true;printf;(String,Object[]);;Argument[0..1];write-file;manual",
        "java.io;PrintStream;true;printf;(Locale,String,Object[]);;Argument[1..2];write-file;manual",
        "java.io;PrintStream;true;println;;;Argument[0];write-file;manual",
        "java.io;PrintStream;true;write;;;Argument[0];write-file;manual",
        "java.io;PrintStream;true;writeBytes;;;Argument[0];write-file;manual",
        "java.io;PrintWriter;false;format;(String,Object[]);;Argument[0..1];write-file;manual",
        "java.io;PrintWriter;false;format;(Locale,String,Object[]);;Argument[1..2];write-file;manual",
        "java.io;PrintWriter;false;print;;;Argument[0];write-file;manual",
        "java.io;PrintWriter;false;printf;(String,Object[]);;Argument[0..1];write-file;manual",
        "java.io;PrintWriter;false;printf;(Locale,String,Object[]);;Argument[1..2];write-file;manual",
        "java.io;PrintWriter;false;println;;;Argument[0];write-file;manual",
        "java.nio.file;Files;false;write;;;Argument[1];write-file;manual",
        "java.nio.file;Files;false;writeString;;;Argument[1];write-file;manual"
      ]
  }
}

private class FileSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.io;File;false;File;;;Argument[0];Argument[-1];taint;manual",
        "java.io;File;false;File;;;Argument[1];Argument[-1];taint;manual",
        "java.io;File;true;getAbsoluteFile;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;getAbsolutePath;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;getCanonicalFile;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;getCanonicalPath;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;toPath;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;toString;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;toURI;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;normalize;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;resolve;;;Argument[-1..0];ReturnValue;taint;manual",
        "java.nio.file;Path;true;toAbsolutePath;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;false;toFile;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;toString;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;toUri;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Paths;true;get;;;Argument[0..1];ReturnValue;taint;manual",
        "java.nio.file;FileSystem;true;getPath;;;Argument[0];ReturnValue;taint;manual",
        "java.nio.file;FileSystem;true;getRootDirectories;;;Argument[0];ReturnValue;taint;manual"
      ]
  }
}
