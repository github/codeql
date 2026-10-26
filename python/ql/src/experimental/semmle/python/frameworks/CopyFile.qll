private import python
private import experimental.semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

private module CopyFileImpl {
  /**
   * The `shutil` module provides methods to copy or move files.
   * See:
   * - https://docs.python.org/3/library/shutil.html#shutil.copyfile
   * - https://docs.python.org/3/library/shutil.html#shutil.copy
   * - https://docs.python.org/3/library/shutil.html#shutil.copy2
   * - https://docs.python.org/3/library/shutil.html#shutil.copytree
   * - https://docs.python.org/3/library/shutil.html#shutil.move
   */
  private class CopyFiles extends DataFlow::CallCfgNode, CopyFile::Range {
    CopyFiles() {
      this =
        API::moduleImport("shutil")
            .getMember(["copyfile", "copy", "copy2", "copytree", "move"])
            .getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("src")]
    }

    override DataFlow::Node getfsrcArgument() { none() }
  }

  // TODO: once we have flow summaries, model `shutil.copyfileobj` which copies the content between its' file-like arguments.
  // See https://docs.python.org/3/library/shutil.html#shutil.copyfileobj
  private class CopyFileobj extends DataFlow::CallCfgNode, CopyFile::Range {
    CopyFileobj() { this = API::moduleImport("shutil").getMember("copyfileobj").getACall() }

    override DataFlow::Node getfsrcArgument() {
      result in [this.getArg(0), this.getArgByName("fsrc")]
    }

    override DataFlow::Node getAPathArgument() { none() }
  }
}
