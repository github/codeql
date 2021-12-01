/**
 * Provides public classes for MyBatis SQL injection detection.
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.MyBatis
import semmle.code.java.frameworks.Properties

private predicate propertiesKey(DataFlow::Node prop, string key) {
  exists(MethodAccess m |
    m.getMethod() instanceof PropertiesSetPropertyMethod and
    key = m.getArgument(0).(CompileTimeConstantExpr).getStringValue() and
    prop.asExpr() = m.getQualifier()
  )
}

/** A data flow configuration tracing flow from ibatis obtaining the variable configuration object to setting the value of the variable. */
private class PropertiesFlowConfig extends DataFlow2::Configuration {
  PropertiesFlowConfig() { this = "PropertiesFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma | ma.getMethod() instanceof IbatisConfigurationGetVariablesMethod |
      src.asExpr() = ma
    )
  }

  override predicate isSink(DataFlow::Node sink) { propertiesKey(sink, _) }
}

/** Get the key value of Mybatis Configuration Variable. */
string getAnMybatisConfigurationVariableKey() {
  exists(PropertiesFlowConfig conf, DataFlow::Node n |
    propertiesKey(n, result) and
    conf.hasFlowTo(n)
  )
}

/** A reference type that extends a parameterization of `java.util.List`. */
class ListType extends RefType {
  ListType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "List")
  }
}
