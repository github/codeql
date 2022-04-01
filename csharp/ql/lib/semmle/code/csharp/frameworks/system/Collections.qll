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
      "System.Collections;IEnumerable;true;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value"
  }
}

/** Clear content for Clear methods in all subtypes of `System.Collections.IEnumerable`. */
private class SystemCollectionsIEnumerableClearFlow extends SummarizedCallable {
  SystemCollectionsIEnumerableClearFlow() {
    this.getDeclaringType().(RefType).getABaseType*() instanceof
      SystemCollectionsIEnumerableInterface and
    this.hasName("Clear")
  }

  override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
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
      "System.Collections;ICollection;true;CopyTo;(System.Array,System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value"
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
        "System.Collections;IList;true;Add;(System.Object);;Argument[0];Argument[Qualifier].Element;value",
        "System.Collections;IList;true;Insert;(System.Int32,System.Object);;Argument[1];Argument[Qualifier].Element;value",
        "System.Collections;IList;true;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Collections;IList;true;set_Item;(System.Int32,System.Object);;Argument[1];Argument[Qualifier].Element;value",
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
        "System.Collections;IDictionary;true;Add;(System.Object,System.Object);;Argument[0];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;IDictionary;true;Add;(System.Object,System.Object);;Argument[1];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections;IDictionary;true;get_Item;(System.Object);;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value",
        "System.Collections;IDictionary;true;get_Keys;();;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element;value",
        "System.Collections;IDictionary;true;get_Values;();;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value",
        "System.Collections;IDictionary;true;set_Item;(System.Object,System.Object);;Argument[0];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;IDictionary;true;set_Item;(System.Object,System.Object);;Argument[1];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
      ]
  }
}

/** Data flow for `System.Collections.Hashtable`. */
private class SystemCollectionsHashtableFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;Hashtable;false;Clone;();;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Collections.IEqualityComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Collections.IEqualityComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Collections.IHashCodeProvider,System.Collections.IComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Collections.IHashCodeProvider,System.Collections.IComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single,System.Collections.IEqualityComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single,System.Collections.IEqualityComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single,System.Collections.IHashCodeProvider,System.Collections.IComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;Hashtable;false;Hashtable;(System.Collections.IDictionary,System.Single,System.Collections.IHashCodeProvider,System.Collections.IComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
      ]
  }
}

/** Data flow for `System.Collections.SortedList`. */
private class SystemCollectionsSortedListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;SortedList;false;Clone;();;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;SortedList;false;GetByIndex;(System.Int32);;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value",
        "System.Collections;SortedList;false;GetValueList;();;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary,System.Collections.IComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections;SortedList;false;SortedList;(System.Collections.IDictionary,System.Collections.IComparer);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
      ]
  }
}

/** Data flow for `System.Collections.ArrayList`. */
private class SystemCollectionsArrayListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;ArrayList;false;AddRange;(System.Collections.ICollection);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Collections;ArrayList;false;Clone;();;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;ArrayList;false;FixedSize;(System.Collections.ArrayList);;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;ArrayList;false;FixedSize;(System.Collections.IList);;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;ArrayList;false;GetEnumerator;(System.Int32,System.Int32);;Argument[Qualifier].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value",
        "System.Collections;ArrayList;false;GetRange;(System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;ArrayList;false;InsertRange;(System.Int32,System.Collections.ICollection);;Argument[1].Element;Argument[Qualifier].Element;value",
        "System.Collections;ArrayList;false;Repeat;(System.Object,System.Int32);;Argument[0];ReturnValue.Element;value",
        "System.Collections;ArrayList;false;Reverse;();;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;ArrayList;false;Reverse;(System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;value",
      ]
  }
}

/** Data flow for `System.Collections.BitArray`. */
private class SystemCollectionsBitArrayFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections;BitArray;false;Clone;();;Argument[0].Element;ReturnValue.Element;value"
  }
}

/** Data flow for `System.Collections.Queue`. */
private class SystemCollectionsQueueFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;Queue;false;Clone;();;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;Queue;false;Peek;();;Argument[Qualifier].Element;ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Stack`. */
private class SystemCollectionsStackFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections;Stack;false;Clone;();;Argument[0].Element;ReturnValue.Element;value",
        "System.Collections;Stack;false;Peek;();;Argument[Qualifier].Element;ReturnValue;value",
        "System.Collections;Stack;false;Pop;();;Argument[Qualifier].Element;ReturnValue;value",
      ]
  }
}
