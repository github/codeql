import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

class ZipSlipConfig extends TaintTracking::Configuration {
  ZipSlipConfig() { this = "ZipSlipConfig" }

  override predicate isSource(DataFlow::Node source) { 
     source = API::moduleImport("zipfile").getMember("ZipFile").getACall() 
  }
  
  override predicate isSink(DataFlow::Node sink) { 
     sink = any(CopyFile copyfile).getAPathArgument()
  }
}
