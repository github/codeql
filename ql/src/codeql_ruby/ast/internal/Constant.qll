private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Pattern
private import codeql_ruby.ast.internal.TreeSitter
private import codeql_ruby.ast.internal.Variable

module ConstantAccess {
  abstract class Range extends Expr::Range {
    override string toString() { result = this.getName() }

    abstract string getName();

    abstract Expr::Range getScopeExpr();

    abstract predicate hasGlobalScope();

    override predicate child(string label, AstNode::Range child) {
      label = "getScopeExpr" and child = getScopeExpr()
    }
  }
}

module ConstantReadAccess {
  abstract class Range extends ConstantAccess::Range { }

  private class TokenConstantReadAccessRange extends ConstantReadAccess::Range, @token_constant {
    final override Generated::Constant generated;

    // A tree-sitter `constant` token is a read of that constant in any context
    // where an identifier would be a vcall.
    TokenConstantReadAccessRange() { vcall(this) }

    final override string getName() { result = generated.getValue() }

    final override Expr::Range getScopeExpr() { none() }

    final override predicate hasGlobalScope() { none() }
  }

  private class ScopeResolutionReadAccessRange extends ConstantReadAccess::Range, @scope_resolution {
    final override Generated::ScopeResolution generated;
    Generated::Constant constant;

    // A tree-sitter `scope_resolution` node with a `constant` name field is a
    // read of that constant in any context where an identifier would be a
    // vcall.
    ScopeResolutionReadAccessRange() {
      constant = generated.getName() and
      vcall(this)
    }

    final override string getName() { result = constant.getValue() }

    final override Expr::Range getScopeExpr() { result = generated.getScope() }

    final override predicate hasGlobalScope() { not exists(generated.getScope()) }
  }
}

module ConstantWriteAccess {
  abstract class Range extends ConstantAccess::Range { }
}

module ConstantAssignment {
  abstract class Range extends ConstantWriteAccess::Range, LhsExpr::Range {
    Range() { explicitAssignmentNode(this, _) }

    override string toString() { result = ConstantWriteAccess::Range.super.toString() }
  }

  private class TokenConstantAssignmentRange extends ConstantAssignment::Range, @token_constant {
    final override Generated::Constant generated;

    final override string getName() { result = generated.getValue() }

    final override Expr::Range getScopeExpr() { none() }

    final override predicate hasGlobalScope() { none() }
  }

  private class ScopeResolutionAssignmentRange extends ConstantAssignment::Range, @scope_resolution {
    final override Generated::ScopeResolution generated;
    Generated::Constant constant;

    ScopeResolutionAssignmentRange() { constant = generated.getName() }

    final override string getName() { result = constant.getValue() }

    final override Expr::Range getScopeExpr() { result = generated.getScope() }

    final override predicate hasGlobalScope() { not exists(generated.getScope()) }
  }
}
