import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking

class ZipSlipConfig extends TaintTracking::Configuration {
  ZipSlipConfig() { this = "ZipSlipConfig" }

  override predicate isSource(DataFlow::Node source) {
    (
      source =
        API::moduleImport("zipfile").getMember("ZipFile").getReturn().getMember("open").getACall() or
      source =
        API::moduleImport("zipfile")
            .getMember("ZipFile")
            .getReturn()
            .getMember("namelist")
            .getACall() or
      source = API::moduleImport("tarfile").getMember("open").getACall() or
      source = API::moduleImport("tarfile").getMember("TarFile").getACall() or
      source = API::moduleImport("bz2").getMember("open").getACall() or
      source = API::moduleImport("bz2").getMember("BZ2File").getACall() or
      source = API::moduleImport("gzip").getMember("GzipFile").getACall() or
      source = API::moduleImport("gzip").getMember("open").getACall() or
      source = API::moduleImport("lzma").getMember("open").getACall() or
      source = API::moduleImport("lzma").getMember("LZMAFile").getACall()
    ) and
    not source.getScope().getLocation().getFile().inStdlib()
  }

  override predicate isSink(DataFlow::Node sink) {
    (
      sink = any(CopyFile copyfile).getAPathArgument() or
      sink = any(CopyFile copyfile).getfsrcArgument()
    ) and
    not sink.getScope().getLocation().getFile().inStdlib()
  }
}
