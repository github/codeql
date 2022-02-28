private import python
private import experimental.semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs


private module Zip {
  private API::Node shutil() { result = API::moduleImport("shutil") }

  private class CopyFiles extends DataFlow::CallCfgNode, CopyFile::Range {
      CopyFiles() { this = shutil().getMember(["copyfile", "copy", "copy2", "copytree", "move"]).getACall() }
      override DataFlow::Node getAPathArgument() { result in [this.getArg(0), this.getArgByName("src"), this.getArg(1), this.getArgByName("dst")] } 
  }
  
  private class CopyFileobj extends DataFlow::CallCfgNode, CopyFile::Range {
      CopyFileobj() { this = shutil().getMember("copyfileobj").getACall() }
      override DataFlow::Node getAPathArgument() { result in [this.getArg(0), this.getArgByName("fsrc"), this.getArg(1), this.getArgByName("fdst")] }
  }

  private class OpenZipFile extends DataFlow::CallCfgNode, ZipFile::Range {
      OpenZipFile() {
         this = API::moduleImport("zipfile").getMember("ZipFile").getMember("open").getACall() or
         this = API::moduleImport("zipfile").getMember("ZipFile").getACall()
      } 
      override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }
}

