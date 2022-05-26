/** Provides classes and predicates to reason about cleartext storage in serializable classes. */

import java
import semmle.code.java.frameworks.JAXB
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.CleartextStorageQuery
import semmle.code.java.security.CleartextStoragePropertiesQuery

private class ClassCleartextStorageSink extends CleartextStorageSink {
  ClassCleartextStorageSink() { this.asExpr() = getInstanceInput(_, _) }
}

/** The instantiation of a storable class, which can be stored to disk. */
abstract class ClassStore extends Storable, ClassInstanceExpr {
  /** Gets an input, for example `input` in `instance.password = input`. */
  override Expr getAnInput() {
    exists(ClassStoreFlowConfig conf, DataFlow::Node instance |
      conf.hasFlow(DataFlow::exprNode(this), instance) and
      result = getInstanceInput(instance, this.getConstructor().getDeclaringType())
    )
  }
}

/**
 * The instantiation of a serializable class, which can be stored to disk.
 *
 * Only includes tainted instances where data from a `SensitiveSource` may flow
 * to an input of the `Serializable`.
 */
private class Serializable extends ClassStore {
  Serializable() {
    this.getConstructor().getDeclaringType().getAnAncestor() instanceof TypeSerializable and
    // `Properties` are `Serializable`, but handled elsewhere.
    not this instanceof Properties and
    // restrict attention to tainted instances
    exists(SensitiveSource data |
      data.flowsTo(getInstanceInput(_, this.getConstructor().getDeclaringType()))
    )
  }

  /** Gets a store, for example `outputStream.writeObject(instance)`. */
  override Expr getAStore() {
    exists(ClassStoreFlowConfig conf, DataFlow::Node n |
      serializableStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

/** The instantiation of a marshallable class, which can be stored to disk as XML. */
private class Marshallable extends ClassStore {
  Marshallable() { this.getConstructor().getDeclaringType() instanceof JAXBElement }

  /** Gets a store, for example `marshaller.marshal(instance)`. */
  override Expr getAStore() {
    exists(ClassStoreFlowConfig conf, DataFlow::Node n |
      marshallableStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

/** Gets an input, for example `input` in `instance.password = input`. */
private Expr getInstanceInput(DataFlow::Node instance, RefType t) {
  exists(AssignExpr a, FieldAccess fa |
    instance = DataFlow::getFieldQualifier(fa) and
    a.getDest() = fa and
    a.getSource() = result and
    fa.getField().getDeclaringType() = t
  |
    t.getASourceSupertype*() instanceof TypeSerializable or
    t instanceof JAXBElement
  )
}

private class ClassStoreFlowConfig extends DataFlow::Configuration {
  ClassStoreFlowConfig() { this = "ClassStoreFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ClassStore }

  override predicate isSink(DataFlow::Node sink) {
    exists(getInstanceInput(sink, _)) or
    serializableStore(sink, _) or
    marshallableStore(sink, _)
  }

  override int fieldFlowBranchLimit() { result = 1 }
}

private predicate serializableStore(DataFlow::Node instance, Expr store) {
  exists(MethodAccess m |
    store = m and
    m.getMethod() instanceof WriteObjectMethod and
    instance.asExpr() = m.getArgument(0)
  )
}

private predicate marshallableStore(DataFlow::Node instance, Expr store) {
  exists(MethodAccess m |
    store = m and
    m.getMethod() instanceof JAXBMarshalMethod and
    instance.asExpr() = m.getArgument(0)
  )
}
