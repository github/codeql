/**
 * Provides classes and predicates for reasoning about instances of
 * `java.util.Map` and their methods.
 */

import java
import Collections

/** A reference type that extends a parameterization of `java.util.Map`. */
class MapType extends RefType {
  MapType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "Map")
  }

  /** Gets the type of keys stored in this map. */
  RefType getKeyType() {
    exists(GenericInterface map | map.hasQualifiedName("java.util", "Map") |
      indirectlyInstantiates(this, map, 0, result)
    )
  }

  /** Gets the type of values stored in this map. */
  RefType getValueType() {
    exists(GenericInterface map | map.hasQualifiedName("java.util", "Map") |
      indirectlyInstantiates(this, map, 1, result)
    )
  }
}

/** A method declared in a map type. */
class MapMethod extends Method {
  MapMethod() { this.getDeclaringType() instanceof MapType }

  /** Gets the type of keys of the map to which this method belongs. */
  RefType getReceiverKeyType() { result = this.getDeclaringType().(MapType).getKeyType() }

  /** Gets the type of values of the map to which this method belongs. */
  RefType getReceiverValueType() { result = this.getDeclaringType().(MapType).getValueType() }
}

/** A method that mutates the map it belongs to. */
class MapMutator extends MapMethod {
  MapMutator() { this.getName().regexpMatch("(put.*|remove|clear)") }
}

/** The `size` method of `java.util.Map`. */
class MapSizeMethod extends MapMethod {
  MapSizeMethod() { this.hasName("size") and this.hasNoParameters() }
}

/** A method call that mutates a map. */
class MapMutation extends MethodAccess {
  MapMutation() { this.getMethod() instanceof MapMutator }

  /** Holds if the result of this call is not immediately discarded. */
  predicate resultIsChecked() { not this.getParent() instanceof ExprStmt }
}

/** A method that queries the contents of the map it belongs to without mutating it. */
class MapQueryMethod extends MapMethod {
  MapQueryMethod() {
    this.getName().regexpMatch("get|containsKey|containsValue|entrySet|keySet|values|isEmpty|size")
  }
}

/** A `new` expression that allocates a fresh, empty map. */
class FreshMap extends ClassInstanceExpr {
  FreshMap() {
    this.getConstructedType() instanceof MapType and
    this.getNumArgument() = 0 and
    not exists(this.getAnonymousClass())
  }
}

/**
 * A call to `Map.put(key, value)`.
 */
class MapPutCall extends MethodAccess {
  MapPutCall() { getCallee().(MapMethod).hasName("put") }

  /** Gets the key argument of this call. */
  Expr getKey() { result = getArgument(0) }

  /** Gets the value argument of this call. */
  Expr getValue() { result = getArgument(1) }
}
