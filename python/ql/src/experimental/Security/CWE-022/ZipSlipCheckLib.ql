private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources

abstract class CopyZipFile extends DataFlow::Node { }

abstract class OpenZipFile extends DataFlow::CallCfgNode { }

private class CopyZip extends CopyZipFile {
    CopyZip() {
       exists(DataFlow::CallCfgNode call, DataFlow::Node pred |
          call = API::moduleImport("shutil").getMember([
                                                  // these are used to copy files
                                                 "copyfile", "copy", "copy2", "copytree", "copyfileobj",
                                                  // these are used to move files
                                                 "move"])
                                             .getACall() and
         
         call.getArg(0) = pred
       )
    }

}
private class OpenZip extends OpenZipFile {
    OpenZip() {
       exists(DataFlow::CallCfgNode call |
          call = API::moduleImport("zipfile").getMember("ZipFile").getMember("open").getACall() 
       )
    } 
  
}


