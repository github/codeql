/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id py/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */
import python
import semmle.python.security.SensitiveData
import semmle.python.security.Crypto

class BrokenCryptoConfiguration extends TaintTracking::Configuration {

    BrokenCryptoConfiguration() { this = "Broken crypto configuration" }

    override predicate isSource(TaintTracking::Source source) { source instanceof SensitiveDataSource }

    override predicate isSink(TaintTracking::Sink sink) {
        sink instanceof WeakCryptoSink
    }

}


from BrokenCryptoConfiguration config, SensitiveDataSource src, WeakCryptoSink sink
where config.hasFlow(src, sink)

select sink, "Sensitive data from $@ is used in a broken or weak cryptographic algorithm.", src , src.toString()
