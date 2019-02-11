/**
 * @name Arbitrary file write during archive extraction ("Zip Slip")
 * @description Extracting files from a malicious archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
 * @kind path-problem
 * @id java/zipslip
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.SSA
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import PathGraph

/**
 * A method that returns the name of an archive entry.
 */
class ArchiveEntryNameMethod extends Method {
  ArchiveEntryNameMethod() {
    exists(RefType archiveEntry |
      archiveEntry.hasQualifiedName("java.util.zip", "ZipEntry") or
      archiveEntry.hasQualifiedName("org.apache.commons.compress.archivers", "ArchiveEntry")
    |
      this.getDeclaringType().getASupertype*() = archiveEntry and
      this.hasName("getName")
    )
  }
}

/**
 * An expression that will be treated as the destination of a write.
 */
class WrittenFileName extends Expr {
  WrittenFileName() {
    // Constructors that write to their first argument.
    exists(ConstructorCall ctr | this = ctr.getArgument(0) |
      exists(Class c | ctr.getConstructor() = c.getAConstructor() |
        c.hasQualifiedName("java.io", "FileOutputStream") or
        c.hasQualifiedName("java.io", "RandomAccessFile") or
        c.hasQualifiedName("java.io", "FileWriter")
      )
    )
    or
    // Methods that write to their n'th argument
    exists(MethodAccess call, int n | this = call.getArgument(n) |
      call.getMethod().getDeclaringType().hasQualifiedName("java.nio.file", "Files") and
      (
        call.getMethod().getName().regexpMatch("new.*Reader|newOutputStream|create.*") and n = 0
        or
        call.getMethod().hasName("copy") and n = 1
        or
        call.getMethod().hasName("move") and n = 1
      )
    )
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String`,
 * `File`, and `Path`.
 */
predicate filePathStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeFile |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
  or
  exists(MethodAccess ma, Method m |
    ma.getMethod() = m and
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  |
    m.getDeclaringType() instanceof TypeFile and m.hasName("toPath")
    or
    m.getDeclaringType() instanceof TypePath and m.hasName("toAbsolutePath")
    or
    m.getDeclaringType() instanceof TypePath and m.hasName("toFile")
  )
}

predicate fileTaintStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() or
    n1.asExpr() = ma.getAnArgument()
  |
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypePath and
    m.hasName("resolve")
  )
}

predicate localFileValueStep(Node n1, Node n2) {
  localFlowStep(n1, n2) or
  filePathStep(n1, n2)
}

predicate localFileValueStepPlus(Node n1, Node n2) = fastTC(localFileValueStep/2)(n1, n2)

/**
 * Holds if `check` is a guard that checks whether `var` is a file path with a
 * specific prefix when put in canonical form, thus guarding against ZipSlip.
 */
predicate validateFilePath(SsaVariable var, Guard check) {
  // `var.getCanonicalFile().toPath().startsWith(...)`,
  // `var.getCanonicalPath().startsWith(...)`, or
  // `var.toPath().normalize().startsWith(...)`
  exists(MethodAccess normalize, MethodAccess startsWith, Node n1, Node n2, Node n3, Node n4 |
    n1.asExpr() = var.getAUse() and
    n2.asExpr() = normalize.getQualifier() and
    (n1 = n2 or localFileValueStepPlus(n1, n2)) and
    n3.asExpr() = normalize and
    n4.asExpr() = startsWith.getQualifier() and
    (n3 = n4 or localFileValueStepPlus(n3, n4)) and
    check = startsWith and
    startsWith.getMethod().hasName("startsWith") and
    (
      normalize.getMethod().hasName("getCanonicalFile") or
      normalize.getMethod().hasName("getCanonicalPath") or
      normalize.getMethod().hasName("normalize")
    )
  )
}

/**
 * Holds if `m` validates its `arg`th parameter.
 */
predicate validationMethod(Method m, int arg) {
  exists(Guard check, SsaImplicitInit var, ControlFlowNode exit, ControlFlowNode normexit |
    validateFilePath(var, check) and
    var.isParameterDefinition(m.getParameter(arg)) and
    exit = m and
    normexit.getANormalSuccessor() = exit and
    1 = strictcount(ControlFlowNode n | n.getANormalSuccessor() = exit)
  |
    check.(ConditionNode).getATrueSuccessor() = exit or
    check.controls(normexit.getBasicBlock(), true)
  )
}

class ZipSlipConfiguration extends TaintTracking::Configuration {
  ZipSlipConfiguration() { this = "ZipSlip" }

  override predicate isSource(Node source) {
    source.asExpr().(MethodAccess).getMethod() instanceof ArchiveEntryNameMethod
  }

  override predicate isSink(Node sink) { sink.asExpr() instanceof WrittenFileName }

  override predicate isAdditionalTaintStep(Node n1, Node n2) {
    filePathStep(n1, n2) or fileTaintStep(n1, n2)
  }

  override predicate isSanitizer(Node node) {
    exists(Guard g, SsaVariable var, RValue varuse | validateFilePath(var, g) |
      varuse = node.asExpr() and
      varuse = var.getAUse() and
      g.controls(varuse.getBasicBlock(), true)
    )
    or
    exists(MethodAccess ma, int pos, RValue rv |
      validationMethod(ma.getMethod(), pos) and
      ma.getArgument(pos) = rv and
      adjacentUseUseSameVar(rv, node.asExpr()) and
      ma.getBasicBlock().bbDominates(node.asExpr().getBasicBlock())
    )
  }
}

from PathNode source, PathNode sink
where any(ZipSlipConfiguration c).hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "Unsanitized archive entry, which may contain '..', is used in a $@.", sink.getNode(),
  "file system operation"
