/** Provides definitions related to the namespace `System.Collections.Generic`. */

import csharp
private import semmle.code.csharp.frameworks.system.Collections

/** The `System.Collections.Generic` namespace. */
class SystemCollectionsGenericNamespace extends Namespace {
  SystemCollectionsGenericNamespace() {
    this.getParentNamespace() instanceof SystemCollectionsNamespace and
    this.hasName("Generic")
  }
}

/** An unbound generic interface in the `System.Collections.Generic` namespace. */
class SystemCollectionsGenericUnboundGenericInterface extends UnboundGenericInterface {
  SystemCollectionsGenericUnboundGenericInterface() {
    this.getNamespace() instanceof SystemCollectionsGenericNamespace
  }
}

/** An unbound generic class in the `System.Collections.Generic` namespace. */
class SystemCollectionsGenericUnboundGenericClass extends UnboundGenericClass {
  SystemCollectionsGenericUnboundGenericClass() {
    this.getNamespace() instanceof SystemCollectionsGenericNamespace
  }
}

/** An unbound generic struct in the `System.Collections.Generic` namespace. */
class SystemCollectionsGenericUnboundGenericStruct extends UnboundGenericStruct {
  SystemCollectionsGenericUnboundGenericStruct() {
    this.getNamespace() instanceof SystemCollectionsGenericNamespace
  }
}

/** The `System.Collections.Generic.IComparer<T>` interface. */
class SystemCollectionsGenericIComparerTInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIComparerTInterface() { this.hasName("IComparer<>") }

  /** Gets the `int Compare(T, T)` method. */
  Method getCompareMethod() {
    result.getDeclaringType() = this and
    result.hasName("Compare") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() = getTypeParameter(0) and
    result.getParameter(1).getType() = getTypeParameter(0) and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.Collections.Generic.IEqualityComparer<T>` interface. */
class SystemCollectionsGenericIEqualityComparerTInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIEqualityComparerTInterface() { this.hasName("IEqualityComparer<>") }

  /** Gets the `bool Equals(T, T)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() = getTypeParameter(0) and
    result.getParameter(1).getType() = getTypeParameter(0) and
    result.getReturnType() instanceof BoolType
  }
}

/** The `System.Collections.Generic.IEnumerable<T>` interface. */
class SystemCollectionsGenericIEnumerableTInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIEnumerableTInterface() {
    this.hasName("IEnumerable<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** The `System.Collections.Generic.IEnumerator<T>` interface. */
class SystemCollectionsGenericIEnumeratorInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIEnumeratorInterface() {
    this.hasName("IEnumerator<>") and
    this.getNumberOfTypeParameters() = 1
  }

  /** Gets the `Current` property. */
  Property getCurrentProperty() {
    result.getDeclaringType() = this and
    result.hasName("Current") and
    result.getType() = this.getTypeParameter(0)
  }
}

/** The `System.Collections.Generic.IList<T>` interface. */
class SystemCollectionsGenericIListTInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIListTInterface() {
    this.hasName("IList<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** The `System.Collections.Generic.List<T>` class. */
class SystemCollectionsGenericListClass extends SystemCollectionsGenericUnboundGenericClass {
  SystemCollectionsGenericListClass() {
    this.hasName("List<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** The `System.Collections.Generic.KeyValuePair<TKey, TValue>` structure. */
class SystemCollectionsGenericKeyValuePairStruct extends SystemCollectionsGenericUnboundGenericStruct {
  SystemCollectionsGenericKeyValuePairStruct() {
    this.hasName("KeyValuePair<,>") and
    this.getNumberOfTypeParameters() = 2
  }

  /** Gets the `Key` property. */
  Property getKeyProperty() {
    result.getDeclaringType() = this and
    result.hasName("Key") and
    result.getType() = this.getTypeParameter(0)
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("Value") and
    result.getType() = this.getTypeParameter(1)
  }
}

/** The `System.Collections.Generic.ICollection<>` interface. */
class SystemCollectionsGenericICollectionInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericICollectionInterface() { this.hasName("ICollection<>") }

  /** Gets the `Count` property. */
  Property getCountProperty() { result = this.getProperty("Count") }

  /** Gets the `Clear` method. */
  Method getClearMethod() { result = this.getAMethod("Clear") }

  /** Gets the `Add` method. */
  Method getAddMethod() { result = this.getAMethod("Add") }
}

/** The `System.Collections.Generic.IList<>` interface. */
class SystemCollectionsGenericIListInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIListInterface() { this.hasName("IList<>") }
}

/** The `System.Collections.Generic.IDictionary<T>` interface. */
class SystemCollectionsGenericIDictionaryInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIDictionaryInterface() {
    this.hasName("IDictionary<,>") and
    this.getNumberOfTypeParameters() = 2
  }
}
