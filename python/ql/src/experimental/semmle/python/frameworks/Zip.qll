private import python
private import experimental.semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

private module Zip {
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

  private class CopyFileobj extends DataFlow::CallCfgNode, CopyFile::Range {
    CopyFileobj() { this = API::moduleImport("shutil").getMember("copyfileobj").getACall() }

    override DataFlow::Node getfsrcArgument() {
      result in [this.getArg(0), this.getArgByName("fsrc")]
    }

    override DataFlow::Node getAPathArgument() { none() }
  }
}

