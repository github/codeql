/**
 * @name Arbitrary file write during archive extraction ("Zip Slip")
 * @description Extracting files from a malicious archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
 * @kind path-problem
 * @id py/zipslip
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import ZipSlipCheckLib
import DataFlow::PathGraph

/**
 * Taint-tracking configuration tracing flow from opening a zipfile to copy to another place.
 */

class ZipSlipConfig extends TaintTracking::Configuration {
  ZipSlipConfig() { this = "ZipSlipConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof OpenZipFile
  }

  override predicate isSink(DataFlow::Node sink) { 
    sink instanceof CopyZipFile 
  }
  
  override predicate isSanitizer(DataFlow::Node node) {
     exists(Subscript ss |
      ss.getObject().(Call).getFunc().(Attribute).getName().matches("%path") and
      ss = node.asExpr()
    )
  }
}
from ZipSlipConfig config, DataFlow::PathNode source,
  DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Extraction of zipfile from $@", source.getNode(),
  "a potentially untrusted source"

