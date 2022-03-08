import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

class ZipSlipConfig extends TaintTracking::Configuration {
  ZipSlipConfig() { this = "ZipSlipConfig" }

  override predicate isSource(DataFlow::Node source) { 
    source = API::moduleImport("zipfile").getMember("ZipFile").getACall() or 
    source = API::moduleImport("tarfile").getMember("open").getACall() or 
    source = API::moduleImport("tarfile").getMember("TarFile").getACall() or  
    source = API::moduleImport("bz2").getMember("open").getACall() or
    source = API::moduleImport("bz2").getMember("BZ2File").getACall() or 
    source = API::moduleImport("gzip").getMember("GzipFile").getACall() or
    source = API::moduleImport("gzip").getMember("open").getACall() 
  }
  
  override predicate isSink(DataFlow::Node sink) { 
     sink = any(CopyFile copyfile).getAPathArgument()
  }
}
