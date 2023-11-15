import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.MaybeBrokenCryptoAlgorithmQuery

query predicate weakAlgorithmUse(DataFlow::Node sink) {
  exists(DataFlow::Node source | InsecureCryptoFlow::flow(source, sink))
}
