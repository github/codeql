/**
 * Models the different ways to create paths. Either by using `java.io.File`-related APIs or `java.nio.file.Path`-related APIs.
 */

import java
import semmle.code.java.controlflow.Guards

/** Models the creation of a path. */
abstract class PathCreation extends Expr {
  /**
   * Gets an input that is used in the creation of this path.
   * This excludes inputs of type `File` and `Path`.
   */
  abstract Expr getAnInput();
}

/** Models the `java.nio.file.Paths.get` method. */
class PathsGet extends PathCreation, MethodAccess {
  PathsGet() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePaths and
      m.getName() = "get"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `java.nio.file.FileSystem.getPath` method. */
class FileSystemGetPath extends PathCreation, MethodAccess {
  FileSystemGetPath() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypeFileSystem and
      m.getName() = "getPath"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `new java.io.File(...)` constructor. */
class FileCreation extends PathCreation, ClassInstanceExpr {
  FileCreation() { this.getConstructedType() instanceof TypeFile }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments include those that are not a `File`.
    not result.getType() instanceof TypeFile
  }
}

/** Models the `java.nio.file.Path.resolveSibling` method. */
class PathResolveSiblingCreation extends PathCreation, MethodAccess {
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
class PathResolveCreation extends PathCreation, MethodAccess {
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
class PathOfCreation extends PathCreation, MethodAccess {
  PathOfCreation() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePath and
      m.getName() = "of"
    )
  }

  override Expr getAnInput() { result = this.getAnArgument() }
}

/** Models the `new java.io.FileWriter(...)` constructor. */
class FileWriterCreation extends PathCreation, ClassInstanceExpr {
  FileWriterCreation() { this.getConstructedType().hasQualifiedName("java.io", "FileWriter") }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `new java.io.FileReader(...)` constructor. */
class FileReaderCreation extends PathCreation, ClassInstanceExpr {
  FileReaderCreation() { this.getConstructedType().hasQualifiedName("java.io", "FileReader") }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `new java.io.FileInputStream(...)` constructor. */
class FileInputStreamCreation extends PathCreation, ClassInstanceExpr {
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
class FileOutputStreamCreation extends PathCreation, ClassInstanceExpr {
  FileOutputStreamCreation() {
    this.getConstructedType().hasQualifiedName("java.io", "FileOutputStream")
  }

  override Expr getAnInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

private predicate inWeakCheck(Expr e) {
  // None of these are sufficient to guarantee that a string is safe.
  exists(MethodAccess m, Method def | m.getQualifier() = e and m.getMethod() = def |
    def.getName() = "startsWith" or
    def.getName() = "endsWith" or
    def.getName() = "isEmpty" or
    def.getName() = "equals"
  )
  or
  // Checking against `null` has no bearing on path traversal.
  exists(EqualityTest b | b.getAnOperand() = e | b.getAnOperand() instanceof NullLiteral)
}

// Ignore cases where the variable has been checked somehow,
// but allow some particularly obviously bad cases.
predicate guarded(VarAccess e) {
  exists(PathCreation p | e = p.getAnInput()) and
  exists(ConditionBlock cb, Expr c |
    cb.getCondition().getAChildExpr*() = c and
    c = e.getVariable().getAnAccess() and
    cb.controls(e.getBasicBlock(), true) and
    // Disallow a few obviously bad checks.
    not inWeakCheck(c)
  )
}
