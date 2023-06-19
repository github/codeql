/** Provides classes and predicates for defining flow summaries. */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.ApiGraphs
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowUtil
private import internal.DataFlowPrivate

// import all instances below
private module Summaries {
  private import semmle.python.Frameworks
}

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  private import Impl::Public::SummaryComponent as SC

  predicate parameter = SC::parameter/1;

  predicate argument = SC::argument/1;

  predicate content = SC::content/1;

  /** Gets a summary component that represents a list element. */
  SummaryComponent listElement() { result = content(any(ListElementContent c)) }

  /** Gets a summary component that represents a set element. */
  SummaryComponent setElement() { result = content(any(SetElementContent c)) }

  /** Gets a summary component that represents a tuple element. */
  SummaryComponent tupleElement(int index) {
    exists(TupleElementContent c | c.getIndex() = index and result = content(c))
  }

  /** Gets a summary component that represents a dictionary element. */
  SummaryComponent dictionaryElement(string key) {
    exists(DictionaryElementContent c | c.getKey() = key and result = content(c))
  }

  /** Gets a summary component that represents a dictionary element at any key. */
  SummaryComponent dictionaryElementAny() { result = content(any(DictionaryElementAnyContent c)) }

  /** Gets a summary component that represents an attribute element. */
  SummaryComponent attribute(string attr) {
    exists(AttributeContent c | c.getAttribute() = attr and result = content(c))
  }

  /** Gets a summary component that represents the return value of a call. */
  SummaryComponent return() { result = SC::return(any(ReturnKind rk)) }
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  private import Impl::Public::SummaryComponentStack as SCS

  predicate singleton = SCS::singleton/1;

  predicate push = SCS::push/2;

  predicate argument = SCS::argument/1;

  /** Gets a singleton stack representing the return value of a call. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
}

/** A callable with a flow summary, identified by a unique string. */
abstract class SummarizedCallable extends LibraryCallable, Impl::Public::SummarizedCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  /**
   * Same as
   *
   * ```ql
   * propagatesFlow(
   *   SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
   * )
   * ```
   *
   * but uses an external (string) representation of the input and output stacks.
   */
  pragma[nomagic]
  predicate propagatesFlowExt(string input, string output, boolean preservesValue) { none() }
}

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;

private class SummarizedCallableFromModel extends SummarizedCallable {
  string type;
  string path;

  SummarizedCallableFromModel() {
    ModelOutput::relevantSummaryModel(type, path, _, _, _) and
    this = type + ";" + path
  }

  override CallCfgNode getACall() { ModelOutput::resolvedSummaryBase(type, path, result) }

  override ArgumentNode getACallback() {
    exists(API::Node base |
      ModelOutput::resolvedSummaryRefBase(type, path, base) and
      result = base.getAValueReachableFromSource()
    )
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    exists(string kind | ModelOutput::relevantSummaryModel(type, path, input, output, kind) |
      kind = "value" and
      preservesValue = true
      or
      kind = "taint" and
      preservesValue = false
    )
  }
}
