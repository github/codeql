/** Provides classes and predicates for defining flow summaries. */

private import rust
private import internal.FlowSummaryImpl as Impl
private import codeql.rust.elements.internal.CallExprBaseImpl::Impl as CallExprBaseImpl

// import all instances below
private module Summaries {
  private import codeql.rust.Frameworks
  private import codeql.rust.dataflow.internal.ModelsAsData
}

/** Provides the `Range` class used to define the extent of `LibraryCallable`. */
module LibraryCallable {
  /** A callable defined in library code, identified by a unique string. */
  abstract class Range extends string {
    bindingset[this]
    Range() { any() }

    /** Gets a call to this library callable. */
    CallExprBase getACall() {
      exists(
        TypeItemCanonicalPath path, ModuleItemCanonicalPath item, Namespace namespace,
        string namespace_path
      |
        path = CallExprBaseImpl::getCallResolvable(result).getResolvedCanonicalPath() and
        item = path.getParent() and
        namespace = item.getNamespace() and
        namespace_path = namespace.getPath() and
        if namespace_path = ""
        then this = namespace.getRoot().toString() + "::" + item.getName() + "::" + path.getName()
        else
          this =
            namespace.getRoot().toString() + "::" + namespace_path + "::" + item.getName() + "::" +
              path.getName()
      )
    }
  }
}

final class LibraryCallable = LibraryCallable::Range;

/** Provides the `Range` class used to define the extent of `SummarizedCallable`. */
module SummarizedCallable {
  /** A callable with a flow summary, identified by a unique string. */
  abstract class Range extends LibraryCallable::Range, Impl::Public::SummarizedCallable {
    bindingset[this]
    Range() { any() }

    override predicate propagatesFlow(
      string input, string output, boolean preservesValue, string model
    ) {
      this.propagatesFlow(input, output, preservesValue) and model = ""
    }

    /**
     * Holds if data may flow from `input` to `output` through this callable.
     *
     * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
     */
    predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }
  }
}

final class SummarizedCallable = SummarizedCallable::Range;
