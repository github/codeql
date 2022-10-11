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
// // This gives access to getNodeFromPath, which is not constrained to `CallNode`s
// // as `resolvedSummaryBase` is.
// private import semmle.python.frameworks.data.internal.ApiGraphModels as AGM
//
// private class SummarizedCallableFromModel extends SummarizedCallable {
//   string package;
//   string type;
//   string path;
//   SummarizedCallableFromModel() {
//     ModelOutput::relevantSummaryModel(package, type, path, _, _, _) and
//     this = package + ";" + type + ";" + path
//   }
//   override CallCfgNode getACall() {
//     exists(API::CallNode base |
//       ModelOutput::resolvedSummaryBase(package, type, path, base) and
//       result = base.getACall()
//     )
//   }
//   override ArgumentNode getACallback() {
//     exists(API::Node base |
//       base = AGM::getNodeFromPath(package, type, path) and
//       result = base.getAValueReachableFromSource()
//     )
//   }
//   override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
//     exists(string kind |
//       ModelOutput::relevantSummaryModel(package, type, path, input, output, kind)
//     |
//       kind = "value" and
//       preservesValue = true
//       or
//       kind = "taint" and
//       preservesValue = false
//     )
//   }
// }
