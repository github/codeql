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

/** Data flow for `System.Collections.IDictionary`. */
private class SystemCollectionsIDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;IDictionary;true;Add;(System.Object,System.Object);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections;IDictionary;true;Add;(System.Object,System.Object);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections;IDictionary;true;get_Item;(System.Object);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.Collections;IDictionary;true;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections;IDictionary;true;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections;IDictionary;true;set_Item;(System.Object,System.Object);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections;IDictionary;true;set_Item;(System.Object,System.Object);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
      ]
  }
}

/** Data flow for `System.Collections.Hashtable`. */
private class SystemCollectionsHashtableFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;Hashtable;false;Clone;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Collections.IEqualityComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Collections.IEqualityComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Collections.IHashCodeProvider,System.Collections.IComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Collections.IHashCodeProvider,System.Collections.IComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single,System.Collections.IEqualityComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single,System.Collections.IEqualityComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single,System.Collections.IHashCodeProvider,System.Collections.IComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single,System.Collections.IHashCodeProvider,System.Collections.IComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.SortedList`. */
private class SystemCollectionsSortedListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;SortedList;false;Clone;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;SortedList;false;GetByIndex;(System.Int32);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.Collections;SortedList;false;GetValueList;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary,System.Collections.IComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary,System.Collections.IComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
      ]
  }
}
