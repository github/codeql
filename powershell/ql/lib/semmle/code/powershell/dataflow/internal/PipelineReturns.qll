private import semmle.code.powershell.controlflow.CfgNodes

/**
 * The input module which defines the set of sources for which to calculate
 * "escaping expressions".
 */
signature module InputSig {
  /**
   * Holds if `source` is a relevant AST element that we want to compute
   * which expressions are returned from.
   */
  predicate isSource(AstCfgNode source);
}

/** The output signature from the "escape analysis". */
signature module OutputSig<InputSig Input> {
  /** Gets an expression that escapes from `source` */
  ExprCfgNode getAReturn(AstCfgNode source);

  /**
   * Gets the `i`'th expression that escapes from `source`, if an ordering can
   * be determined statically.
   */
  ExprCfgNode getReturn(AstCfgNode source, int i);

  /** Holds multiple value may escape from `source`. */
  predicate mayReturnMultipleValues(AstCfgNode source);

  /**
   * Holds if each value escaping from `source` is guarenteed to only escape
   * once. In particular, if `count(getAReturn(source)) = 1` and this predicate
   * holds, then only one value can escape from `source`.
   *
   * If `count(getAReturn(source)) > 1` and this predicate holds,
   * it means that a sequence of values may escape from `source`.
   */
  predicate eachValueIsReturnedOnce(AstCfgNode source);
}

module Make<InputSig Input> implements OutputSig<Input> {
  private import Input

  private predicate step0(AstCfgNode pred, AstCfgNode succ) {
    exists(NamedBlockCfgNode nb |
      pred = nb and
      succ = nb.getAStmt()
    )
    or
    exists(StmtNodes::StmtBlockCfgNode sb |
      pred = sb and
      succ = sb.getAStmt()
    )
    or
    exists(StmtNodes::ExprStmtCfgNode es |
      pred = es and
      succ = es.getExpr()
    )
    or
    exists(StmtNodes::ReturnStmtCfgNode es |
      pred = es and
      succ = es.getPipeline()
    )
    or
    exists(ExprNodes::ArrayLiteralCfgNode al |
      pred = al and
      succ = al.getAnExpr()
    )
    or
    exists(StmtNodes::LoopStmtCfgNode loop |
      pred = loop and
      succ = loop.getBody()
    )
    or
    exists(ExprNodes::IfCfgNode if_ |
      pred = if_ and
      succ = if_.getABranch()
    )
    or
    exists(StmtNodes::SwitchStmtCfgNode switch |
      pred = switch and
      succ = switch.getACase()
    )
    or
    exists(CatchClauseCfgNode catch |
      pred = catch and
      succ = catch.getBody()
    )
    or
    exists(StmtNodes::TryStmtCfgNode try |
      pred = try and
      succ = [try.getBody(), try.getFinally()]
    )
  }

  private predicate fwd(AstCfgNode n) {
    isSource(n)
    or
    exists(AstCfgNode pred |
      fwd(pred) and
      step0(pred, n)
    )
  }

  private predicate isSink(AstCfgNode sink) {
    fwd(sink) and
    (
      sink instanceof ExprCfgNode and
      // If is not really an expression
      not sink instanceof ExprNodes::IfCfgNode and
      // When `a, b, c` is returned it is flattened to returning a, and b, and c.
      not sink instanceof ExprNodes::ArrayLiteralCfgNode
    )
  }

  private predicate rev(AstCfgNode n) {
    fwd(n) and
    (
      isSink(n)
      or
      exists(AstCfgNode succ |
        rev(succ) and
        step0(n, succ)
      )
    )
  }

  private predicate step(AstCfgNode n1, AstCfgNode n2) {
    rev(n1) and
    rev(n2) and
    step0(n1, n2)
  }

  private predicate stepPlus(AstCfgNode n1, AstCfgNode n2) =
    doublyBoundedFastTC(step/2, isSource/1, isSink/1)(n1, n2)

  /** Gets a value that may be returned from `source`. */
  private ExprCfgNode getAReturn0(AstCfgNode source) {
    isSource(source) and
    isSink(result) and
    stepPlus(source, result)
  }

  private predicate inScopeOfSource(AstCfgNode n, AstCfgNode source) {
    isSource(source) and
    n.getAstNode().getParent*() = source.getAstNode()
  }

  private predicate getASuccessor(AstCfgNode pred, AstCfgNode succ) {
    exists(AstCfgNode source |
      inScopeOfSource(pred, source) and
      pred.getASuccessor() = succ and
      inScopeOfSource(succ, source)
    )
  }

  /** Holds if `e` may be returned multiple times from `source`. */
  private predicate mayBeReturnedMoreThanOnce(ExprCfgNode e, AstCfgNode source) {
    e = getAReturn0(source) and getASuccessor+(e, e)
  }

  predicate eachValueIsReturnedOnce(AstCfgNode source) {
    isSource(source) and
    not mayBeReturnedMoreThanOnce(_, source)
  }

  private predicate isSourceForSingularReturn(AstCfgNode source) {
    isSource(source) and
    eachValueIsReturnedOnce(source)
  }

  private predicate hasReturnOrderImpl0(int dist, ExprCfgNode e, AstCfgNode source) =
    shortestDistances(isSourceForSingularReturn/1, getASuccessor/2)(source, e, dist)

  private predicate hasReturnOrderImpl(int dist, ExprCfgNode e) {
    hasReturnOrderImpl0(dist, e, _) and
    e = getAReturn0(_)
  }

  private predicate hasReturnOrder(int i, ExprCfgNode e) {
    e = rank[i + 1](ExprCfgNode e0, int i0 | hasReturnOrderImpl(i0, e0) | e0 order by i0)
  }

  ExprCfgNode getReturn(AstCfgNode source, int i) {
    result = getAReturn0(source) and
    eachValueIsReturnedOnce(source) and
    hasReturnOrder(i, result)
  }

  ExprCfgNode getAReturn(AstCfgNode source) { result = getAReturn0(source) }

  /**
   * Holds if `source` may return multiple values, and `n` is one of the values.
   */
  predicate mayReturnMultipleValues(AstCfgNode source) {
    strictcount(getAReturn0(source)) > 1
    or
    mayBeReturnedMoreThanOnce(_, source)
  }
}
