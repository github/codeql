/**
 * DEPRECATED.
 *
 * Models the different ways to create paths. Either by using `java.io.File`-related APIs or `java.nio.file.Path`-related APIs.
 */

import java

/** DEPRECATED: Models the creation of a path. */
abstract deprecated class PathCreation extends Expr {
  /**
   * Gets an input that is used in the creation of this path.
   * This excludes inputs of type `File` and `Path`.
   */
  abstract Expr getAnInput();
}

/** Models the `java.nio.file.Paths.get` method. */
deprecated private class PathsGet extends PathCreation, MethodCall {
  PathsGet() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePaths and
      m.getName() = "get"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `java.nio.file.FileSystem.getPath` method. */
deprecated private class FileSystemGetPath extends PathCreation, MethodCall {
  FileSystemGetPath() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypeFileSystem and
      m.getName() = "getPath"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `new java.io.File(...)` constructor. */
deprecated private class FileCreation extends PathCreation, ClassInstanceExpr {
  FileCreation() { this.getConstructedType() instanceof TypeFile }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments include those that are not a `File`.
    not result.getType() instanceof TypeFile
  }
}

/** Models the `java.nio.file.Path.resolveSibling` method. */
deprecated private class PathResolveSiblingCreation extends PathCreation, MethodCall {
  PathResolveSiblingCreation() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePath and
      m.getName() = "resolveSibling"
    )
  }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `java.nio.file.Path.resolve` method. */
deprecated private class PathResolveCreation extends PathCreation, MethodCall {
  PathResolveCreation() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePath and
      m.getName() = "resolve"
    )
  }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `java.nio.file.Path.of` method. */
deprecated private class PathOfCreation extends PathCreation, MethodCall {
  PathOfCreation() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePath and
      m.getName() = "of"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `new java.io.FileWriter(...)` constructor. */
deprecated private class FileWriterCreation extends PathCreation, ClassInstanceExpr {
  FileWriterCreation() { this.getConstructedType().hasQualifiedName("java.io", "FileWriter") }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `new java.io.FileReader(...)` constructor. */
deprecated private class FileReaderCreation extends PathCreation, ClassInstanceExpr {
  FileReaderCreation() { this.getConstructedType().hasQualifiedName("java.io", "FileReader") }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `new java.io.FileInputStream(...)` constructor. */
deprecated private class FileInputStreamCreation extends PathCreation, ClassInstanceExpr {
  FileInputStreamCreation() {
    this.getConstructedType().hasQualifiedName("java.io", "FileInputStream")
  }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `new java.io.FileOutputStream(...)` constructor. */
deprecated private class FileOutputStreamCreation extends PathCreation, ClassInstanceExpr {
  FileOutputStreamCreation() {
    this.getConstructedType().hasQualifiedName("java.io", "FileOutputStream")
  }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}
