/**
 * INTERNAL: Do not use.
 *
 * Provides functionality for comparing data from `rust-analyzer` with data computed
 * in QL.
 */

import rust

private signature module ResolvableSig {
  class Source {
    string toString();

    Location getLocation();
  }

  class Target {
    string toString();

    Location getLocation();
  }
}

private signature module CompareSig<ResolvableSig R> {
  predicate isResolvable(R::Source s);

  R::Target resolve(R::Source s);
}

private module Compare<ResolvableSig R, CompareSig<R> RustAnalyzer, CompareSig<R> Ql> {
  private import R

  predicate same(Source s, Target t) {
    t = RustAnalyzer::resolve(s) and
    t = Ql::resolve(s)
  }

  predicate sameCount(int c) { c = count(Source s | same(s, _)) }

  predicate diff(Source s, Target t1, Target t2) {
    t1 = RustAnalyzer::resolve(s) and
    t2 = Ql::resolve(s) and
    t1 != t2
  }

  predicate diffCount(int c) { c = count(Source s | not same(s, _) and diff(s, _, _)) }

  predicate rustAnalyzerUnique(Source s) {
    RustAnalyzer::isResolvable(s) and
    not Ql::isResolvable(s)
  }

  predicate rustAnalyzerUniqueCount(int c) { c = count(Source s | rustAnalyzerUnique(s)) }

  predicate qlUnique(Source s) {
    not RustAnalyzer::isResolvable(s) and
    Ql::isResolvable(s)
  }

  predicate qlUniqueCount(int c) { c = count(Source s | qlUnique(s)) }

  // debug predicates to find missing targets in QL implementation
  private module Debug {
    predicate qlMissing(Source s, Target t) {
      t = RustAnalyzer::resolve(s) and
      not t = Ql::resolve(s)
    }

    predicate qlMissingWithCount(Source s, Target t, int c) {
      qlMissing(s, t) and
      c = strictcount(Source s0 | qlMissing(s0, t))
    }
  }

  predicate summary(string key, int value) {
    key = "rust-analyzer unique" and rustAnalyzerUniqueCount(value)
    or
    key = "QL unique" and qlUniqueCount(value)
    or
    key = "same" and sameCount(value)
    or
    key = "different" and diffCount(value)
  }
}

private module PathResolution implements ResolvableSig {
  class Source extends Resolvable {
    Source() { not this instanceof MethodCallExpr }
  }

  class Target = Item;
}

private module RustAnalyzerPathResolution implements CompareSig<PathResolution> {
  predicate isResolvable(PathResolution::Source s) { s.hasResolvedPath() }

  Item resolve(PathResolution::Source s) { s.resolvesAsItem(result) }
}

private module QlPathResolution implements CompareSig<PathResolution> {
  private import codeql.rust.internal.PathResolution

  private Path getPath(Resolvable r) {
    result = r.(PathExpr).getPath()
    or
    result = r.(StructExpr).getPath()
    or
    result = r.(PathPat).getPath()
    or
    result = r.(StructPat).getPath()
    or
    result = r.(TupleStructPat).getPath()
  }

  predicate isResolvable(PathResolution::Source s) { exists(resolve(s)) }

  Item resolve(PathResolution::Source s) { result = resolvePath(getPath(s)) }
}

module PathResolutionCompare =
  Compare<PathResolution, RustAnalyzerPathResolution, QlPathResolution>;

private module CallGraph implements ResolvableSig {
  class Source = CallExprBase;

  class Target = Item;
}

private module RustAnalyzerCallGraph implements CompareSig<CallGraph> {
  private import codeql.rust.elements.internal.CallExprBaseImpl::Impl as CallExprBaseImpl

  predicate isResolvable(CallExprBase c) {
    CallExprBaseImpl::getCallResolvable(c).hasResolvedPath()
  }

  Item resolve(CallExprBase c) { CallExprBaseImpl::getCallResolvable(c).resolvesAsItem(result) }
}

private module QlCallGraph implements CompareSig<CallGraph> {
  private import codeql.rust.internal.PathResolution as PathResolution

  predicate isResolvable(CallExprBase c) { exists(resolve(c)) }

  Item resolve(CallExprBase c) { result = c.getStaticTarget() }
}

module CallGraphCompare = Compare<CallGraph, RustAnalyzerCallGraph, QlCallGraph>;
