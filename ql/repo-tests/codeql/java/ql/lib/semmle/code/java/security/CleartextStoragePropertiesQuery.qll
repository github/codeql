/** Provides classes and predicates to reason about cleartext storage in Properties files. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Properties
import semmle.code.java.security.CleartextStorageQuery

private class PropertiesCleartextStorageSink extends CleartextStorageSink {
  PropertiesCleartextStorageSink() {
    exists(MethodAccess m |
      m.getMethod() instanceof PropertiesSetPropertyMethod and this.asExpr() = m.getArgument(1)
    )
  }
}

/** The instantiation of a `Properties` object, which can be stored to disk. */
class Properties extends Storable, ClassInstanceExpr {
  Properties() { this.getConstructor().getDeclaringType() instanceof TypeProperty }

  /** Gets an input, for example `input` in `props.setProperty("password", input);`. */
  override Expr getAnInput() {
    exists(PropertiesFlowConfig conf, DataFlow::Node n |
      propertiesInput(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }

  /** Gets a store, for example `props.store(outputStream, "...")`. */
  override Expr getAStore() {
    exists(PropertiesFlowConfig conf, DataFlow::Node n |
      propertiesStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

private predicate propertiesInput(DataFlow::Node prop, Expr input) {
  exists(MethodAccess m |
    m.getMethod() instanceof PropertiesSetPropertyMethod and
    input = m.getArgument(1) and
    prop.asExpr() = m.getQualifier()
  )
}

private predicate propertiesStore(DataFlow::Node prop, Expr store) {
  exists(MethodAccess m |
    m.getMethod() instanceof PropertiesStoreMethod and
    store = m and
    prop.asExpr() = m.getQualifier()
  )
}

private class PropertiesFlowConfig extends DataFlow::Configuration {
  PropertiesFlowConfig() { this = "PropertiesFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof Properties }

  override predicate isSink(DataFlow::Node sink) {
    propertiesInput(sink, _) or
    propertiesStore(sink, _)
  }
}
