/**
 * @name Using 'toString' in query logic
 * @description A query should not depend on the output of 'toString'.
 * @kind problem
 * @problem.severity error
 * @id ql/to-string-in-logic
 * @precision medium
 * @tags maintainability
 */

import ql
import codeql_ql.ast.internal.Builtins

class ToString extends Predicate {
  ToString() { this.getName() = "toString" }
}

class ToStringCall extends Call {
  ToStringCall() { this.getTarget() instanceof ToString }
}

class NodesPredicate extends Predicate {
  NodesPredicate() { this.getName() = "nodes" }
}

class EdgesPredicate extends Predicate {
  EdgesPredicate() { this.getName() = "edges" }
}

class RegexpReplaceAll extends BuiltinPredicate {
  RegexpReplaceAll() { this.getName() = "regexpReplaceAll" }
}

class RegexpReplaceAllCall extends MemberCall {
  RegexpReplaceAllCall() { this.getTarget() instanceof RegexpReplaceAll }
}

module DataFlow {
  private newtype TNode =
    TExprNode(Expr e) or
    TOutParameterNode(Parameter p) or
    TArgumentOutNode(VarAccess acc, Call call, int pos) {
      acc.(Argument).getCall() = call and acc.(Argument).getPosition() = pos
    } or
    TParameterNode(Parameter p)

  /** An argument to a call. */
  class Argument extends Expr {
    Call call;
    int pos;

    Argument() { call.getArgument(pos) = this }

    /** Gets the call that has this argument. */
    Call getCall() { result = call }

    /** Gets the position of this argument. */
    int getPosition() { result = pos }
  }

  private newtype TParameter =
    TThisParameter(ClassPredicate p) or
    TResultParameter(Predicate p) { exists(p.getReturnType()) } or
    TVariableParameter(VarDecl v, int i, Predicate pred) { pred.getParameter(i) = v }

  abstract class Parameter extends TParameter {
    string toString() { this.hasName(result) }

    abstract predicate hasName(string name);

    abstract int getIndex();

    abstract Predicate getPredicate();
  }

  class ThisParameter extends Parameter, TThisParameter {
    ClassPredicate p;

    ThisParameter() { this = TThisParameter(p) }

    override predicate hasName(string name) { name = "this" }

    override int getIndex() { result = -1 }

    override Predicate getPredicate() { result = p }
  }

  class ResultParameter extends Parameter, TResultParameter {
    Predicate p;

    ResultParameter() { this = TResultParameter(p) }

    override predicate hasName(string name) { name = "result" }

    override int getIndex() { result = -2 }

    override Predicate getPredicate() { result = p }
  }

  class VariableParameter extends Parameter, TVariableParameter {
    VarDecl v;
    int i;
    Predicate p;

    VariableParameter() { this = TVariableParameter(v, i, p) }

    override predicate hasName(string name) { name = v.getName() }

    override int getIndex() { result = i }

    override Predicate getPredicate() { result = p }
  }

  class Node extends TNode {
    /** Gets the predicate to which this node belongs. */
    Predicate getPredicate() { none() } // overridden in subclasses

    Expr asExpr() { result = this.(ExprNode).getExpr() }

    /** Gets a textual representation of this element. */
    string toString() { none() } // overridden by subclasses
  }

  /**
   * An expression, viewed as a node in a data flow graph.
   */
  class ExprNode extends Node, TExprNode {
    Expr expr;

    ExprNode() { this = TExprNode(expr) }

    override string toString() { result = expr.toString() }

    /** Gets the expression corresponding to this node. */
    Expr getExpr() { result = expr }
  }

  class ParameterNode extends Node, TParameterNode {
    Parameter p;

    ParameterNode() { this = TParameterNode(p) }

    override string toString() { result = p.toString() }
  }

  /** A data flow node that represents the output of a call at the call site. */
  abstract class OutNode extends Node {
    /** Gets the underlying call. */
    abstract Call getCall();
  }

  class ArgumentOutNode extends Node, TArgumentOutNode, OutNode {
    VarAccess acc;
    Call call;
    int pos;

    ArgumentOutNode() { this = TArgumentOutNode(acc, call, pos) }

    VarAccess getVarAccess() { result = acc }

    override string toString() { result = acc.toString() + " [out]" }

    override Call getCall() { result = call }

    int getIndex() { result = pos }
  }

  class OutParameterNode extends Node, TOutParameterNode {
    Parameter p;

    OutParameterNode() { this = TOutParameterNode(p) }

    Parameter getParameter() { result = p }

    override string toString() { result = p.toString() }
  }

  AstNode getParentOfExpr(Expr e) { result = e.getParent() }

  Formula getEnclosing(Expr e) { result = getParentOfExpr+(e) }

  Formula enlargeScopeStep(Formula f) { result.(Conjunction).getAnOperand() = f }

  Formula enlargeScope(Formula f) {
    result = enlargeScopeStep*(f) and not exists(enlargeScopeStep(result))
  }

  predicate varaccesValue(VarAccess va, VarDecl v, Formula scope) {
    va.getDeclaration() = v and
    scope = enlargeScope(getEnclosing(va))
  }

  predicate thisValue(ThisAccess ta, Formula scope) { scope = enlargeScope(getEnclosing(ta)) }

  predicate resultValue(ResultAccess ra, Formula scope) { scope = enlargeScope(getEnclosing(ra)) }

  Formula getParentFormula(Formula f) { f.getParent() = result }

  predicate valueStep(Expr e1, Expr e2) {
    exists(VarDecl v, Formula scope |
      varaccesValue(e1, v, scope) and
      varaccesValue(e2, v, scope)
    )
    or
    exists(VarDecl v, Formula f, Select sel |
      getParentFormula*(f) = sel.getWhere() and
      varaccesValue(e1, v, f) and
      sel.getExpr(_) = e2
    )
    or
    exists(Formula scope |
      thisValue(e1, scope) and
      thisValue(e2, scope)
      or
      resultValue(e1, scope) and
      resultValue(e2, scope)
    )
    or
    exists(InlineCast c |
      e1 = c and e2 = c.getBase()
      or
      e2 = c and e1 = c.getBase()
    )
    or
    exists(ComparisonFormula eq |
      eq.getOperator() = "=" and
      eq.getAnOperand() = e1 and
      eq.getAnOperand() = e2 and
      e1 != e2
    )
  }

  predicate paramStep(Expr e1, Parameter p2) {
    exists(VarDecl v |
      p2 = TVariableParameter(v, _, _) and
      varaccesValue(e1, v, _)
    )
    or
    exists(Formula scope |
      p2 = TThisParameter(scope.getEnclosingPredicate()) and
      thisValue(e1, scope)
      or
      p2 = TResultParameter(scope.getEnclosingPredicate()) and
      resultValue(e1, scope)
    )
  }

  predicate additionalLocalStep(Node nodeFrom, Node nodeTo) {
    nodeFrom.asExpr().getType() instanceof StringClass and
    nodeFrom.asExpr().getType() instanceof StringClass and
    exists(BinOpExpr binop |
      nodeFrom.asExpr() = binop.getAnOperand() and
      nodeTo.asExpr() = binop
    )
    or
    nodeTo.asExpr().(RegexpReplaceAllCall).getBase() = nodeFrom.asExpr()
  }

  predicate localStep(Node nodeFrom, Node nodeTo) {
    valueStep(nodeFrom.asExpr(), nodeTo.asExpr())
    or
    paramStep(nodeFrom.asExpr(), nodeTo.(OutParameterNode).getParameter())
    or
    valueStep(nodeFrom.(ArgumentOutNode).getVarAccess(), nodeTo.asExpr())
    or
    additionalLocalStep(nodeFrom, nodeTo)
  }

  predicate step(Node nodeFrom, Node nodeTo) {
    // Local flow
    localStep(nodeFrom, nodeTo)
    or
    // Flow out of functions
    exists(Call call, Parameter p, OutParameterNode outParam, ArgumentOutNode outArg |
      outParam = nodeFrom and
      outArg = nodeTo
    |
      p = outParam.getParameter() and
      p.getPredicate() = call.getTarget() and
      outArg.getCall() = call and
      outArg.getIndex() = p.getIndex()
    )
  }

  predicate flowsFromSource(Node node) {
    isSource(node.asExpr())
    or
    exists(Node mid | flowsFromSource(mid) | step(mid, node))
  }

  predicate flowsToSink(Node node) {
    flowsFromSource(node) and isSink(node)
    or
    exists(Node mid | flowsToSink(mid) | step(node, mid))
  }

  predicate isSink(Node sink) {
    sink.asExpr() = any(Select s).getExpr(_)
    or
    sink.getPredicate() instanceof NodesPredicate
    or
    sink.getPredicate() instanceof EdgesPredicate
  }

  predicate isSource(ToStringCall toString) {
    not toString.getEnclosingPredicate() instanceof ToString and
    not toString.getEnclosingPredicate() instanceof NodesPredicate and
    not toString.getEnclosingPredicate() instanceof EdgesPredicate
  }
}

predicate flowsToSelect(Expr e) {
  exists(DataFlow::Node source |
    source.asExpr() = e and
    DataFlow::flowsToSink(source)
  )
}

from ToStringCall call
where
  // It's not part of a toString call
  DataFlow::isSource(call) and
  // The call doesn't flow to a select
  not flowsToSelect(call) and
  // It's in a query
  call.getLocation().getFile().getBaseName().matches("%.ql") and
  // ... and not in a test
  not (
    call.getLocation()
        .getFile()
        .getAbsolutePath()
        .toLowerCase()
        .matches(["%test%", "%consistency%", "%meta%"])
    or
    call.getLocation()
        .getFile()
        .getAbsolutePath()
        .regexpMatch(".*/(test|examples|ql-training|recorded-call-graph-metrics)/.*")
  )
select call, "Query logic depends on implementation of 'toString'."
