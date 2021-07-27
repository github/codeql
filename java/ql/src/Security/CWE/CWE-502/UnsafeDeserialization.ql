/**
 * @name Deserialization of user-controlled data
 * @description Deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/unsafe-deserialization
 * @tags security
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.UnsafeDeserialization
import DataFlow::PathGraph

class UnsafeDeserializationConfig extends TaintTracking::Configuration {
  UnsafeDeserializationConfig() { this = "UnsafeDeserializationConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserializationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(ClassInstanceExpr cie |
      cie.getArgument(0) = pred.asExpr() and
      cie = succ.asExpr() and
      (
        cie.getConstructor().getDeclaringType() instanceof JsonIoJsonReader or
        cie.getConstructor().getDeclaringType() instanceof YamlBeansReader or
        cie.getConstructor().getDeclaringType().getASupertype*() instanceof UnsafeHessianInput or
        cie.getConstructor().getDeclaringType() instanceof BurlapInput
      )
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof BurlapInputInitMethod and
      ma.getArgument(0) = pred.asExpr() and
      ma.getQualifier() = succ.asExpr()
    )
    or
    exists(ConstructorCall cc |
      cc.getConstructedType().getASupertype*().hasQualifiedName("org.json", "JSONObject") and
      pred.asExpr() = cc.getAnArgument() and
      succ.asExpr() = cc
    )
    or
    isReflectiveClassIdentifierStep(pred, succ)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof JsonIoJsonReader and
      cie = node.asExpr() and
      exists(SafeJsonIoConfig sji | sji.hasFlowToExpr(cie.getArgument(1)))
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof JsonIoJsonToJavaMethod and
      ma.getArgument(0) = node.asExpr() and
      exists(SafeJsonIoConfig sji | sji.hasFlowToExpr(ma.getArgument(1)))
    )
    or
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof FlexjsonDeserializeMethod or
        ma.getMethod() instanceof JoddJsonParseMethod
      ) and
      node.asExpr() = ma.getAnArgument() and
      (
        ma.getArgument(1).getType() instanceof TypeClass and
        not ma.getArgument(1).getType().getName() = ["Class<Object>", "Class<?>"]
        or
        exists(
          MethodAccess dma // Specified class type
        |
          isSafeFlexjsonUseCall(dma) and
          (
            ma.getQualifier() = dma or // new flexjson.JSONDeserializer<Person>().use(null, Person.class).deserialize(json)
            ma.getQualifier().(VarAccess).getVariable().getAnAccess() = dma.getQualifier()
          )
        )
      )
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeDeserializationConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(UnsafeDeserializationSink).getMethodAccess(), source, sink,
  "Unsafe deserialization of $@.", source.getNode(), "user input"
