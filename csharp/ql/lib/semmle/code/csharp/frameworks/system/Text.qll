/** Provides definitions related to the namespace `System.Text`. */

import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Text` namespace. */
class SystemTextNamespace extends Namespace {
  SystemTextNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Text")
  }
}

/** A class in the `System.Text` namespace. */
class SystemTextClass extends Class {
  SystemTextClass() { this.getNamespace() instanceof SystemTextNamespace }
}

/** The `System.Text.StringBuilder` class. */
class SystemTextStringBuilderClass extends SystemTextClass {
  SystemTextStringBuilderClass() { this.hasName("StringBuilder") }

  /** Gets the `AppendFormat` method. */
  Method getAppendFormatMethod() { result = this.getAMethod("AppendFormat") }
}

/** The `System.Text.Encoding` class. */
class SystemTextEncodingClass extends SystemTextClass {
  SystemTextEncodingClass() { this.hasName("Encoding") }

  /** Gets the `GetBytes` method. */
  Method getGetBytesMethod() { result = this.getAMethod("GetBytes") }

  /** Gets the `GetString` method. */
  Method getGetStringMethod() { result = this.getAMethod("GetString") }

  /** Gets the `GetChars` method. */
  Method getGetCharsMethod() { result = this.getAMethod("GetChars") }
}
