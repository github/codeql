/** Provides classes and predicates to reason about path injection vulnerabilities. */

import swift
private import codeql.swift.controlflow.BasicBlocks
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.generated.ParentChild
private import codeql.swift.frameworks.StandardLibrary.FilePath

/** A data flow sink for path injection vulnerabilities. */
abstract class PathInjectionSink extends DataFlow::Node { }

/** A sanitizer for path injection vulnerabilities. */
abstract class PathInjectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to paths related to
 * path injection vulnerabilities.
 */
class PathInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for paths related to path injection vulnerabilities.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

private class DefaultPathInjectionSink extends PathInjectionSink {
  DefaultPathInjectionSink() { sinkNode(this, "path-injection") }
}

private class DefaultPathInjectionSanitizer extends PathInjectionSanitizer {
  DefaultPathInjectionSanitizer() {
    // This is a simplified implementation.
    // TODO: Implement a complete path sanitizer when Guards are available.
    exists(CallExpr starts, CallExpr normalize, DataFlow::Node validated |
      starts.getStaticTarget().getName() = "starts(with:)" and
      starts.getStaticTarget().getEnclosingDecl() instanceof FilePath and
      normalize.getStaticTarget().getName() = "lexicallyNormalized()" and
      normalize.getStaticTarget().getEnclosingDecl() instanceof FilePath
    |
      TaintTracking::localTaint(validated, DataFlow::exprNode(normalize.getQualifier())) and
      DataFlow::localExprFlow(normalize, starts.getQualifier()) and
      DataFlow::localFlow(validated, this) and
      exists(ConditionBlock bb, SuccessorTypes::BooleanSuccessor b |
        bb.getANode().getNode().asAstNode().(IfStmt).getACondition() = getImmediateParent*(starts) and
        b.getValue() = true
      |
        bb.controls(this.getCfgNode().getBasicBlock(), b)
      )
    )
  }
}

private class PathInjectionSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Data;true;write(to:options:);;;Argument[0];path-injection",
        ";NSData;true;write(to:atomically:);;;Argument[0];path-injection",
        ";NSData;true;write(to:options:);;;Argument[0];path-injection",
        ";NSData;true;write(toFile:atomically:);;;Argument[0];path-injection",
        ";NSData;true;write(toFile:options:);;;Argument[0];path-injection",
        ";FileManager;true;contentsOfDirectory(at:includingPropertiesForKeys:options:);;;Argument[0];path-injection",
        ";FileManager;true;contentsOfDirectory(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;enumerator(at:includingPropertiesForKeys:options:errorHandler:);;;Argument[0];path-injection",
        ";FileManager;true;enumerator(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;subpathsOfDirectory(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;subpaths(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;createDirectory(at:withIntermediateDirectories:attributes:);;;Argument[0];path-injection",
        ";FileManager;true;createDirectory(atPath:withIntermediateDirectories:attributes:);;;Argument[0];path-injection",
        ";FileManager;true;createFile(atPath:contents:attributes:);;;Argument[0];path-injection",
        ";FileManager;true;removeItem(at:);;;Argument[0];path-injection",
        ";FileManager;true;removeItem(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;trashItem(at:resultingItemURL:);;;Argument[0];path-injection",
        ";FileManager;true;replaceItem(at:withItemAt:backupItemName:options:resultingItemURL:);;;Argument[0..1];path-injection",
        ";FileManager;true;replaceItemAt(_:withItemAt:backupItemName:options:);;;Argument[0..1];path-injection",
        ";FileManager;true;copyItem(at:to:);;;Argument[0..1];path-injection",
        ";FileManager;true;copyItem(atPath:toPath:);;;Argument[0..1];path-injection",
        ";FileManager;true;moveItem(at:to:);;;Argument[0..1];path-injection",
        ";FileManager;true;moveItem(atPath:toPath:);;;Argument[0..1];path-injection",
        ";FileManager;true;createSymbolicLink(at:withDestinationURL:);;;Argument[0..1];path-injection",
        ";FileManager;true;createSymbolicLink(atPath:withDestinationPath:);;;Argument[0..1];path-injection",
        ";FileManager;true;linkItem(at:to:);;;Argument[0..1];path-injection",
        ";FileManager;true;linkItem(atPath:toPath:);;;Argument[0..1];path-injection",
        ";FileManager;true;destinationOfSymbolicLink(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;fileExists(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;fileExists(atPath:isDirectory:);;;Argument[0];path-injection",
        ";FileManager;true;setAttributes(_:ofItemAtPath:);;;Argument[1];path-injection",
        ";FileManager;true;contents(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;contentsEqual(atPath:andPath:);;;Argument[0..1];path-injection",
        ";FileManager;true;changeCurrentDirectoryPath(_:);;;Argument[0];path-injection",
        ";FileManager;true;unmountVolume(at:options:completionHandler:);;;Argument[0];path-injection",
        // Deprecated FileManager methods:
        ";FileManager;true;changeFileAttributes(_:atPath:);;;Argument[1];path-injection",
        ";FileManager;true;directoryContents(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;createDirectory(atPath:attributes:);;;Argument[0];path-injection",
        ";FileManager;true;createSymbolicLink(atPath:pathContent:);;;Argument[0..1];path-injection",
        ";FileManager;true;pathContentOfSymbolicLink(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;replaceItemAtURL(originalItemURL:withItemAtURL:backupItemName:options:);;;Argument[0..1];path-injection",
        ";NIOFileHandle;true;init(descriptor:);;;Argument[0];path-injection",
        ";NIOFileHandle;true;init(path:mode:flags:);;;Argument[0];path-injection",
        ";NIOFileHandle;true;init(path:);;;Argument[0];path-injection",
        ";NSString;true;write(to:atomically:encoding:);;;Argument[0];path-injection",
        ";NSString;true;write(toFile:atomically:encoding:);;;Argument[0];path-injection",
        ";NSKeyedUnarchiver;true;unarchiveObject(withFile:);;;Argument[0];path-injection",
        ";ArchiveByteStream;true;fileStream(fd:automaticClose:);;;Argument[0];path-injection",
        ";ArchiveByteStream;true;withFileStream(fd:automaticClose:_:);;;Argument[0];path-injection",
        ";ArchiveByteStream;true;fileStream(path:mode:options:permissions:);;;Argument[0];path-injection",
        ";ArchiveByteStream;true;withFileStream(path:mode:options:permissions:_:);;;Argument[0];path-injection",
        ";Bundle;true;init(url:);;;Argument[0];path-injection",
        ";Bundle;true;init(path:);;;Argument[0];path-injection",
        // GRDB
        ";Database;true;init(path:description:configuration:);;;Argument[0];path-injection",
        ";DatabasePool;true;init(path:configuration:);;;Argument[0];path-injection",
        ";DatabaseQueue;true;init(path:configuration:);;;Argument[0];path-injection",
        ";DatabaseSnapshotPool;true;init(path:configuration:);;;Argument[0];path-injection",
        ";SerializedDatabase;true;init(path:configuration:defaultLabel:purpose:);;;Argument[0];path-injection"
      ]
  }
}
