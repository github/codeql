import semmle.code.java.dataflow.DataFlow

// GOOD - ends with "Config"
module EmptyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { none() }

  predicate isSink(DataFlow::Node sink) { none() }
}

// BAD - does not end with "Config"
module EmptyConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { none() }

  predicate isSink(DataFlow::Node sink) { none() }
}

// BAD - does not end with "Config"
module EmptyFlow implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { none() }

  predicate isSink(DataFlow::Node sink) { none() }
}
