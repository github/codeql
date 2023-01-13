private import java
private import extraction.Exclusions as Exclusions
private import semmle.code.java.dataflow.DataFlow::DataFlow as DataFlow

/**
 * Holds if the flow from `source` to `sink` should be excluded from the results of an end-to-end
 * evaluation query.
 */
pragma[inline]
predicate isFlowExcluded(DataFlow::Node source, DataFlow::Node sink) {
  Exclusions::isFileExcluded([source.getLocation().getFile(), sink.getLocation().getFile()])
}
