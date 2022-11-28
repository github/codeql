/** Provides definitions related to the namespace `System.IO`. */

import csharp
private import semmle.code.csharp.frameworks.System

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

/** The `System.IO.StringReader` class. */
class SystemIOStringReaderClass extends SystemIOClass {
  SystemIOStringReaderClass() { this.hasName("StringReader") }
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

/** The `System.IO.MemoryStream` class. */
class SystemIOMemoryStreamClass extends SystemIOClass {
  SystemIOMemoryStreamClass() { this.hasName("MemoryStream") }

  /** Gets the `ToArray` Method. */
  Method getToArrayMethod() {
    result = this.getAMethod() and
    result.hasName("ToArray")
  }
}
