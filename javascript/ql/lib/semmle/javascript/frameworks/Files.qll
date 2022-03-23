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
 */
private API::Node globbyFileNameSource() {
  // `require('globby').sync(_)`
  result = API::moduleImport("globby").getMember("sync").getReturn()
  or
  // `files` in `require('globby')(_).then(files => ...)`
  result = API::moduleImport("globby").getReturn().getPromised()
}

/**
 * A file name or an array of file names from the `globby` library.
 */
private class GlobbyFileNameSource extends FileNameSource {
  GlobbyFileNameSource() { this = globbyFileNameSource().getAnImmediateUse() }
}

/** Gets a file name or an array of file names from the `fast-glob` library. */
private API::Node fastGlobFileName() {
  // `require('fast-glob').sync(_)
  result = API::moduleImport("fast-glob").getMember("sync").getReturn()
  or
  exists(API::Node base |
    base = [API::moduleImport("fast-glob"), API::moduleImport("fast-glob").getMember("async")]
  |
    result = base.getReturn().getPromised()
  )
  or
  result =
    API::moduleImport("fast-glob")
        .getMember("stream")
        .getReturn()
        .getMember(EventEmitter::on())
        .getParameter(1)
        .getParameter(0)
}

/**
 * A file name or an array of file names from the `fast-glob` library.
 */
private class FastGlobFileNameSource extends FileNameSource {
  FastGlobFileNameSource() { this = fastGlobFileName().getAnImmediateUse() }
}

/**
 * Classes and predicates for modeling the `fstream` library (https://www.npmjs.com/package/fstream).
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
      subMod = ["File", "Dir", "Link", "Proxy"]
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
      result = this.getOptionArgument(0, "path")
      or
      not exists(this.getOptionArgument(0, "path")) and
      result = this.getArgument(0)
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

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

  override DataFlow::Node getADataNode() { result = this.getArgument(1) }
}

/**
 * A call to the library `recursive-readdir`.
 */
private class RecursiveReadDir extends FileSystemAccess, FileNameProducer, API::CallNode {
  RecursiveReadDir() { this = API::moduleImport("recursive-readdir").getACall() }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

  override DataFlow::Node getAFileName() { result = this.trackFileSource().getAnImmediateUse() }

  private API::Node trackFileSource() {
    result = this.getParameter([1 .. 2]).getParameter(1)
    or
    not exists(this.getCallback([1 .. 2])) and result = this.getReturn().getPromised()
  }
}

/**
 * Classes and predicates for modeling the `jsonfile` library (https://www.npmjs.com/package/jsonfile).
 */
private module JsonFile {
  /**
   * A reader for JSON files.
   */
  class JsonFileReader extends FileSystemReadAccess, API::CallNode {
    JsonFileReader() {
      this = API::moduleImport("jsonfile").getMember(["readFile", "readFileSync"]).getACall()
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

    override DataFlow::Node getADataNode() { result = this.trackRead().getAnImmediateUse() }

    private API::Node trackRead() {
      this.getCalleeName() = "readFile" and
      (
        result = this.getParameter([1 .. 2]).getParameter(1)
        or
        not exists(this.getCallback([1 .. 2])) and result = this.getReturn().getPromised()
      )
      or
      this.getCalleeName() = "readFileSync" and
      result = this.getReturn()
    }
  }

  /** DEPRECATED: Alias for JsonFileReader */
  deprecated class JSONFileReader = JsonFileReader;

  /**
   * A writer for JSON files.
   */
  class JsonFileWriter extends FileSystemWriteAccess, DataFlow::CallNode {
    JsonFileWriter() {
      this =
        DataFlow::moduleMember("jsonfile", any(string s | s = "writeFile" or s = "writeFileSync"))
            .getACall()
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

    override DataFlow::Node getADataNode() { result = this.getArgument(1) }
  }

  /** DEPRECATED: Alias for JsonFileWriter */
  deprecated class JSONFileWriter = JsonFileWriter;
}

/**
 * A call to the library `load-json-file`.
 */
private class LoadJsonFile extends FileSystemReadAccess, API::CallNode {
  LoadJsonFile() {
    this = API::moduleImport("load-json-file").getACall()
    or
    this = API::moduleImport("load-json-file").getMember("sync").getACall()
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

  override DataFlow::Node getADataNode() { result = this.trackRead().getAnImmediateUse() }

  private API::Node trackRead() {
    this.getCalleeName() = "sync" and result = this.getReturn()
    or
    not this.getCalleeName() = "sync" and result = this.getReturn().getPromised()
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

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

  override DataFlow::Node getADataNode() { result = this.getArgument(1) }
}

/**
 * A call to the library `walkdir`.
 */
private class WalkDir extends FileNameProducer, FileSystemAccess, API::CallNode {
  WalkDir() {
    this = API::moduleImport("walkdir").getACall()
    or
    this = API::moduleImport("walkdir").getMember("sync").getACall()
    or
    this = API::moduleImport("walkdir").getMember("async").getACall()
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

  override DataFlow::Node getAFileName() { result = this.trackFileSource().getAnImmediateUse() }

  private API::Node trackFileSource() {
    not this.getCalleeName() = ["sync", "async"] and
    (
      result = this.getParameter(this.getNumArgument() - 1).getParameter(0)
      or
      result = this.getReturn().getMember(EventEmitter::on()).getParameter(1).getParameter(0)
    )
    or
    this.getCalleeName() = "sync" and result = this.getReturn()
    or
    this.getCalleeName() = "async" and result = this.getReturn().getPromised()
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
    result = this.getArgument(1)
    or
    this.getCalleeName() = "mapping" and
    (
      result = this.getAnArgument() and
      not exists(result.getALocalSource().getAPropertyWrite("src"))
      or
      result = this.getAnArgument().getALocalSource().getAPropertyWrite("src").getRhs()
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
          ["readFiles", "readFilesStream", "files", "promiseFiles", "subdirs", "paths"]).getACall()
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

  override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArgument) }
}

/**
 * A call to the library [`chokidar`](https://www.npmjs.com/package/chokidar), where a call to `on` receives file names.
 */
class Chokidar extends FileNameProducer, FileSystemAccess, API::CallNode {
  Chokidar() { this = API::moduleImport("chokidar").getMember("watch").getACall() }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

  override DataFlow::Node getAFileName() {
    exists(DataFlow::CallNode onCall, int pathIndex |
      onCall = this.getAChainedMethodCall("on") and
      if onCall.getArgument(0).mayHaveStringValue("all") then pathIndex = 1 else pathIndex = 0
    |
      result = onCall.getCallback(1).getParameter(pathIndex)
    )
  }
}

/**
 * A call to the [`mkdirp`](https://www.npmjs.com/package/mkdirp) library.
 */
private class Mkdirp extends FileSystemAccess, API::CallNode {
  Mkdirp() {
    this = API::moduleImport("mkdirp").getACall()
    or
    this = API::moduleImport("mkdirp").getMember("sync").getACall()
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
}
