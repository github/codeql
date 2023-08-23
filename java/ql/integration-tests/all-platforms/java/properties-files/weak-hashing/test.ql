import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.WeakHashingAlgorithmPropertyQuery

query predicate weakAlgorithmUse(DataFlow::Node sink) {
  exists(DataFlow::Node source | InsecureAlgorithmPropertyFlow::flow(source, sink))
}
