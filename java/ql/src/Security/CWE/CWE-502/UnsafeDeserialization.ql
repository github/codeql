/**
 * @name Deserialization of user-controlled data
 * @description Deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-deserialization
 * @tags security
 *       external/cwe/cwe-502
 */
import java
import semmle.code.java.dataflow.FlowSources
import UnsafeDeserialization

class UnsafeDeserializationConfig extends TaintTracking::Configuration {
  UnsafeDeserializationConfig() { this = "UnsafeDeserializationConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteUserInput }
  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserializationSink }
}

from UnsafeDeserializationSink sink, RemoteUserInput source, UnsafeDeserializationConfig conf
where conf.hasFlow(source, sink)
select sink.getMethodAccess(), "Unsafe deserialization of $@.", source, "user input"
