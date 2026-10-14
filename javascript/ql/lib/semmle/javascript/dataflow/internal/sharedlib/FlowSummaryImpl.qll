private import semmle.javascript.Locations
private import codeql.dataflow.internal.FlowSummaryImpl
private import DataFlowArg
private import semmle.javascript.dataflow.internal.FlowSummaryPrivate as Priv

private module Impl = Make<Location, JSDataFlow, JSFlowSummary>;

module Private {
  import Impl::Private
  import Priv::Impl2
}

module Public = Impl::Public;
