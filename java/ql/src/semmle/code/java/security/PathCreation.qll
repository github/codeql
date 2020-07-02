/**
 * Models the different ways to create paths. Either by using `java.io.File`-related APIs or `java.nio.Path`-related APIs.
 */

import java
import semmle.code.java.controlflow.Guards

/** Models the creation of a path. */
abstract class PathCreation extends Expr {
  /** Gets an input that is used in the creation of this path. */
  abstract Expr getInput();
}

/** Models the `java.nio.file.Paths.get` method. */
class PathsGet extends PathCreation, MethodAccess {
  PathsGet() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePaths and
      m.getName() = "get"
    )
  }

  override Expr getInput() { result = this.getAnArgument() }
}

/** Models the `java.nio.file.FileSystem.getPath` method. */
class FileSystemGetPath extends PathCreation, MethodAccess {
  FileSystemGetPath() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypeFileSystem and
      m.getName() = "getPath"
    )
  }

  override Expr getInput() { result = this.getAnArgument() }
}

/** Models the `new java.io.File(...)` constructor. */
class FileCreation extends PathCreation, ClassInstanceExpr {
  FileCreation() { this.getConstructedType() instanceof TypeFile }

  override Expr getInput() {
    result = this.getAnArgument() and
    // Relevant arguments include those that are not a `File`.
    not result.getType() instanceof TypeFile
  }
}

/** Models the `java.nio.Path.resolveSibling` method. */
class PathResolveSiblingCreation extends PathCreation, MethodAccess {
  PathResolveSiblingCreation() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePath and
      m.getName() = "resolveSibling"
    )
  }

  override Expr getInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `java.nio.Path.resolve` method. */
class PathResolveCreation extends PathCreation, MethodAccess {
  PathResolveCreation() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePath and
      m.getName() = "resolve"
    )
  }

  override Expr getInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

/** Models the `java.nio.Path.of` method. */
class PathOfCreation extends PathCreation, MethodAccess {
  PathOfCreation() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypePath and
      m.getName() = "of"
    )
  }

  override Expr getInput() { result = this.getAnArgument() }
}

/** Models the `new java.io.FileWriter(...)` constructor. */
class FileWriterCreation extends PathCreation, ClassInstanceExpr {
  FileWriterCreation() { this.getConstructedType().getQualifiedName() = "java.io.FileWriter" }

  override Expr getInput() {
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
  exists(PathCreation p | e = p.getInput()) and
  exists(ConditionBlock cb, Expr c |
    cb.getCondition().getAChildExpr*() = c and
    c = e.getVariable().getAnAccess() and
    cb.controls(e.getBasicBlock(), true) and
    // Disallow a few obviously bad checks.
    not inWeakCheck(c)
  )
}
