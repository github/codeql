/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe zip and tar archive extraction, as well as extension points
 * for adding your own.
 */

import javascript

module ZipSlip {
  import TaintedPathCustomizations::TaintedPath as TaintedPath

  /**
   * A data flow source for unsafe archive extraction.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow label denoting the type of value for which this is a source. */
    TaintedPath::FlowState::PosixPath getAFlowState() { result.isRelative() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated TaintedPath::Label::PosixPath getAFlowLabel() {
      result = this.getAFlowState().toFlowLabel()
    }
  }

  /**
   * A data flow sink for unsafe archive extraction.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a flow label denoting the type of value for which this is a sink. */
    TaintedPath::FlowState::PosixPath getAFlowState() { any() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated TaintedPath::Label::PosixPath getAFlowLabel() {
      result = this.getAFlowState().toFlowLabel()
    }
  }

  /**
   * Gets a node that can be a parsed archive.
   */
  private DataFlow::SourceNode parsedArchive() {
    result = DataFlow::moduleImport("unzipper").getAMemberCall("Parse")
    or
    result = DataFlow::moduleImport("unzip").getAMemberCall("Parse")
    or
    result = DataFlow::moduleImport("tar-stream").getAMemberCall("extract")
    or
    // `streamProducer.pipe(unzip.Parse())` is a typical (but not
    // universal) pattern when using nodejs streams, whose return
    // value is the parsed stream.
    exists(DataFlow::MethodCallNode pipe |
      pipe = result and
      pipe.getMethodName() = "pipe" and
      parsedArchive().flowsTo(pipe.getArgument(0))
    )
  }

  /** Gets a property that is used to get a filename part of an archive entry. */
  private string getAFilenameProperty() {
    result = "path" // Used by library 'unzip'.
    or
    result = "name" // Used by library 'tar-stream'.
    or
    result = "linkname" // linked file name, used by 'tar-stream'.
  }

  /** An archive entry path access, as a source for unsafe archive extraction. */
  class UnzipEntrySource extends Source {
    // For example, in
    // ```javascript
    // const unzip = require('unzip');
    //
    // fs.createReadStream('archive.zip')
    //   .pipe(unzip.Parse())
    //   .on('entry', entry => {
    //      const path = entry.path;
    //   });
    // ```
    // there is an `UnzipEntrySource` node corresponding to
    // the expression `entry.path`.
    UnzipEntrySource() {
      exists(DataFlow::CallNode cn |
        cn = parsedArchive().getAMemberCall(EventEmitter::on()) and
        cn.getArgument(0).mayHaveStringValue("entry") and
        this = cn.getCallback(1).getParameter(0).getAPropertyRead(getAFilenameProperty())
      )
    }
  }

  /** An archive entry path access using the `adm-zip` package. */
  class AdmZipEntrySource extends Source {
    AdmZipEntrySource() {
      exists(DataFlow::SourceNode admZip, DataFlow::SourceNode entry |
        admZip = DataFlow::moduleImport("adm-zip").getAnInstantiation() and
        this = entry.getAPropertyRead("entryName")
      |
        entry = admZip.getAMethodCall("getEntry")
        or
        exists(DataFlow::SourceNode entries | entries = admZip.getAMethodCall("getEntries") |
          entry = entries.getAPropertyRead()
          or
          exists(string map | map = "map" or map = "forEach" |
            entry = entries.getAMethodCall(map).getCallback(0).getParameter(0)
          )
        )
      )
    }
  }

  private import semmle.javascript.DynamicPropertyAccess as DynamicPropertyAccess

  /** A object key in the JSZip files object */
  class JSZipFilesSource extends Source instanceof DynamicPropertyAccess::EnumeratedPropName {
    JSZipFilesSource() {
      super.getSourceObject() =
        API::moduleImport("jszip").getInstance().getMember("files").asSource()
    }
  }

  /** A relative path from iterating the files in the JSZip object */
  class JSZipFileSource extends Source {
    JSZipFileSource() {
      this =
        API::moduleImport("jszip")
            .getInstance()
            .getMember(["forEach", "filter"])
            .getParameter(0)
            .getParameter(0)
            .asSource()
    }
  }

  /** A call to `fs.createWriteStream`, as a sink for unsafe archive extraction. */
  class CreateWriteStreamSink extends Sink {
    CreateWriteStreamSink() {
      // This is not covered by `FileSystemWriteSink`, because it is
      // required that a write actually takes place to the stream.
      // However, we want to consider even the bare `createWriteStream`
      // to be a zipslip vulnerability since it may truncate an
      // existing file.
      this = NodeJSLib::FS::moduleMember("createWriteStream").getACall().getArgument(0)
      or
      // Not covered by `FileSystemWriteSink` because a later call
      // to `fs.write` is required for a write to take place.
      exists(DataFlow::CallNode call | this = call.getArgument(0) |
        call = NodeJSLib::FS::moduleMember(["open", "openSync"]).getACall() and
        call.getArgument(1).getStringValue().regexpMatch("(?i)w.{0,2}")
      )
    }
  }

  /** A file path of a file write, as a sink for unsafe archive extraction. */
  class FileSystemWriteSink extends Sink {
    FileSystemWriteSink() { exists(FileSystemWriteAccess fsw | fsw.getAPathArgument() = this) }
  }
}
