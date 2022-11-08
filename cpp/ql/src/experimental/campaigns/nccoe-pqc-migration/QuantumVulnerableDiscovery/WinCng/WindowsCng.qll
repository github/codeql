import cpp
import DataFlow::PathGraph
import semmle.code.cpp.dataflow.TaintTracking

/**
 * Base abstract class to be extended to allow indirect extensions of vulnerable sinks.
 */
abstract class BCryptOpenAlgorithmProviderSink extends DataFlow::Node { }

/**
 * Base abstract class to be extended to allow indirect extensions of vulnerable sources.
 */
abstract class BCryptOpenAlgorithmProviderSource extends DataFlow::Node { }

// ------------------ Helper Predicates ----------------------
/**
 * Holds if there is a call with global name`funcGlobalName` with argument `arg` of that call
 * at argument index `index`.
 */
predicate isCallArgument(string funcGlobalName, Expr arg, int index) {
  exists(Call c | c.getArgument(index) = arg and c.getTarget().hasGlobalName(funcGlobalName))
}

/**
 * Holdes if StringLiteral `lit` has a string value indicative of a post quantum crypto
 * vulnerable algorithm identifier.
 */
predicate vulnProviderLiteral(StringLiteral lit) {
  exists(string s | s = lit.getValue() |
    s in ["DH", "DSA", "ECDSA", "ECDH"] or
    s.matches("ECDH%") or
    s.matches("RSA%")
  )
}

//TODO: Verify NCrypt calls (parameters) & find all other APIs that should be included (i.e. decrypt, etc.)
// ------------------ Default SINKS ----------------------
/**
 * Argument at index 0 of call to BCryptSignHash:
 *     [in]           BCRYPT_KEY_HANDLE hKey,
 */
class BCryptSignHashArgumentSink extends BCryptOpenAlgorithmProviderSink {
  int index;
  string funcName;

  BCryptSignHashArgumentSink() {
    index = 0 and
    funcName = "BCryptSignHash" and
    isCallArgument(funcName, this.asExpr(), index)
  }
}

/**
 * Argument at index 0 of call to BCryptGenerateKeyPair:
 *    [in, out] BCRYPT_ALG_HANDLE hAlgorithm,
 */
class BCryptGenerateKeyPair extends BCryptOpenAlgorithmProviderSink {
  int index;
  string funcName;

  BCryptGenerateKeyPair() {
    index = 0 and
    funcName = "BCryptGenerateKeyPair" and
    isCallArgument(funcName, this.asExpr(), index)
  }
}

/**
 * Argument at index 0 of call to BCryptEncrypt:
 *     [in, out]           BCRYPT_KEY_HANDLE hKey,
 */
class BCryptEncryptArgumentSink extends BCryptOpenAlgorithmProviderSink {
  int index;
  string funcName;

  BCryptEncryptArgumentSink() {
    index = 0 and
    funcName = "BCryptEncrypt" and
    isCallArgument(funcName, this.asExpr(), index)
  }
}

/**
 * Argument at index 0 of call to NCryptEncrypt:
 *     [in]           NCRYPT_KEY_HANDLE hKey,
 */
class NCryptEncryptArgumentSink extends BCryptOpenAlgorithmProviderSink {
 int index;
 string funcName;

 NCryptEncryptArgumentSink() {
   index = 0 and
   funcName = "NCryptEncrypt" and
   isCallArgument(funcName, this.asExpr(), index)
 }
}

// ----------------- Default SOURCES -----------------------
/**
 * A string identifier of known PQC vulnerable algorithms.
 */
class BCryptOpenAlgorithmProviderPqcVulnerableAlgorithmsSource extends BCryptOpenAlgorithmProviderSource {
  BCryptOpenAlgorithmProviderPqcVulnerableAlgorithmsSource() { vulnProviderLiteral(this.asExpr()) }
}
