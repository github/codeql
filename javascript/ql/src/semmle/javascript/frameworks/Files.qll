/**
 * Provides classes for working with file system libraries.
 */

import javascript

/**
 * A call that can produce a file name.
 */
abstract private class FileNameProducer extends DataFlow::Node {
  /**
   * Gets a file name produced by this producer.
   */
  abstract DataFlow::Node getAFileNameSource();
}

/**
 * A node that contains a file name, and is produced by a `ProducesFileNames`.
 */
private class ProducedFileName extends FileNameSource {
  ProducedFileName() { this = any(ProducesFileNames producer).getAFileNameSource() }
}

/**
 * A file name from the `walk-sync` library.
 */
private class WalkSyncFileNameSource extends FileNameSource {
  WalkSyncFileNameSource() {
    // `require('walkSync')()`
    this = DataFlow::moduleImport("walkSync").getACall()
  }
}

/**
 * A file name or an array of file names from the `walk` library.
 */
private class WalkFileNameSource extends FileNameSource {
  WalkFileNameSource() {
    // `stats.name` in `require('walk').walk(_).on(_,  (_, stats) => stats.name)`
    exists(DataFlow::FunctionNode callback |
      callback =
        DataFlow::moduleMember("walk", "walk")
            .getACall()
            .getAMethodCall(EventEmitter::on())
            .getCallback(1)
    |
      this = callback.getParameter(1).getAPropertyRead("name")
    )
  }
}

/**
 * A file name or an array of file names from the `glob` library.
 */
private class GlobFileNameSource extends FileNameSource {
  GlobFileNameSource() {
    exists(string moduleName | moduleName = "glob" |
      // `require('glob').sync(_)`
      this = DataFlow::moduleMember(moduleName, "sync").getACall()
      or
      // `name` in `require('glob')(_, (e, name) => ...)`
      this = DataFlow::moduleImport(moduleName).getACall().getCallback([1 .. 2]).getParameter(1)
      or
      exists(DataFlow::NewNode instance |
        instance = DataFlow::moduleMember(moduleName, "Glob").getAnInstantiation()
      |
        // `name` in `new require('glob').Glob(_, (e, name) => ...)`
        this = instance.getCallback([1 .. 2]).getParameter(1)
        or
        // `new require('glob').Glob(_).found`
        this = instance.getAPropertyRead("found")
      )
    )
  }
}

/**
 * A file name or an array of file names from the `globby` library.
 */
private class GlobbyFileNameSource extends FileNameSource {
  GlobbyFileNameSource() {
    exists(string moduleName | moduleName = "globby" |
      // `require('globby').sync(_)`
      this = DataFlow::moduleMember(moduleName, "sync").getACall()
      or
      // `files` in `require('globby')(_).then(files => ...)`
      this =
        DataFlow::moduleImport(moduleName)
            .getACall()
            .getAMethodCall("then")
            .getCallback(0)
            .getParameter(0)
    )
  }
}

/**
 * A file name or an array of file names from the `fast-glob` library.
 */
private class FastGlobFileNameSource extends FileNameSource {
  FastGlobFileNameSource() {
    exists(string moduleName | moduleName = "fast-glob" |
      // `require('fast-glob').sync(_)`
      this = DataFlow::moduleMember(moduleName, "sync").getACall()
      or
      exists(DataFlow::SourceNode f |
        f = DataFlow::moduleImport(moduleName)
        or
        f = DataFlow::moduleMember(moduleName, "async")
      |
        // `files` in `require('fast-glob')(_).then(files => ...)` and
        // `files` in `require('fast-glob').async(_).then(files => ...)`
        this = f.getACall().getAMethodCall("then").getCallback(0).getParameter(0)
      )
      or
      // `file` in `require('fast-glob').stream(_).on(_,  file => ...)`
      this =
        DataFlow::moduleMember(moduleName, "stream")
            .getACall()
            .getAMethodCall(EventEmitter::on())
            .getCallback(1)
            .getParameter(0)
    )
  }
}

/**
 * Classes and predicates for modelling the `fstream` library (https://www.npmjs.com/package/fstream).
 */
private module FStream {
  /**
   * Gets a reference to a method in the `fstream` library.
   */
  private DataFlow::SourceNode getAnFStreamProperty() {
    exists(DataFlow::SourceNode mod, string readOrWrite, string subMod |
      mod = DataFlow::moduleImport("fstream") and
      (readOrWrite = "Reader" or readOrWrite = "Writer") and
      (subMod = "File" or subMod = "Dir" or subMod = "Link" or subMod = "Proxy")
    |
      result = mod.getAPropertyRead(readOrWrite) or
      result = mod.getAPropertyRead(readOrWrite).getAPropertyRead(subMod) or
      result = mod.getAPropertyRead(subMod).getAPropertyRead(readOrWrite)
    )
  }

  /**
   * An invocation of a method defined in the `fstream` library.
   */
  private class FStream extends FileSystemAccess, DataFlow::InvokeNode {
    FStream() { this = getAnFStreamProperty().getAnInvocation() }

    override DataFlow::Node getAPathArgument() {
      result = getOptionArgument(0, "path")
      or
      not exists(getOptionArgument(0, "path")) and
      result = getArgument(0)
    }
  }
}

/**
 * A call to the library `write-file-atomic`.
 */
private class WriteFileAtomic extends FileSystemWriteAccess, DataFlow::CallNode {
  WriteFileAtomic() {
    this = DataFlow::moduleImport("write-file-atomic").getACall()
    or
    this = DataFlow::moduleMember("write-file-atomic", "sync").getACall()
  }

  override DataFlow::Node getAPathArgument() { result = getArgument(0) }

  override DataFlow::Node getADataNode() { result = getArgument(1) }
}

/**
 * A call to the library `recursive-readdir`.
 */
private class RecursiveReadDir extends FileSystemAccess, ProducesFileNames, DataFlow::CallNode {
  RecursiveReadDir() { this = DataFlow::moduleImport("recursive-readdir").getACall() }

  override DataFlow::Node getAPathArgument() { result = getArgument(0) }

  override DataFlow::Node getAFileNameSource() { result = getCallback([1 .. 2]).getParameter(1) }
}

/**
 * Classes and predicates for modelling the `jsonfile` library (https://www.npmjs.com/package/jsonfile).
 */
private module JSONFile {
  /**
   * A reader for JSON files.
   */
  class JSONFileReader extends FileSystemReadAccess, DataFlow::CallNode {
    JSONFileReader() {
      this =
        DataFlow::moduleMember("jsonfile", any(string s | s = "readFile" or s = "readFileSync"))
            .getACall()
    }

    override DataFlow::Node getAPathArgument() { result = getArgument(0) }

    override DataFlow::Node getADataNode() {
      this.getCalleeName() = "readFile" and result = getCallback([1 .. 2]).getParameter(1)
      or
      this.getCalleeName() = "readFileSync" and result = this
    }
  }

  /**
   * A writer for JSON files.
   */
  class JSONFileWriter extends FileSystemWriteAccess, DataFlow::CallNode {
    JSONFileWriter() {
      this =
        DataFlow::moduleMember("jsonfile", any(string s | s = "writeFile" or s = "writeFileSync"))
            .getACall()
    }

    override DataFlow::Node getAPathArgument() { result = getArgument(0) }

    override DataFlow::Node getADataNode() { result = getArgument(1) }
  }
}

/**
 * A file system access made by a NodeJS library.
 * This class models multiple NodeJS libraries that access files.
 */
private class LibraryAccess extends FileSystemAccess, DataFlow::InvokeNode {
  int pathArgument; // The index of the path argument.

  LibraryAccess() {
    pathArgument = 0 and
    (
      this = DataFlow::moduleImport("path-exists").getACall()
      or
      this = DataFlow::moduleImport("rimraf").getACall()
      or
      this =
        DataFlow::moduleMember("node-dir",
          any(string s |
            s = "readFiles" or
            s = "readFilesStream" or
            s = "files" or
            s = "promiseFiles" or
            s = "subdirs" or
            s = "paths"
          )).getACall()
    )
    or
    pathArgument = 0 and
    this =
      DataFlow::moduleMember("vinyl-fs", any(string s | s = "src" or s = "dest" or s = "symlink"))
          .getACall()
    or
    pathArgument = [0 .. 1] and
    (
      this = DataFlow::moduleImport("ncp").getACall() or
      this = DataFlow::moduleMember("ncp", "ncp").getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = getArgument(pathArgument) }
}
