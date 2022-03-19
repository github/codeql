private import javascript
private import extraction.Exclusions as Exclusions

/**
 * Holds if the flow from `source` to `sink` should be excluded from the results of an end-to-end
 * evaluation query.
 */
pragma[inline]
predicate isFlowExcluded(DataFlow::Node source, DataFlow::Node sink) {
  Exclusions::isFileExcluded([source.getFile(), sink.getFile()])
}
