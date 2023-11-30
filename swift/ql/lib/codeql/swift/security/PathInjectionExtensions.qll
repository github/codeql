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

/** A barrier for path injection vulnerabilities. */
abstract class PathInjectionBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class PathInjectionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to path injection vulnerabilities.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultPathInjectionSink extends PathInjectionSink {
  DefaultPathInjectionSink() { sinkNode(this, "path-injection") }
}

/**
 * A sink that is a write to a global variable.
 */
private class GlobalVariablePathInjectionSink extends PathInjectionSink {
  GlobalVariablePathInjectionSink() {
    // value assigned to the sqlite3 global variable `sqlite3_temp_directory`
    // the sink should be the `DeclRefExpr` itself, but we don't currently have taint flow to globals.
    exists(AssignExpr ae |
      ae.getDest().(DeclRefExpr).getDecl().(VarDecl).getName() = "sqlite3_temp_directory" and
      ae.getSource() = this.asExpr()
    )
  }
}

/**
 * A sink that is an argument to an enum element.
 */
private class EnumConstructorPathInjectionSink extends PathInjectionSink {
  EnumConstructorPathInjectionSink() {
    // first argument to SQLite.swift's `Connection.Location.uri(_:parameters:)`
    exists(ApplyExpr ae, EnumElementDecl decl |
      ae.getFunction().(MethodLookupExpr).getMember() = decl and
      decl.hasQualifiedName("Connection.Location", "uri") and
      this.asExpr() = ae.getArgument(0).getExpr()
    )
  }
}

/**
 * A string that might be a label for a path argument.
 */
pragma[inline]
private predicate pathLikeHeuristic(string label) {
  label =
    [
      "atFile", "atPath", "atDirectory", "toFile", "toPath", "toDirectory", "inFile", "inPath",
      "inDirectory", "contentsOfFile", "contentsOfPath", "contentsOfDirectory", "filePath",
      "directory", "directoryPath"
    ]
}

/**
 * A path injection sink that is determined by imprecise methods.
 */
private class HeuristicPathInjectionSink extends PathInjectionSink {
  HeuristicPathInjectionSink() {
    // by parameter name
    exists(CallExpr ce, int ix, ParamDecl pd |
      pathLikeHeuristic(pragma[only_bind_into](pd.getName())) and
      pd.getType().getUnderlyingType().getName() = ["String", "NSString"] and
      pd = ce.getStaticTarget().getParam(ix) and
      this.asExpr() = ce.getArgument(ix).getExpr()
    )
    or
    // by argument name
    exists(Argument a |
      pathLikeHeuristic(pragma[only_bind_into](a.getLabel())) and
      a.getExpr().getType().getUnderlyingType().getName() = ["String", "NSString"] and
      this.asExpr() = a.getExpr()
    )
  }
}

private class DefaultPathInjectionBarrier extends PathInjectionBarrier {
  DefaultPathInjectionBarrier() {
    // This is a simplified implementation.
    exists(CallExpr starts, CallExpr normalize, DataFlow::Node validated |
      starts.getStaticTarget().getName() = "starts(with:)" and
      starts.getStaticTarget().getEnclosingDecl().asNominalTypeDecl() instanceof FilePath and
      normalize.getStaticTarget().getName() = "lexicallyNormalized()" and
      normalize.getStaticTarget().getEnclosingDecl().asNominalTypeDecl() instanceof FilePath
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
        ";Data;true;init(contentsOf:options:);;;Argument[0];path-injection",
        ";Data;true;write(to:options:);;;Argument[0];path-injection",
        ";NSData;true;init(contentsOfFile:);;;Argument[0];path-injection",
        ";NSData;true;init(contentsOfFile:options:);;;Argument[0];path-injection",
        ";NSData;true;init(contentsOf:);;;Argument[0];path-injection",
        ";NSData;true;init(contentsOf:options:);;;Argument[0];path-injection",
        ";NSData;true;init(contentsOfMappedFile:);;;Argument[0];path-injection",
        ";NSData;true;dataWithContentsOfMappedFile(_:);;;Argument[0];path-injection",
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
        ";FileManager;true;attributesOfItem(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;contents(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;contentsEqual(atPath:andPath:);;;Argument[0..1];path-injection",
        ";FileManager;true;changeCurrentDirectoryPath(_:);;;Argument[0];path-injection",
        ";FileManager;true;unmountVolume(at:options:completionHandler:);;;Argument[0];path-injection",
        // Deprecated FileManager methods:
        ";FileManager;true;changeFileAttributes(_:atPath:);;;Argument[1];path-injection",
        ";FileManager;true;fileAttributes(atPath:traverseLink:);;;Argument[0];path-injection",
        ";FileManager;true;directoryContents(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;createDirectory(atPath:attributes:);;;Argument[0];path-injection",
        ";FileManager;true;createSymbolicLink(atPath:pathContent:);;;Argument[0..1];path-injection",
        ";FileManager;true;pathContentOfSymbolicLink(atPath:);;;Argument[0];path-injection",
        ";FileManager;true;replaceItemAtURL(originalItemURL:withItemAtURL:backupItemName:options:);;;Argument[0..1];path-injection",
        ";NIOFileHandle;true;init(descriptor:);;;Argument[0];path-injection",
        ";NIOFileHandle;true;init(path:mode:flags:);;;Argument[0];path-injection",
        ";NIOFileHandle;true;init(path:);;;Argument[0];path-injection",
        ";String;true;init(contentsOfFile:);;;Argument[0];path-injection",
        ";String;true;init(contentsOfFile:encoding:);;;Argument[0];path-injection",
        ";String;true;init(contentsOfFile:usedEncoding:);;;Argument[0];path-injection",
        ";NSString;true;init(contentsOfFile:encoding:);;;Argument[0];path-injection",
        ";NSString;true;init(contentsOfFile:usedEncoding:);;;Argument[0];path-injection",
        ";NSString;true;write(to:atomically:encoding:);;;Argument[0];path-injection",
        ";NSString;true;write(toFile:atomically:encoding:);;;Argument[0];path-injection",
        ";NSKeyedUnarchiver;true;unarchiveObject(withFile:);;;Argument[0];path-injection",
        ";ArchiveByteStream;true;fileStream(fd:automaticClose:);;;Argument[0];path-injection",
        ";ArchiveByteStream;true;withFileStream(fd:automaticClose:_:);;;Argument[0];path-injection",
        ";ArchiveByteStream;true;fileStream(path:mode:options:permissions:);;;Argument[0];path-injection",
        ";ArchiveByteStream;true;withFileStream(path:mode:options:permissions:_:);;;Argument[0];path-injection",
        ";Bundle;true;init(url:);;;Argument[0];path-injection",
        ";Bundle;true;init(path:);;;Argument[0];path-injection",
        ";NSURL;writeBookmarkData(_:to:options:);;;Argument[1];path-injection",
        // GRDB
        ";Database;true;init(path:description:configuration:);;;Argument[0];path-injection",
        ";DatabasePool;true;init(path:configuration:);;;Argument[0];path-injection",
        ";DatabaseQueue;true;init(path:configuration:);;;Argument[0];path-injection",
        ";DatabaseSnapshotPool;true;init(path:configuration:);;;Argument[0];path-injection",
        ";SerializedDatabase;true;init(path:configuration:defaultLabel:purpose:);;;Argument[0];path-injection",
        // Realm
        ";Realm.Configuration;true;init(fileURL:inMemoryIdentifier:syncConfiguration:encryptionKey:readOnly:schemaVersion:migrationBlock:deleteRealmIfMigrationNeeded:shouldCompactOnLaunch:objectTypes:);;;Argument[0];path-injection",
        ";Realm.Configuration;true;init(fileURL:inMemoryIdentifier:syncConfiguration:encryptionKey:readOnly:schemaVersion:migrationBlock:deleteRealmIfMigrationNeeded:shouldCompactOnLaunch:objectTypes:seedFilePath:);;;Argument[0];path-injection",
        ";Realm.Configuration;true;init(fileURL:inMemoryIdentifier:syncConfiguration:encryptionKey:readOnly:schemaVersion:migrationBlock:deleteRealmIfMigrationNeeded:shouldCompactOnLaunch:objectTypes:seedFilePath:);;;Argument[10];path-injection",
        ";Realm.Configuration;true;fileURL;;;PostUpdate;path-injection",
        ";Realm.Configuration;true;seedFilePath;;;PostUpdate;path-injection",
        // sqlite3
        ";;false;sqlite3_open(_:_:);;;Argument[0];path-injection",
        ";;false;sqlite3_open16(_:_:);;;Argument[0];path-injection",
        ";;false;sqlite3_open_v2(_:_:_:_:);;;Argument[0];path-injection",
        ";;false;sqlite3_database_file_object(_:);;;Argument[0];path-injection",
        ";;false;sqlite3_filename_database(_:);;;Argument[0];path-injection",
        ";;false;sqlite3_filename_journal(_:);;;Argument[0];path-injection",
        ";;false;sqlite3_filename_wal(_:);;;Argument[0];path-injection",
        ";;false;sqlite3_free_filename(_:);;;Argument[0];path-injection",
        // SQLite.swift
        ";Connection;true;init(_:readonly:);;;Argument[0];path-injection",
      ]
  }
}
