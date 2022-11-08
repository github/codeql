/**
 * @id cpp/nist-pqc/pqc-vulnerable-algorithms-cng
 * @name Usage of PQC vulnerable algorithms
 * @description Usage of PQC vulnerable algorithms.
 * @microsoft.severity important
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       pqc
 *       nist
 */

import cpp
import DataFlow::PathGraph
import WindowsCng
import WindowsCngPQCVAsymmetricKeyUsage

// CNG-specific DataFlow configuration
class BCryptConfiguration extends DataFlow::Configuration {
	BCryptConfiguration() {
		this = "BCryptConfiguration"
	}
	override predicate isSource(DataFlow::Node source) {
        source instanceof BCryptOpenAlgorithmProviderSource
	}
 
	override predicate isSink(DataFlow::Node sink) { 
        sink instanceof BCryptOpenAlgorithmProviderSink 
    }

    override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
        isWindowsCngAsymmetricKeyAdditionalTaintStep( node1, node2)
    }
}

from BCryptConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "PQC vulnerable algorithm $@ in use has been detected.",
    source.getNode().asExpr(), source.getNode().asExpr().toString()