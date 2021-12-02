/**
 * Provides classes modeling security-relevant aspects of the file system access libraries.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for Python's file-system libraries.
 */
private module File {
  /**
   * A call to the `builtins.open` function.
   *
   * See https://docs.python.org/3/library/functions.html#open
   */
  private class BuiltinOpenCall extends DataFlow::CallCfgNode, FileOpen::Range {
    BuiltinOpenCall() { this = API::builtin("open").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("file")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `io.open` function.
   *
   * See https://docs.python.org/3/library/io.html#io.open
   */
  private class IoOpenCall extends DataFlow::CallCfgNode, FileOpen::Range {
    IoOpenCall() { this = API::moduleImport("io").getMember("open").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("file")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `pathlib.Path` function.
   *
   * See https://docs.python.org/3/library/pathlib.html#pathlib.Path
   */
  private class PathlibPathCall extends DataFlow::CallCfgNode, FileOpen::Range {
    PathlibPathCall() { this = API::moduleImport("pathlib").getMember("Path").getACall() }

    override DataFlow::Node getAPathArgument() { result = this.getArg(0) }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `os.open` function.
   *
   * See https://docs.python.org/3/library/os.html#os.open
   */
  private class OsOpenCall extends DataFlow::CallCfgNode, FileOpen::Range {
    OsOpenCall() { this = API::moduleImport("os").getMember("open").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `os.listdir` function.
   *
   * See https://docs.python.org/3/library/os.html#os.listdir
   */
  private class OsListDirCall extends DataFlow::CallCfgNode, FileOpen::Range {
    OsListDirCall() { this = API::moduleImport("os").getMember("listdir").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `os.scandir` function.
   *
   * See https://docs.python.org/3/library/os.html#os.scandir
   */
  private class OsScanDirCall extends DataFlow::CallCfgNode, FileOpen::Range {
    OsScanDirCall() { this = API::moduleImport("os").getMember("scandir").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `flask.send_file` function.
   *
   * See https://flask.palletsprojects.com/en/2.0.x/api/#flask.send_file
   */
  private class FlaskSendFileCall extends DataFlow::CallCfgNode, FileOpen::Range {
    FlaskSendFileCall() {
      this = API::moduleImport("flask").getMember("send_file").getACall() or
      this = API::moduleImport("flask").getMember("helpers").getMember("send_file").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName(["filename_or_fp", "path_or_file"])]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `flask.send_from_directory` function.
   *
   * See https://flask.palletsprojects.com/en/2.0.x/api/#flask.send_from_directory
   */
  private class FlaskSendFromDirectoryCall extends DataFlow::CallCfgNode, FileOpen::Range {
    FlaskSendFromDirectoryCall() {
      this = API::moduleImport("flask").getMember("send_from_directory").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(1), this.getArgByName(["filename", "path"])]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `fastapi.responses.FileResponse` function.
   */
  private class FastAPIFileResponseCall extends DataFlow::CallCfgNode, FileOpen::Range {
    FastAPIFileResponseCall() {
      this =
        API::moduleImport("fastapi").getMember("responses").getMember("FileResponse").getACall() or
      this =
        API::moduleImport("starlette").getMember("responses").getMember("FileResponse").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `os.remove` function.
   *
   * See https://docs.python.org/3/library/os.html#os.remove
   */
  private class OsRemoveCall extends DataFlow::CallCfgNode, FileRemove::Range {
    OsRemoveCall() { this = API::moduleImport("os").getMember("remove").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `os.removedirs` function.
   *
   * See https://docs.python.org/3/library/os.html#os.removedirs
   */
  private class OsRemoveDirsCall extends DataFlow::CallCfgNode, FileRemove::Range {
    OsRemoveDirsCall() { this = API::moduleImport("os").getMember("removedirs").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("name")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `os.rmdir` function.
   *
   * See https://docs.python.org/3/library/os.html#os.rmdir
   */
  private class OsRmdirCall extends DataFlow::CallCfgNode, FileRemove::Range {
    OsRmdirCall() { this = API::moduleImport("os").getMember("rmdir").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `os.unlink` function.
   *
   * See https://docs.python.org/3/library/os.html#os.unlink
   */
  private class OsUnlinkCall extends DataFlow::CallCfgNode, FileRemove::Range {
    OsUnlinkCall() { this = API::moduleImport("os").getMember("unlink").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }

  /**
   * A call to the `shutil.rmtree` function.
   *
   * See https://docs.python.org/3/library/shutil.html#shutil.rmtree
   */
  private class ShutilRmtreeCall extends DataFlow::CallCfgNode, FileRemove::Range {
    ShutilRmtreeCall() { this = API::moduleImport("shutil").getMember("rmtree").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override DataFlow::CallCfgNode getCall() { result = this }
  }
}
