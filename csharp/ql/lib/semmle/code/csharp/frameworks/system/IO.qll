/** Provides definitions related to the namespace `System.IO`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.IO` namespace. */
class SystemIONamespace extends Namespace {
  SystemIONamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("IO")
  }
}

/** A class in the `System.IO` namespace. */
class SystemIOClass extends Class {
  SystemIOClass() { this.getNamespace() instanceof SystemIONamespace }
}

/** The `System.IO.Directory` class. */
class SystemIODirectoryClass extends SystemIOClass {
  SystemIODirectoryClass() { this.hasName("Directory") }
}

/** The `System.IO.File` class. */
class SystemIOFileClass extends SystemIOClass {
  SystemIOFileClass() { this.hasName("File") }
}

/** The `System.IO.FileStream` class. */
class SystemIOFileStreamClass extends SystemIOClass {
  SystemIOFileStreamClass() { this.hasName("FileStream") }
}

/** The `System.IO.StreamWriter` class. */
class SystemIOStreamWriterClass extends SystemIOClass {
  SystemIOStreamWriterClass() { this.hasName("StreamWriter") }
}

/** The `System.IO.Path` class. */
class SystemIOPathClass extends SystemIOClass {
  SystemIOPathClass() { this.hasName("Path") }
}

/** Data flow for `System.IO.Path`. */
private class SystemIOPathFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.IO;Path;false;Combine;(System.String,System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String,System.String);;Argument[1];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String,System.String,System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String,System.String,System.String);;Argument[1];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String,System.String,System.String);;Argument[2];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String,System.String,System.String,System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String,System.String,System.String,System.String);;Argument[1];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String,System.String,System.String,System.String);;Argument[2];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String,System.String,System.String,System.String);;Argument[3];ReturnValue;taint",
        "System.IO;Path;false;Combine;(System.String[]);;Argument[0].Element;ReturnValue;taint",
        "System.IO;Path;false;GetDirectoryName;(System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue;taint",
        "System.IO;Path;false;GetDirectoryName;(System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;GetExtension;(System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue;taint",
        "System.IO;Path;false;GetExtension;(System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;GetFileName;(System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue;taint",
        "System.IO;Path;false;GetFileName;(System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;GetFileNameWithoutExtension;(System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue;taint",
        "System.IO;Path;false;GetFileNameWithoutExtension;(System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;GetFullPath;(System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;GetFullPath;(System.String,System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;GetPathRoot;(System.ReadOnlySpan<System.Char>);;Argument[0].Element;ReturnValue;taint",
        "System.IO;Path;false;GetPathRoot;(System.String);;Argument[0];ReturnValue;taint",
        "System.IO;Path;false;GetRelativePath;(System.String,System.String);;Argument[1];ReturnValue;taint"
      ]
  }
}

/** Data flow for `System.IO.TextReader`. */
private class SystemIOTextReaderFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.IO;TextReader;true;Read;();;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;Read;(System.Char[],System.Int32,System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;Read;(System.Span<System.Char>);;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadAsync;(System.Char[],System.Int32,System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadAsync;(System.Memory<System.Char>,System.Threading.CancellationToken);;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadBlock;(System.Char[],System.Int32,System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadBlock;(System.Span<System.Char>);;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadBlockAsync;(System.Char[],System.Int32,System.Int32);;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadBlockAsync;(System.Memory<System.Char>,System.Threading.CancellationToken);;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadLine;();;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadLineAsync;();;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadToEnd;();;Argument[Qualifier];ReturnValue;taint",
        "System.IO;TextReader;true;ReadToEndAsync;();;Argument[Qualifier];ReturnValue;taint",
      ]
  }
}

/** The `System.IO.StringReader` class. */
class SystemIOStringReaderClass extends SystemIOClass {
  SystemIOStringReaderClass() { this.hasName("StringReader") }
}

/** Data flow for `System.IO.StringReader` */
private class SystemIOStringReaderFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row = "System.IO;StringReader;false;StringReader;(System.String);;Argument[0];ReturnValue;taint"
  }
}

/** The `System.IO.Stream` class. */
class SystemIOStreamClass extends SystemIOClass {
  SystemIOStreamClass() { this.hasName("Stream") }

  /** Gets a method that performs a read. */
  Method getAReadMethod() {
    result = this.getAMethod() and
    result.getName().matches("%Read%")
  }

  /** Gets a method that performs a write. */
  Method getAWriteMethod() {
    result = this.getAMethod() and
    result.getName().matches("%Write%")
  }

  /** Gets the `Read(byte[], int, int)` method. */
  Method getReadMethod() {
    result.getDeclaringType() = this and
    result.hasName("Read") and
    result.getNumberOfParameters() = 3 and
    result.getParameter(0).getType().(ArrayType).getElementType() instanceof ByteType and
    result.getParameter(1).getType() instanceof IntType and
    result.getParameter(2).getType() instanceof IntType and
    result.getReturnType() instanceof IntType
  }

  /** Gets the `ReadByte()` method. */
  Method getReadByteMethod() {
    result.getDeclaringType() = this and
    result.hasName("ReadByte") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof IntType
  }
}

/** Data flow for `System.IO.Stream`. */
private class SystemIOStreamFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.IO;Stream;false;CopyTo;(System.IO.Stream);;Argument[Qualifier];Argument[0];taint",
        "System.IO;Stream;false;CopyToAsync;(System.IO.Stream);;Argument[Qualifier];Argument[0];taint",
        "System.IO;Stream;false;CopyToAsync;(System.IO.Stream,System.Int32);;Argument[Qualifier];Argument[0];taint",
        "System.IO;Stream;false;CopyToAsync;(System.IO.Stream,System.Threading.CancellationToken);;Argument[Qualifier];Argument[0];taint",
        "System.IO;Stream;false;ReadAsync;(System.Byte[],System.Int32,System.Int32);;Argument[Qualifier];Argument[0].Element;taint",
        "System.IO;Stream;false;WriteAsync;(System.Byte[],System.Int32,System.Int32);;Argument[0].Element;Argument[Qualifier];taint",
        "System.IO;Stream;true;BeginRead;(System.Byte[],System.Int32,System.Int32,System.AsyncCallback,System.Object);;Argument[Qualifier];Argument[0].Element;taint",
        "System.IO;Stream;true;BeginWrite;(System.Byte[],System.Int32,System.Int32,System.AsyncCallback,System.Object);;Argument[0].Element;Argument[Qualifier];taint",
        "System.IO;Stream;true;CopyTo;(System.IO.Stream,System.Int32);;Argument[Qualifier];Argument[0];taint",
        "System.IO;Stream;true;CopyToAsync;(System.IO.Stream,System.Int32,System.Threading.CancellationToken);;Argument[Qualifier];Argument[0];taint",
        "System.IO;Stream;true;Read;(System.Byte[],System.Int32,System.Int32);;Argument[Qualifier];Argument[0].Element;taint",
        "System.IO;Stream;true;ReadAsync;(System.Byte[],System.Int32,System.Int32,System.Threading.CancellationToken);;Argument[Qualifier];Argument[0].Element;taint",
        "System.IO;Stream;true;Write;(System.Byte[],System.Int32,System.Int32);;Argument[0].Element;Argument[Qualifier];taint",
        "System.IO;Stream;true;WriteAsync;(System.Byte[],System.Int32,System.Int32,System.Threading.CancellationToken);;Argument[0].Element;Argument[Qualifier];taint"
      ]
  }
}

/** The `System.IO.MemoryStream` class. */
class SystemIOMemoryStreamClass extends SystemIOClass {
  SystemIOMemoryStreamClass() { this.hasName("MemoryStream") }

  /** Gets the `ToArray` Method. */
  Method getToArrayMethod() {
    result = this.getAMethod() and
    result.hasName("ToArray")
  }
}

private class SystemIOMemoryStreamFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.IO;MemoryStream;false;MemoryStream;(System.Byte[]);;Argument[0];ReturnValue;taint",
        "System.IO;MemoryStream;false;MemoryStream;(System.Byte[],System.Boolean);;Argument[0].Element;ReturnValue;taint",
        "System.IO;MemoryStream;false;MemoryStream;(System.Byte[],System.Int32,System.Int32);;Argument[0].Element;ReturnValue;taint",
        "System.IO;MemoryStream;false;MemoryStream;(System.Byte[],System.Int32,System.Int32,System.Boolean);;Argument[0].Element;ReturnValue;taint",
        "System.IO;MemoryStream;false;MemoryStream;(System.Byte[],System.Int32,System.Int32,System.Boolean,System.Boolean);;Argument[0].Element;ReturnValue;taint",
        "System.IO;MemoryStream;false;ToArray;();;Argument[Qualifier];ReturnValue;taint"
      ]
  }
}
