/**
 * Provides classes and predicates to reason about cleartext storage in the Android filesystem
 * (external or internal storage).
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.security.CleartextStorageQuery
import semmle.code.java.security.Files
import semmle.code.xml.AndroidManifest

private class AndroidFilesystemCleartextStorageSink extends CleartextStorageSink {
  AndroidFilesystemCleartextStorageSink() {
    filesystemInput(_, this.asExpr()) and
    // Make sure we are in an Android application.
    exists(AndroidManifestXmlFile manifest)
  }
}

/** The creation of an object that can be used to write to files to the local filesystem. */
class LocalFileOpenCall extends Storable {
  LocalFileOpenCall() {
    this = any(DataFlow::Node sink | sinkNode(sink, "create-file")).asExpr().(Argument).getCall()
  }

  override Expr getAnInput() {
    exists(FilesystemFlowConfig conf, DataFlow::Node n |
      filesystemInput(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }

  override Expr getAStore() {
    exists(FilesystemFlowConfig conf, DataFlow::Node n |
      filesystemStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

/** Holds if `input` is written into `file`. */
private predicate filesystemInput(DataFlow::Node file, Argument input) {
  exists(DataFlow::Node write | sinkNode(write, "write-file") |
    input = write.asExpr() or
    isVarargs(input, write)
  ) and
  if input.getCall().getCallee().isStatic()
  then file.asExpr() = input.getCall()
  else file.asExpr() = input.getCall().getQualifier()
}

/** Holds if `arg` is part of `varargs`. */
private predicate isVarargs(Argument arg, DataFlow::ImplicitVarargsArray varargs) {
  arg.isVararg() and arg.getCall() = varargs.getCall()
}

/** Holds if `store` closes `file`. */
private predicate filesystemStore(DataFlow::Node file, Call store) {
  store.getCallee() instanceof CloseFileMethod and
  if store.getCallee().isStatic()
  then file.asExpr() = store
  else file.asExpr() = store.getQualifier()
  or
  // try-with-resources automatically closes the file
  any(TryStmt try).getAResource() = store.(LocalFileOpenCall).getEnclosingStmt() and
  store = file.asExpr()
}

/** A method that closes a file. */
private class CloseFileMethod extends Method {
  CloseFileMethod() {
    this.hasQualifiedName("java.io", ["RandomAccessFile", "FileOutputStream", "PrintStream"],
      "close")
    or
    this.getDeclaringType().getASupertype*().hasQualifiedName("java.io", "Writer") and
    this.hasName("close")
    or
    this.hasQualifiedName("java.nio.file", "Files", ["write", "writeString"])
  }
}

private class FilesystemFlowConfig extends DataFlow::Configuration {
  FilesystemFlowConfig() { this = "FilesystemFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof LocalFileOpenCall }

  override predicate isSink(DataFlow::Node sink) {
    filesystemInput(sink, _) or
    filesystemStore(sink, _)
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Add nested Writer constructors as extra data flow steps
    exists(ClassInstanceExpr cie |
      cie.getConstructedType().getASupertype*().hasQualifiedName("java.io", "Writer") and
      node1.asExpr() = cie.getArgument(0) and
      node2.asExpr() = cie
    )
  }
}
