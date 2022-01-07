/**
 * Models the different ways to create paths. Either by using `java.io.File`-related APIs or `java.nio.file.Path`-related APIs.
 */

import java

/** Models the creation of a path. */
abstract class PathCreation extends Expr {
  /**
   * Gets an input that is used in the creation of this path.
   * This excludes inputs of type `File` and `Path`.
   */
  abstract Expr getAnInput();
}

/** Models the `java.nio.file.Paths.get` method. */
private class PathsGet extends PathCreation, MethodAccess {
  PathsGet() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePaths and
      m.getName() = "get"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `java.nio.file.FileSystem.getPath` method. */
private class FileSystemGetPath extends PathCreation, MethodAccess {
  FileSystemGetPath() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypeFileSystem and
      m.getName() = "getPath"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `new java.io.File(...)` constructor. */
private class FileCreation extends PathCreation, ClassInstanceExpr {
  FileCreation() { this.getConstructedType() instanceof TypeFile }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments include those that are not a `File`.
    not result.getType() instanceof TypeFile
  }
}

/** Models the `java.nio.file.Path.resolveSibling` method. */
private class PathResolveSiblingCreation extends PathCreation, MethodAccess {
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
private class PathResolveCreation extends PathCreation, MethodAccess {
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
private class PathOfCreation extends PathCreation, MethodAccess {
  PathOfCreation() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePath and
      m.getName() = "of"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `new java.io.FileWriter(...)` constructor. */
private class FileWriterCreation extends PathCreation, ClassInstanceExpr {
  FileWriterCreation() { this.getConstructedType().hasQualifiedName("java.io", "FileWriter") }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `new java.io.FileReader(...)` constructor. */
private class FileReaderCreation extends PathCreation, ClassInstanceExpr {
  FileReaderCreation() { this.getConstructedType().hasQualifiedName("java.io", "FileReader") }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `new java.io.FileInputStream(...)` constructor. */
private class FileInputStreamCreation extends PathCreation, ClassInstanceExpr {
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
private class FileOutputStreamCreation extends PathCreation, ClassInstanceExpr {
  FileOutputStreamCreation() {
    this.getConstructedType().hasQualifiedName("java.io", "FileOutputStream")
  }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}
