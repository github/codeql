import semmle.code.java.Collections
import semmle.code.java.Maps

/**
 * Containers are an abstraction of collections and maps.
 */
class ContainerType extends RefType {
  ContainerType() {
    this instanceof CollectionType or
    this instanceof MapType
  }
}

class ContainerMutator extends Method {
  ContainerMutator() {
    this instanceof CollectionMutator or
    this instanceof MapMutator
  }
}

class ContainerMutation extends MethodCall {
  ContainerMutation() {
    this instanceof CollectionMutation or
    this instanceof MapMutation
  }

  predicate resultIsChecked() {
    this.(CollectionMutation).resultIsChecked() or
    this.(MapMutation).resultIsChecked()
  }
}

class ContainerQueryMethod extends Method {
  ContainerQueryMethod() {
    this instanceof CollectionQueryMethod or
    this instanceof MapQueryMethod
  }
}

class FreshContainer extends ClassInstanceExpr {
  FreshContainer() {
    this instanceof FreshCollection or
    this instanceof FreshMap
  }
}
