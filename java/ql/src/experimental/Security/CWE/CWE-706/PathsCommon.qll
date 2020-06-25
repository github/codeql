import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking

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

/** Models the `new java.io.FileWriter(...)` constructor. */
class FileWriterCreation extends PathCreation, ClassInstanceExpr {
  FileWriterCreation() { this.getConstructedType().getQualifiedName() = "java.io.FileWriter" }

  override Expr getInput() {
    result = this.getAnArgument() and
    // Relevant arguments are those of type `String`.
    result.getType() instanceof TypeString
  }
}

predicate inWeakCheck(Expr e) {
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

/** The class `java.io.FileInputStream`. */
class TypeFileInputStream extends Class {
  TypeFileInputStream() { this.hasQualifiedName("java.io", "FileInputStream") }
}

/** Models additional taint steps like `file.toPath()`, `path.toFile()`, `new FileInputStream(..)`, `Files.readAll{Bytes|Lines}(...)`, and `new File(...)`. */
class PathAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    inputStreamReadsFromFile(node1, node2)
    or
    isFileToPath(node1, node2)
    or
    isPathToFile(node1, node2)
    or
    readsAllFromPath(node1, node2)
    or
    taintedNewFile(node1, node2)
  }
}

/** Holds if `node1` is converted to `node2` via a call to `node1.toPath()`. */
private predicate isFileToPath(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeFile and
    call.getMethod().hasName("toPath") and
    call = node2.asExpr() and
    call.getQualifier() = node1.asExpr()
  )
}

/** Holds if `node1` is converted to `node2` via a call to `node1.toFile()`. */
private predicate isPathToFile(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypePath and
    call.getMethod().hasName("toFile") and
    call = node2.asExpr() and
    call.getQualifier() = node1.asExpr()
  )
}

/** Holds if `node1` is read by `node2` via a call to `Files.readAllBytes(node1)` or `Files.readAllLines(node1)`. */
private predicate readsAllFromPath(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeFiles and
    call.getMethod().hasName(["readAllBytes", "readAllLines"]) and
    call = node2.asExpr() and
    call.getArgument(0) = node1.asExpr()
  )
}

/** Holds if `node1` is passed to `node2` via a call to `new FileInputStream(node1)`. */
private predicate inputStreamReadsFromFile(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall call |
    call.getConstructedType() instanceof TypeFileInputStream and
    call = node2.asExpr() and
    call.getAnArgument() = node1.asExpr()
  )
}

/** Holds if `node1` is passed to `node2` via a call to `new File(node1)`. */
private predicate taintedNewFile(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall call |
    call.getConstructedType() instanceof TypeFile and
    call = node2.asExpr() and
    call.getAnArgument() = node1.asExpr()
  )
}
