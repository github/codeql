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
  abstract DataFlow::Node getAFileName();
}

/**
 * A node that contains a file name, and is produced by a `ProducesFileNames`.
 */
private class ProducedFileName extends FileNameSource {
  ProducedFileName() { this = any(FileNameProducer producer).getAFileName() }
}

/**
 * A file name from the `walk-sync` library.
 */
private class WalkSyncFileNameSource extends FileNameSource {
  WalkSyncFileNameSource() {
    // `require('walk-sync')()`
    this = DataFlow::moduleImport("walk-sync").getACall()
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
 * Gets a file name or an array of file names from the `globby` library.
 * The predicate uses type-tracking. However, type-tracking is only used to track a step out of a promise.
 */
private DataFlow::SourceNode globbyFileNameSource(DataFlow::TypeTracker t) {
  exists(string moduleName | moduleName = "globby" |
    // `require('globby').sync(_)`
    t.start() and
    result = DataFlow::moduleMember(moduleName, "sync").getACall()
    or
    // `files` in `require('globby')(_).then(files => ...)`
    t.startInPromise() and
    result = DataFlow::moduleImport(moduleName).getACall()
  )
  or
  // Tracking out of a promise
  exists(DataFlow::TypeTracker t2 |
    result = PromiseTypeTracking::promiseStep(globbyFileNameSource(t2), t, t2)
  )
}

/**
 * A file name or an array of file names from the `globby` library.
 */
private class GlobbyFileNameSource extends FileNameSource {
  GlobbyFileNameSource() { this = globbyFileNameSource(DataFlow::TypeTracker::end()) }
}

/**
 * Gets a file name or an array of file names from the `fast-glob` library.
 * The predicate uses type-tracking. However, type-tracking is only used to track a step out of a promise.
 */
private DataFlow::Node fastGlobFileNameSource(DataFlow::TypeTracker t) {
  exists(string moduleName | moduleName = "fast-glob" |
    // `require('fast-glob').sync(_)
    t.start() and result = DataFlow::moduleMember(moduleName, "sync").getACall()
    or
    exists(DataFlow::SourceNode f |
      f = DataFlow::moduleImport(moduleName)
      or
      f = DataFlow::moduleMember(moduleName, "async")
    |
      // `files` in `require('fast-glob')(_).then(files => ...)` and
      // `files` in `require('fast-glob').async(_).then(files => ...)`
      t.startInPromise() and result = f.getACall()
    )
    or
    // `file` in `require('fast-glob').stream(_).on(_,  file => ...)`
    t.start() and
    result =
      DataFlow::moduleMember(moduleName, "stream")
          .getACall()
          .getAMethodCall(EventEmitter::on())
          .getCallback(1)
          .getParameter(0)
  )
  or
  // Tracking out of a promise
  exists(DataFlow::TypeTracker t2 |
    result = PromiseTypeTracking::promiseStep(fastGlobFileNameSource(t2), t, t2)
  )
}

/**
 * A file name or an array of file names from the `fast-glob` library.
 */
private class FastGlobFileNameSource extends FileNameSource {
  FastGlobFileNameSource() { this = fastGlobFileNameSource(DataFlow::TypeTracker::end()) }
}

/**
 * Classes and predicates for modelling the `fstream` library (https://www.npmjs.com/package/fstream).
 */
private module FStream {
  /**
   * Gets a reference to a method in the `fstream` library.
   */
  private DataFlow::SourceNode getAnFStreamProperty(boolean writer) {
    exists(DataFlow::SourceNode mod, string readOrWrite, string subMod |
      mod = DataFlow::moduleImport("fstream") and
      (
        readOrWrite = "Reader" and writer = false
        or
        readOrWrite = "Writer" and writer = true
      ) and
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
    boolean writer;

    FStream() { this = getAnFStreamProperty(writer).getAnInvocation() }

    override DataFlow::Node getAPathArgument() {
      result = getOptionArgument(0, "path")
      or
      not exists(getOptionArgument(0, "path")) and
      result = getArgument(0)
    }
  }

  /**
   * An invocation of an `fstream` method that writes to a file.
   */
  private class FStreamWriter extends FileSystemWriteAccess, FStream {
    FStreamWriter() { writer = true }

    override DataFlow::Node getADataNode() { none() }
  }

  /**
   * An invocation of an `fstream` method that reads a file.
   */
  private class FStreamReader extends FileSystemReadAccess, FStream {
    FStreamReader() { writer = false }

    override DataFlow::Node getADataNode() { none() }
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
private class RecursiveReadDir extends FileSystemAccess, FileNameProducer, DataFlow::CallNode {
  RecursiveReadDir() { this = DataFlow::moduleImport("recursive-readdir").getACall() }

  override DataFlow::Node getAPathArgument() { result = getArgument(0) }

  override DataFlow::Node getAFileName() { result = trackFileSource(DataFlow::TypeTracker::end()) }

  private DataFlow::SourceNode trackFileSource(DataFlow::TypeTracker t) {
    t.start() and result = getCallback([1 .. 2]).getParameter(1)
    or
    t.startInPromise() and not exists(getCallback([1 .. 2])) and result = this
    or
    // Tracking out of a promise
    exists(DataFlow::TypeTracker t2 |
      result = PromiseTypeTracking::promiseStep(trackFileSource(t2), t, t2)
    )
  }
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

    override DataFlow::Node getADataNode() { result = trackRead(DataFlow::TypeTracker::end()) }

    private DataFlow::SourceNode trackRead(DataFlow::TypeTracker t) {
      this.getCalleeName() = "readFile" and
      (
        t.start() and result = getCallback([1 .. 2]).getParameter(1)
        or
        t.startInPromise() and not exists(getCallback([1 .. 2])) and result = this
      )
      or
      t.start() and
      this.getCalleeName() = "readFileSync" and
      result = this
      or
      // Tracking out of a promise
      exists(DataFlow::TypeTracker t2 |
        result = PromiseTypeTracking::promiseStep(trackRead(t2), t, t2)
      )
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
 * A call to the library `load-json-file`.
 */
private class LoadJsonFile extends FileSystemReadAccess, DataFlow::CallNode {
  LoadJsonFile() {
    this = DataFlow::moduleImport("load-json-file").getACall()
    or
    this = DataFlow::moduleMember("load-json-file", "sync").getACall()
  }

  override DataFlow::Node getAPathArgument() { result = getArgument(0) }

  override DataFlow::Node getADataNode() { result = trackRead(DataFlow::TypeTracker::end()) }

  private DataFlow::SourceNode trackRead(DataFlow::TypeTracker t) {
    this.getCalleeName() = "sync" and t.start() and result = this
    or
    not this.getCalleeName() = "sync" and t.startInPromise() and result = this
    or
    // Tracking out of a promise
    exists(DataFlow::TypeTracker t2 |
      result = PromiseTypeTracking::promiseStep(trackRead(t2), t, t2)
    )
  }
}

/**
 * A call to the library `write-json-file`.
 */
private class WriteJsonFile extends FileSystemWriteAccess, DataFlow::CallNode {
  WriteJsonFile() {
    this = DataFlow::moduleImport("write-json-file").getACall()
    or
    this = DataFlow::moduleMember("write-json-file", "sync").getACall()
  }

  override DataFlow::Node getAPathArgument() { result = getArgument(0) }

  override DataFlow::Node getADataNode() { result = getArgument(1) }
}

/**
 * A call to the library `walkdir`.
 */
private class WalkDir extends FileNameProducer, FileSystemAccess, DataFlow::CallNode {
  WalkDir() {
    this = DataFlow::moduleImport("walkdir").getACall()
    or
    this = DataFlow::moduleMember("walkdir", "sync").getACall()
    or
    this = DataFlow::moduleMember("walkdir", "async").getACall()
  }

  override DataFlow::Node getAPathArgument() { result = getArgument(0) }

  override DataFlow::Node getAFileName() { result = trackFileSource(DataFlow::TypeTracker::end()) }

  private DataFlow::SourceNode trackFileSource(DataFlow::TypeTracker t) {
    not this.getCalleeName() = any(string s | s = "sync" or s = "async") and
    t.start() and
    (
      result = getCallback(getNumArgument() - 1).getParameter(0)
      or
      result = getAMethodCall(EventEmitter::on()).getCallback(1).getParameter(0)
    )
    or
    t.start() and this.getCalleeName() = "sync" and result = this
    or
    t.startInPromise() and this.getCalleeName() = "async" and result = this
    or
    // Tracking out of a promise
    exists(DataFlow::TypeTracker t2 |
      result = PromiseTypeTracking::promiseStep(trackFileSource(t2), t, t2)
    )
  }
}

/**
 * A call to the library `globule`.
 */
private class Globule extends FileNameProducer, FileSystemAccess, DataFlow::CallNode {
  Globule() {
    this = DataFlow::moduleMember("globule", "find").getACall()
    or
    this = DataFlow::moduleMember("globule", "match").getACall()
    or
    this = DataFlow::moduleMember("globule", "isMatch").getACall()
    or
    this = DataFlow::moduleMember("globule", "mapping").getACall()
    or
    this = DataFlow::moduleMember("globule", "findMapping").getACall()
  }

  override DataFlow::Node getAPathArgument() {
    (this.getCalleeName() = "match" or this.getCalleeName() = "isMatch") and
    result = getArgument(1)
    or
    this.getCalleeName() = "mapping" and
    (
      result = getAnArgument() and not exists(result.getALocalSource().getAPropertyWrite("src"))
      or
      result = getAnArgument().getALocalSource().getAPropertyWrite("src").getRhs()
    )
  }

  override DataFlow::Node getAFileName() {
    result = this and
    (
      this.getCalleeName() = "find" or
      this.getCalleeName() = "match" or
      this.getCalleeName() = "findMapping" or
      this.getCalleeName() = "mapping"
    )
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
      this = DataFlow::moduleImport("readdirp").getACall()
      or
      this = DataFlow::moduleImport("walker").getACall()
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
