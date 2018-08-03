/** Provides definitions related to the namespace `System.Collections`. */
import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Collections` namespace. */
class SystemCollectionsNamespace extends Namespace {
  SystemCollectionsNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Collections")
  }
}

/** DEPRECATED. Gets the `System.Collections` namespace. */
deprecated
SystemCollectionsNamespace getSystemCollectionsNamespace() { any() }

/** An interface in the `System.Collections` namespace. */
class SystemCollectionsInterface extends Interface {
  SystemCollectionsInterface() {
    this.getNamespace() instanceof SystemCollectionsNamespace
  }
}

/** The `System.Collections.IComparer` interface. */
class SystemCollectionsIComparerInterface extends SystemCollectionsInterface {
  SystemCollectionsIComparerInterface() {
    this.hasName("IComparer")
  }

  /** Gets the `Compare(object, object)` method. */
  Method getCompareMethod() {
    result.getDeclaringType() = this
    and
    result.hasName("Compare")
    and
    result.getNumberOfParameters() = 2
    and
    result.getParameter(0).getType() instanceof ObjectType
    and
    result.getParameter(1).getType() instanceof ObjectType
    and
    result.getReturnType() instanceof IntType
  }
}

/** DEPRECATED. Gets the `System.Collections.IComparer` interface. */
deprecated
SystemCollectionsIComparerInterface getSystemCollectionsIComparerInterface() { any() }

/** The `System.Collections.IEnumerable` interface. */
class SystemCollectionsIEnumerableInterface extends SystemCollectionsInterface {
  SystemCollectionsIEnumerableInterface() {
    this.hasName("IEnumerable")
  }
}

/** DEPRECATED. Gets the `System.Collections.IEnumerable` interface. */
deprecated
SystemCollectionsIEnumerableInterface getSystemCollectionsIEnumerableInterface() { any() }

/** The `System.Collections.IEnumerator` interface. */
class SystemCollectionsIEnumeratorInterface extends SystemCollectionsInterface {
  SystemCollectionsIEnumeratorInterface() {
    this.hasName("IEnumerator")
  }

  /** Gets the `Current` property. */
  Property getCurrentProperty() {
    result.getDeclaringType() = this
    and
    result.hasName("Current")
    and
    result.getType() instanceof ObjectType
  }
}

/** DEPRECATED. Gets the `System.Collections.IEnumerator` interface. */
deprecated
SystemCollectionsIEnumeratorInterface getSystemCollectionsIEnumeratorInterface() { any() }

/** The `System.Collections.ICollection` interface. */
class SystemCollectionsICollectionInterface extends SystemCollectionsInterface {
  SystemCollectionsICollectionInterface() {
    this.hasName("ICollection")
  }
}
