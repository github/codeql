/**
 * @name Arbitrary file write during zipfile extraction
 * @description Extracting files from a malicious zip archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
 * @kind path-problem
 * @id py/zipslip
 * @problem.severity error
 * @precision medium
 * @tags security
 *       external/cwe/cwe-022
 */

import python
import semmle.python.security.Paths
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic

/** A TaintKind to represent open zipfile objects. That is, the result of calling `zipfile.ZipFile(...)` */
class OpenZipFile extends TaintKind {
  OpenZipFile() { this = "zipfile.ZipFile" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "getinfo" and result instanceof ZipFileInfo
    or
    name = "infolist" and result.(SequenceKind).getItem() instanceof ZipFileInfo
    or
    name = "namelist" and result.(SequenceKind).getItem() instanceof ZipFileInfo
  }

  override ClassValue getType() { result = Value::named("zipfile.ZipFile") }

  override TaintKind getTaintForIteration() { result instanceof ZipFileInfo }
}

/** The source of open zipfile objects. That is, any call to `zipfile.ZipFile(...)` */
class ZipfileOpen extends TaintSource {
  ZipfileOpen() {
    Value::named("zipfile.ZipFile").getACall() = this and
    /*
     * If argument refers to a string object, then it's a hardcoded path and
     * this zipfile is safe.
     */

    not this.(CallNode).getAnArg().pointsTo(any(StringValue str)) and
    /* Ignore opens within the zipfile module itself */
    not this.(ControlFlowNode).getLocation().getFile().getBaseName() = "zipfile.py"
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof OpenZipFile }
}

class ZipFileInfo extends TaintKind {
  ZipFileInfo() { this = "zipfile.entry" }

  override TaintKind getTaintOfMethodResult(string name) { name = "next" and result = this }

  override TaintKind getTaintOfAttribute(string name) {
    name = "name" and result instanceof ZipFileInfo
  }
}

/*
 * For efficiency we don't want to track the flow of taint
 * around the zipfile module.
 */

class ExcludeZipFilePy extends Sanitizer {
  ExcludeZipFilePy() { this = "Zip sanitizer" }

  override predicate sanitizingNode(TaintKind taint, ControlFlowNode node) {
    node.getLocation().getFile().getBaseName() = "zipfile.py" and
    (
      taint instanceof OpenZipFile
      or
      taint instanceof ZipFileInfo
      or
      taint.(SequenceKind).getItem() instanceof ZipFileInfo
    )
  }
}

/* Any call to an extractall method */
class ExtractAllSink extends TaintSink {
  CallNode call;

  ExtractAllSink() {
    this = call.getFunction().(AttrNode).getObject("extractall") and
    count(call.getAnArg()) = 0
  }

  override predicate sinks(TaintKind kind) { kind instanceof OpenZipFile }
}

/* Argument to extract method */
class ExtractSink extends TaintSink {
  CallNode call;

  ExtractSink() {
    call.getFunction().(AttrNode).getName() = "extract" and
    this = call.getArg(0)
  }

  override predicate sinks(TaintKind kind) { kind instanceof ZipFileInfo }
}

/* Members argument to extract method */
class ExtractMembersSink extends TaintSink {
  CallNode call;

  ExtractMembersSink() {
    call.getFunction().(AttrNode).getName() = "extractall" and
    (this = call.getArg(0) or this = call.getArgByName("members"))
  }

  override predicate sinks(TaintKind kind) {
    kind.(SequenceKind).getItem() instanceof ZipFileInfo
    or
    kind instanceof OpenZipFile
  }
}

class ZipFileInfoSanitizer extends Sanitizer {
  ZipFileInfoSanitizer() { this = "ZipInfo sanitizer" }

  /** The test `if <path_sanitizing_test>:` clears taint on its `false` edge. */
  override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
    taint instanceof ZipFileInfo and
    clears_taint_on_false_edge(test.getTest(), test.getSense())
  }

  private predicate clears_taint_on_false_edge(ControlFlowNode test, boolean sense) {
    path_sanitizing_test(test) and
    sense = false
    or
    // handle `not` (also nested)
    test.(UnaryExprNode).getNode().getOp() instanceof Not and
    clears_taint_on_false_edge(test.(UnaryExprNode).getOperand(), sense.booleanNot())
  }
}

private predicate path_sanitizing_test(ControlFlowNode test) {
  /* Assume that any test with "path" in it is a sanitizer */
  test.getAChild+().(AttrNode).getName().matches("%path")
  or
  test.getAChild+().(NameNode).getId().matches("%path")
}

class ZipSlipConfiguration extends TaintTracking::Configuration {
  ZipSlipConfiguration() { this = "ZipSlip configuration" }

  override predicate isSource(TaintTracking::Source source) { source instanceof ZipfileOpen }

  override predicate isSink(TaintTracking::Sink sink) {
    sink instanceof ExtractSink or
    sink instanceof ExtractAllSink or
    sink instanceof ExtractMembersSink
  }

  override predicate isSanitizer(Sanitizer sanitizer) {
    sanitizer instanceof ZipFileInfoSanitizer
    or
    sanitizer instanceof ExcludeZipFilePy
  }

  override predicate isBarrier(DataFlow::Node node) {
    // Avoid flow into the zipfile module
    exists(ParameterDefinition def |
      node.asVariable().getDefinition() = def
      or
      node.asCfgNode() = def.getDefiningNode()
    |
      def.getScope() = Value::named("zipfile.ZipFile").(CallableValue).getScope()
      or
      def.isSelf() and def.getScope().getEnclosingModule().getName() = "zipfile"
    )
  }
}

from ZipSlipConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "Extraction of zipfile from $@", src.getSource(),
  "a potentially untrusted source"
