/**
 * @id rb/performance-diagnostics
 * @kind table
 */

/*
 *  This query outputs some numbers that can be used to help narrow down the cause of performance
 *  issues in a codebase, without leaking any actual code or identifiers from the codebase.
 */

import ruby
import codeql.ruby.ApiGraphs

query int numberOfModuleBases() { result = count(Ast::ModuleBase cls) }

query int numberOfClasses() { result = count(Ast::ClassDeclaration cls) }

query int numberOfMethods() { result = count(Ast::MethodBase method) }

query int numberOfCallables() { result = count(Ast::Callable c) }

query int numberOfMethodCalls() { result = count(Ast::MethodCall call) }

query int numberOfCalls() { result = count(Ast::Call call) }

signature module HistogramSig {
  bindingset[this]
  class Bucket;

  int getCounts(Bucket bucket);
}

module MakeHistogram<HistogramSig H> {
  predicate histogram(int bucketSize, int frequency) {
    frequency = strictcount(H::Bucket bucket | H::getCounts(bucket) = bucketSize)
  }
}

module MethodNames implements HistogramSig {
  class Bucket = string;

  int getCounts(string name) {
    result = strictcount(Ast::MethodBase method | method.getName() = name) and
    name != "initialize"
  }
}

query predicate numberOfMethodsWithNameHistogram = MakeHistogram<MethodNames>::histogram/2;

module CallTargets implements HistogramSig {
  class Bucket = Ast::Call;

  int getCounts(Ast::Call call) { result = count(call.getATarget()) }
}

query predicate numberOfCallTargetsHistogram = MakeHistogram<CallTargets>::histogram/2;

module Callers implements HistogramSig {
  class Bucket = Ast::Callable;

  int getCounts(Ast::Callable callable) {
    result = count(Ast::Call call | call.getATarget() = callable)
  }
}

query predicate numberOfCallersHistogram = MakeHistogram<Callers>::histogram/2;

private DataFlow::MethodNode getAnOverriddenMethod(DataFlow::MethodNode method) {
  exists(DataFlow::ModuleNode cls, string name |
    method = cls.getInstanceMethod(name) and
    result = cls.getAnAncestor().getInstanceMethod(name) and
    result != method
  )
}

module MethodOverrides implements HistogramSig {
  class Bucket = DataFlow::MethodNode;

  int getCounts(DataFlow::MethodNode method) { result = count(getAnOverriddenMethod(method)) }
}

query predicate numberOfOverriddenMethodsHistogram = MakeHistogram<MethodOverrides>::histogram/2;

module MethodOverriddenBy implements HistogramSig {
  class Bucket = DataFlow::MethodNode;

  int getCounts(DataFlow::MethodNode method) {
    result = count(DataFlow::MethodNode overrider | method = getAnOverriddenMethod(overrider))
  }
}

query predicate numberOfOverridingMethodsHistogram = MakeHistogram<MethodOverriddenBy>::histogram/2;

module Ancestors implements HistogramSig {
  class Bucket = DataFlow::ModuleNode;

  int getCounts(DataFlow::ModuleNode mod) {
    result =
      count(DataFlow::ModuleNode ancestor | ancestor = mod.getAnAncestor() and ancestor != mod)
  }
}

query predicate numberOfAncestorsHistogram = MakeHistogram<Ancestors>::histogram/2;

module Descendents implements HistogramSig {
  class Bucket = DataFlow::ModuleNode;

  int getCounts(DataFlow::ModuleNode mod) {
    not mod.getQualifiedName() = ["Object", "Kernel", "BasicObject", "Class", "Module"] and
    result =
      count(DataFlow::ModuleNode descendent |
        descendent = mod.getADescendent() and descendent != mod
      )
  }
}

query predicate numberOfDescendentsHistogram = MakeHistogram<Descendents>::histogram/2;
