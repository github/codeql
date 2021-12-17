/** Provides definitions related to the namespace `System.Collections`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.Collections` namespace. */
class SystemCollectionsNamespace extends Namespace {
  SystemCollectionsNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Collections")
  }
}

/** An interface in the `System.Collections` namespace. */
class SystemCollectionsInterface extends Interface {
  SystemCollectionsInterface() { this.getNamespace() instanceof SystemCollectionsNamespace }
}

/** The `System.Collections.IComparer` interface. */
class SystemCollectionsIComparerInterface extends SystemCollectionsInterface {
  SystemCollectionsIComparerInterface() { this.hasName("IComparer") }

  /** Gets the `Compare(object, object)` method. */
  Method getCompareMethod() {
    result.getDeclaringType() = this and
    result.hasName("Compare") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(1).getType() instanceof ObjectType and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.Collections.IEnumerable` interface. */
class SystemCollectionsIEnumerableInterface extends SystemCollectionsInterface {
  SystemCollectionsIEnumerableInterface() { this.hasName("IEnumerable") }
}

/** Data flow for `System.Collections.IEnumerable`. */
private class SystemCollectionIEnumerableFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections;IEnumerable;true;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.IEnumerator.Current] of ReturnValue;value"
  }
}

/** The `System.Collections.IEnumerator` interface. */
class SystemCollectionsIEnumeratorInterface extends SystemCollectionsInterface {
  SystemCollectionsIEnumeratorInterface() { this.hasName("IEnumerator") }

  /** Gets the `Current` property. */
  Property getCurrentProperty() {
    result.getDeclaringType() = this and
    result.hasName("Current") and
    result.getType() instanceof ObjectType
  }
}

/** The `System.Collections.ICollection` interface. */
class SystemCollectionsICollectionInterface extends SystemCollectionsInterface {
  SystemCollectionsICollectionInterface() { this.hasName("ICollection") }
}

/** The `System.Collections.IList` interface. */
class SystemCollectionsIListInterface extends SystemCollectionsInterface {
  SystemCollectionsIListInterface() { this.hasName("IList") }
}

/** The `System.Collections.IDictionary` interface. */
class SystemCollectionsIDictionaryInterface extends SystemCollectionsInterface {
  SystemCollectionsIDictionaryInterface() { this.hasName("IDictionary") }
}
