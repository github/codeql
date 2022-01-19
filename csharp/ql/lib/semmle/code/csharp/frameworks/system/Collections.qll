/** Provides definitions related to the namespace `System.Collections`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.FlowSummary

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
      "System.Collections;IEnumerable;true;GetEnumerator;();;Element of Argument[Qualifier];Property[System.Collections.IEnumerator.Current] of ReturnValue;value"
  }
}

/** Clear content for Clear methods in all subtypes of `System.Collections.IEnumerable`. */
private class SystemCollectionsIEnumerableClearFlow extends SummarizedCallable {
  SystemCollectionsIEnumerableClearFlow() {
    this.getDeclaringType().(RefType).getABaseType*() instanceof
      SystemCollectionsIEnumerableInterface and
    this.hasName("Clear")
  }

  override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
    pos.isThisParameter() and
    content instanceof DataFlow::ElementContent
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

/** Data flow for `System.Collections.ICollection`. */
private class SystemCollectionsICollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections;ICollection;true;CopyTo;(System.Array,System.Int32);;Element of Argument[Qualifier];Element of Argument[0];value"
  }
}

/** The `System.Collections.IList` interface. */
class SystemCollectionsIListInterface extends SystemCollectionsInterface {
  SystemCollectionsIListInterface() { this.hasName("IList") }
}

/** Data flow for `System.Collections.IList`. */
private class SystemCollectionsIListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;IList;true;Add;(System.Object);;Argument[0];Element of Argument[Qualifier];value",
        "System.Collections;IList;true;Insert;(System.Int32,System.Object);;Argument[1];Element of Argument[Qualifier];value",
        "System.Collections;IList;true;get_Item;(System.Int32);;Element of Argument[Qualifier];ReturnValue;value",
        "System.Collections;IList;true;set_Item;(System.Int32,System.Object);;Argument[1];Element of Argument[Qualifier];value",
      ]
  }
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
        "System.Collections;IDictionary;true;Add;(System.Object,System.Object);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[Qualifier];value",
        "System.Collections;IDictionary;true;Add;(System.Object,System.Object);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];value",
        "System.Collections;IDictionary;true;get_Item;(System.Object);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];ReturnValue;value",
        "System.Collections;IDictionary;true;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[Qualifier];Element of ReturnValue;value",
        "System.Collections;IDictionary;true;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];Element of ReturnValue;value",
        "System.Collections;IDictionary;true;set_Item;(System.Object,System.Object);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[Qualifier];value",
        "System.Collections;IDictionary;true;set_Item;(System.Object,System.Object);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];value",
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
        "System.Collections;SortedList;false;GetByIndex;(System.Int32);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];ReturnValue;value",
        "System.Collections;SortedList;false;GetValueList;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];Element of ReturnValue;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary,System.Collections.IComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary,System.Collections.IComparer);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.ArrayList`. */
private class SystemCollectionsArrayListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;ArrayList;false;AddRange;(System.Collections.ICollection);;Element of Argument[0];Element of Argument[Qualifier];value",
        "System.Collections;ArrayList;false;Clone;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;ArrayList;false;FixedSize;(System.Collections.ArrayList);;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;ArrayList;false;FixedSize;(System.Collections.IList);;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;ArrayList;false;GetEnumerator;(System.Int32,System.Int32);;Element of Argument[Qualifier];Property[System.Collections.IEnumerator.Current] of ReturnValue;value",
        "System.Collections;ArrayList;false;GetRange;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;ArrayList;false;InsertRange;(System.Int32,System.Collections.ICollection);;Element of Argument[1];Element of Argument[Qualifier];value",
        "System.Collections;ArrayList;false;Repeat;(System.Object,System.Int32);;Argument[0];Element of ReturnValue;value",
        "System.Collections;ArrayList;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;ArrayList;false;Reverse;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.BitArray`. */
private class SystemCollectionsBitArrayFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections;BitArray;false;Clone;();;Element of Argument[0];Element of ReturnValue;value"
  }
}

/** Data flow for `System.Collections.Queue`. */
private class SystemCollectionsQueueFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;Queue;false;Clone;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;Queue;false;Peek;();;Element of Argument[Qualifier];ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Stack`. */
private class SystemCollectionsStackFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;Stack;false;Clone;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections;Stack;false;Peek;();;Element of Argument[Qualifier];ReturnValue;value",
        "System.Collections;Stack;false;Pop;();;Element of Argument[Qualifier];ReturnValue;value",
      ]
  }
}
