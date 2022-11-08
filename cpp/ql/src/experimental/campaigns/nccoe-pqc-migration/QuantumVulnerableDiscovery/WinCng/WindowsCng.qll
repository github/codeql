import cpp
import DataFlow::PathGraph
import semmle.code.cpp.dataflow.TaintTracking

abstract class BCryptOpenAlgorithmProviderSink extends DataFlow::Node { }

abstract class BCryptOpenAlgorithmProviderSource extends DataFlow::Node { }

predicate isCallArgument(string funcGlobalName, Expr arg, int index) {
  exists(Call c | c.getArgument(index) = arg and c.getTarget().hasGlobalName(funcGlobalName))
}

//TODO: Verify NCrypt calls (parameters) & find all other APIs that should be included (i.e. decrypt, etc.)
// ------------------ SINKS ----------------------
class BCryptSignHashArgumentSink extends BCryptOpenAlgorithmProviderSink {
  BCryptSignHashArgumentSink() { isCallArgument("BCryptSignHash", this.asExpr(), 0) }
}

class BCryptEncryptArgumentSink extends BCryptOpenAlgorithmProviderSink {
  BCryptEncryptArgumentSink() { isCallArgument("BCryptEncrypt", this.asExpr(), 0) }
}

// ----------------- SOURCES -----------------------
predicate providerString(StringLiteral lit) {
  exists(string s | s = lit.getValue() |
    s in ["DH", "DSA", "ECDSA", "ECDH"] or
    s.matches("ECDH%") or
    s.matches("RSA%")
  )
}

class BCryptOpenAlgorithmProviderPqcVulnerableAlgorithmsSource extends BCryptOpenAlgorithmProviderSource {
  BCryptOpenAlgorithmProviderPqcVulnerableAlgorithmsSource() { providerString(this.asExpr()) }
}
