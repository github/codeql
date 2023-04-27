/**
 * Provides classes and predicates to reason about cleartext storage in the Android filesystem
 * (external or internal storage).
 */

import java
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.security.CleartextStorageQuery
import semmle.code.xml.AndroidManifest

private class AndroidFilesystemCleartextStorageSink extends CleartextStorageSink {
  AndroidFilesystemCleartextStorageSink() {
    filesystemInput(_, this.asExpr()) and
    // Make sure we are in an Android application.
    exists(AndroidManifestXmlFile manifest)
  }
}

/** A call to a method or constructor that may write to files to the local filesystem. */
class LocalFileOpenCall extends Storable {
  LocalFileOpenCall() {
    this = any(DataFlow::Node sink | sinkNode(sink, "create-file")).asExpr().(Argument).getCall()
  }

  override Expr getAnInput() {
    exists(DataFlow::Node n |
      filesystemInput(n, result) and
      FilesystemFlow::flow(DataFlow::exprNode(this), n)
    )
  }

  override Expr getAStore() {
    exists(DataFlow::Node n |
      closesFile(n, result) and
      FilesystemFlow::flow(DataFlow::exprNode(this), n)
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
private predicate closesFile(DataFlow::Node file, Call closeCall) {
  closeCall.getCallee() instanceof CloseFileMethod and
  if closeCall.getCallee().isStatic()
  then file.asExpr() = closeCall
  else file.asExpr() = closeCall.getQualifier()
  or
  // try-with-resources automatically closes the file
  any(TryStmt try).getAResource() = closeCall.(LocalFileOpenCall).getEnclosingStmt() and
  closeCall = file.asExpr()
}

/** A method that closes a file, perhaps after writing some data. */
private class CloseFileMethod extends Method {
  CloseFileMethod() {
    this.hasQualifiedName("java.io", ["RandomAccessFile", "FileOutputStream", "PrintStream"],
      "close")
    or
    this.getDeclaringType().getAnAncestor().hasQualifiedName("java.io", "Writer") and
    this.hasName("close")
    or
    this.hasQualifiedName("java.nio.file", "Files", ["write", "writeString"])
  }
}

private module FilesystemFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof LocalFileOpenCall }

  predicate isSink(DataFlow::Node sink) {
    filesystemInput(sink, _) or
    closesFile(sink, _)
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Add nested Writer constructors as extra data flow steps
    exists(ClassInstanceExpr cie |
      cie.getConstructedType().getAnAncestor().hasQualifiedName("java.io", "Writer") and
      node1.asExpr() = cie.getArgument(0) and
      node2.asExpr() = cie
    )
  }
}

private module FilesystemFlow = DataFlow::Global<FilesystemFlowConfig>;
