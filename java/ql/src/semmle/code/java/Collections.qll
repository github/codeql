import java

/**
 * The type `t` is a parameterization of `g`, where the `i`-th type parameter of
 * `g` is instantiated to `a`?
 *
 * For example, `List<Integer>` parameterizes `List<T>`, instantiating its `0`-th
 * type parameter to `Integer`, while the raw type `List` also parameterizes
 * `List<T>`, instantiating the type parameter to `Object`.
 */
predicate instantiates(RefType t, GenericType g, int i, RefType arg) {
  t = g.getAParameterizedType() and exists(g.getTypeParameter(i)) and
  (
    arg = t.(ParameterizedType).getTypeArgument(i) or
    t instanceof RawType and arg instanceof TypeObject
  )
}

/**
 * Generalisation of `instantiates` that takes subtyping into account:
 *
 * - `HashSet<Integer>` indirectly instantiates `Collection` (but also `HashSet` and `Set`),
 *   with the `0`-th type parameter being `Integer`;
 * - a class `MyList extends ArrayList<Runnable>` also instantiates `Collection`
 *   (as well as `AbstractList`, `AbstractCollection` and `List`), with the `0`-th type
 *   parameter being `Runnable`;
 * - the same is true of `class MyOtherList<T> extends ArrayList<Runnable>` (note that
 *   it does _not_ instantiate the type parameter to `T`);
 * - a class `MyIntMap<V> extends HashMap<Integer, V>` instantiates `Map` (among others)
 *   with the `0`-th type parameter being `Integer` and the `1`-th type parameter being `V`.
 */
predicate indirectlyInstantiates(RefType t, GenericType g, int i, RefType arg) {
  exists(RefType tsrc | tsrc = t.getSourceDeclaration() |
    // base case: `t` directly instantiates `g`
    tsrc = g and instantiates(t, g, i, arg)
    or
    // inductive step
    exists(RefType sup, RefType suparg |
      // follow `extends`/`implements`
      (extendsReftype(tsrc, sup) or implInterface(tsrc, sup)) and
      // check whether the subtype instantiates `g`
      indirectlyInstantiates(sup, g, i, suparg)
      |
      // if `t` is itself an instantiation of `tsrc` and `sup` instantiates
      // `g` to one of the type parameters of `tsrc`, we return the corresponding
      // instantiation in `t`
      exists(int j | suparg = tsrc.(GenericType).getTypeParameter(j) |
        instantiates(t, tsrc, j, arg)
      )
      or
      // otherwise, we directly return `suparg`
      not (
        t = tsrc.(GenericType).getAParameterizedType() and
        suparg = tsrc.(GenericType).getATypeParameter()
      ) and
      arg = suparg
    )
  )
}

/** A reference type that extends a parameterization of `java.util.Collection`. */
class CollectionType extends RefType {
  CollectionType() {
    exists(ParameterizedInterface coll |
      coll.getSourceDeclaration().hasQualifiedName("java.util", "Collection")
      |
      this.hasSupertype*(coll)
    )
  }

  /** Gets the type of elements stored in this collection. */
  RefType getElementType() {
    exists(GenericInterface coll | coll.hasQualifiedName("java.util", "Collection") |
      indirectlyInstantiates(this, coll, 0, result)
    )
  }
}

/** A method declared in a collection type. */
class CollectionMethod extends Method {
  CollectionMethod() {
    this.getDeclaringType() instanceof CollectionType
  }

  /** Gets the type of elements of the collection to which this method belongs. */
  RefType getReceiverElementType() {
    result = this.getDeclaringType().(CollectionType).getElementType()
  }
}

/** The `size` method on `java.util.Collection`. */
class CollectionSizeMethod extends CollectionMethod {
  CollectionSizeMethod() {
    this.hasName("size") and this.hasNoParameters()
  }
}

/** A method that mutates the collection it belongs to. */
class CollectionMutator extends CollectionMethod {
  CollectionMutator() {
    this.getName().regexpMatch("add.*|remove.*|push|pop|clear")
  }
}

/** A method call that mutates a collection. */
class CollectionMutation extends MethodAccess {
  CollectionMutation() {
    this.getMethod() instanceof CollectionMutator
  }

  predicate resultIsChecked() {
    not this.getParent() instanceof ExprStmt
  }
}

/** A method that queries the contents of a collection without mutating it. */
class CollectionQueryMethod extends CollectionMethod {
  CollectionQueryMethod() {
    this.getName().regexpMatch("contains|containsAll|get|size|peek")
  }
}

/** A `new` expression that allocates a fresh, empty collection. */
class FreshCollection extends ClassInstanceExpr {
  FreshCollection() {
    this.getConstructedType() instanceof CollectionType and
    this.getNumArgument() = 0 and
    not exists(this.getAnonymousClass())
  }
}
