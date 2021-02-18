private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.TreeSitter
private import codeql_ruby.ast.internal.Expr

module Operation {
  abstract class Range extends Expr::Range {
    abstract string getOperator();

    abstract Stmt getAnOperand();

    override predicate child(string label, AstNode::Range child) {
      label = "getAnOperand" and child = getAnOperand()
    }
  }
}

module UnaryOperation {
  abstract class Range extends Operation::Range, @unary {
    final override Generated::Unary generated;

    final override string getOperator() { result = generated.getOperator() }

    Expr getOperand() { result = generated.getOperand() }

    final override Expr getAnOperand() { result = this.getOperand() }

    override string toString() { result = this.getOperator() + " ..." }

    override predicate child(string label, AstNode::Range child) {
      Operation::Range.super.child(label, child)
      or
      label = "getOperand" and child = getOperand()
    }
  }
}

module UnaryLogicalOperation {
  abstract class Range extends UnaryOperation::Range { }
}

module UnaryArithmeticOperation {
  abstract class Range extends UnaryOperation::Range { }
}

module UnaryBitwiseOperation {
  abstract class Range extends UnaryOperation::Range { }
}

module NotExpr {
  class DbUnion = @unary_bang or @unary_not;

  class Range extends UnaryLogicalOperation::Range, DbUnion { }
}

module UnaryPlusExpr {
  class Range extends UnaryArithmeticOperation::Range, @unary_plus { }
}

module UnaryMinusExpr {
  class Range extends UnaryArithmeticOperation::Range, @unary_minus { }
}

module ComplementExpr {
  class Range extends UnaryBitwiseOperation::Range, @unary_tilde { }
}

module DefinedExpr {
  class Range extends UnaryOperation::Range, @unary_definedquestion { }
}

module BinaryOperation {
  abstract class Range extends Operation::Range, @binary {
    final override Generated::Binary generated;

    final override string getOperator() { result = generated.getOperator() }

    final Expr getLeftOperand() { result = generated.getLeft() }

    final Stmt getRightOperand() { result = generated.getRight() }

    final override Stmt getAnOperand() {
      result = this.getLeftOperand() or result = this.getRightOperand()
    }

    override string toString() { result = "... " + this.getOperator() + " ..." }

    override predicate child(string label, AstNode::Range child) {
      Operation::Range.super.child(label, child)
      or
      label = "getLeftOperand" and child = getLeftOperand()
      or
      label = "getRightOperand" and child = getRightOperand()
    }
  }
}

module BinaryArithmeticOperation {
  abstract class Range extends BinaryOperation::Range { }
}

module BinaryLogicalOperation {
  abstract class Range extends BinaryOperation::Range { }
}

module BinaryBitwiseOperation {
  abstract class Range extends BinaryOperation::Range { }
}

module ComparisonOperation {
  abstract class Range extends BinaryOperation::Range, @binary { }
}

module AddExpr {
  class Range extends BinaryArithmeticOperation::Range, @binary_plus { }
}

module SubExpr {
  class Range extends BinaryArithmeticOperation::Range, @binary_minus { }
}

module MulExpr {
  class Range extends BinaryArithmeticOperation::Range, @binary_star { }
}

module DivExpr {
  class Range extends BinaryArithmeticOperation::Range, @binary_slash { }
}

module ModuloExpr {
  class Range extends BinaryArithmeticOperation::Range, @binary_percent { }
}

module ExponentExpr {
  class Range extends BinaryArithmeticOperation::Range, @binary_starstar { }
}

module LogicalAndExpr {
  class DbUnion = @binary_and or @binary_ampersandampersand;

  class Range extends BinaryLogicalOperation::Range, DbUnion { }
}

module LogicalOrExpr {
  class DbUnion = @binary_or or @binary_pipepipe;

  class Range extends BinaryLogicalOperation::Range, DbUnion { }
}

module LShiftExpr {
  class Range extends BinaryBitwiseOperation::Range, @binary_langlelangle { }
}

module RShiftExpr {
  class Range extends BinaryBitwiseOperation::Range, @binary_ranglerangle { }
}

module BitwiseAndExpr {
  class Range extends BinaryBitwiseOperation::Range, @binary_ampersand { }
}

module BitwiseOrExpr {
  class Range extends BinaryBitwiseOperation::Range, @binary_pipe { }
}

module BitwiseXorExpr {
  class Range extends BinaryBitwiseOperation::Range, @binary_caret { }
}

module EqualityOperation {
  abstract class Range extends ComparisonOperation::Range { }
}

module EqExpr {
  class Range extends EqualityOperation::Range, @binary_equalequal { }
}

module NEExpr {
  class Range extends EqualityOperation::Range, @binary_bangequal { }
}

module CaseEqExpr {
  class Range extends EqualityOperation::Range, @binary_equalequalequal { }
}

module RelationalOperation {
  abstract class Range extends ComparisonOperation::Range {
    abstract Expr getGreaterOperand();

    abstract Expr getLesserOperand();

    override predicate child(string label, AstNode::Range child) {
      ComparisonOperation::Range.super.child(label, child)
      or
      label = "getGreaterOperand" and child = getGreaterOperand()
      or
      label = "getLesserOperand" and child = getLesserOperand()
    }
  }
}

module GTExpr {
  class Range extends RelationalOperation::Range, @binary_rangle {
    final override Expr getGreaterOperand() { result = this.getLeftOperand() }

    final override Expr getLesserOperand() { result = this.getRightOperand() }
  }
}

module GEExpr {
  class Range extends RelationalOperation::Range, @binary_rangleequal {
    final override Expr getGreaterOperand() { result = this.getLeftOperand() }

    final override Expr getLesserOperand() { result = this.getRightOperand() }
  }
}

module LTExpr {
  class Range extends RelationalOperation::Range, @binary_langle {
    final override Expr getGreaterOperand() { result = this.getRightOperand() }

    final override Expr getLesserOperand() { result = this.getLeftOperand() }
  }
}

module LEExpr {
  class Range extends RelationalOperation::Range, @binary_langleequal {
    final override Expr getGreaterOperand() { result = this.getRightOperand() }

    final override Expr getLesserOperand() { result = this.getLeftOperand() }
  }
}

module SpaceshipExpr {
  class Range extends BinaryOperation::Range, @binary_langleequalrangle { }
}

module RegexMatchExpr {
  class Range extends BinaryOperation::Range, @binary_equaltilde { }
}

module NoRegexMatchExpr {
  class Range extends BinaryOperation::Range, @binary_bangtilde { }
}

module Assignment {
  abstract class Range extends Operation::Range {
    abstract Pattern getLeftOperand();

    abstract Expr getRightOperand();

    final override Expr getAnOperand() {
      result = this.getLeftOperand() or result = this.getRightOperand()
    }

    override string toString() { result = "... " + this.getOperator() + " ..." }

    override predicate child(string label, AstNode::Range child) {
      Operation::Range.super.child(label, child)
      or
      label = "getLeftOperand" and child = getLeftOperand()
      or
      label = "getRightOperand" and child = getRightOperand()
    }
  }
}

module AssignExpr {
  class Range extends Assignment::Range, @assignment {
    final override Generated::Assignment generated;

    final override Pattern getLeftOperand() { result = generated.getLeft() }

    final override Expr getRightOperand() { result = generated.getRight() }

    final override string getOperator() { result = "=" }
  }
}

module AssignOperation {
  abstract class Range extends Assignment::Range, @operator_assignment {
    final override Generated::OperatorAssignment generated;

    final override string getOperator() { result = generated.getOperator() }

    final override LhsExpr getLeftOperand() { result = generated.getLeft() }

    final override Expr getRightOperand() { result = generated.getRight() }
  }
}

module AssignArithmeticOperation {
  abstract class Range extends AssignOperation::Range { }
}

module AssignLogicalOperation {
  abstract class Range extends AssignOperation::Range { }
}

module AssignBitwiseOperation {
  abstract class Range extends AssignOperation::Range { }
}

module AssignAddExpr {
  class Range extends AssignArithmeticOperation::Range, @operator_assignment_plusequal { }
}

module AssignSubExpr {
  class Range extends AssignArithmeticOperation::Range, @operator_assignment_minusequal { }
}

module AssignMulExpr {
  class Range extends AssignArithmeticOperation::Range, @operator_assignment_starequal { }
}

module AssignDivExpr {
  class Range extends AssignArithmeticOperation::Range, @operator_assignment_slashequal { }
}

module AssignExponentExpr {
  class Range extends AssignArithmeticOperation::Range, @operator_assignment_starstarequal { }
}

module AssignModuloExpr {
  class Range extends AssignArithmeticOperation::Range, @operator_assignment_percentequal { }
}

module AssignLogicalAndExpr {
  class Range extends AssignLogicalOperation::Range, @operator_assignment_ampersandampersandequal {
  }
}

module AssignLogicalOrExpr {
  class Range extends AssignLogicalOperation::Range, @operator_assignment_pipepipeequal { }
}

module AssignLShiftExpr {
  class Range extends AssignBitwiseOperation::Range, @operator_assignment_langlelangleequal { }
}

module AssignRShiftExpr {
  class Range extends AssignBitwiseOperation::Range, @operator_assignment_ranglerangleequal { }
}

module AssignBitwiseAndExpr {
  class Range extends AssignBitwiseOperation::Range, @operator_assignment_ampersandequal { }
}

module AssignBitwiseOrExpr {
  class Range extends AssignBitwiseOperation::Range, @operator_assignment_pipeequal { }
}

module AssignBitwiseXorExpr {
  class Range extends AssignBitwiseOperation::Range, @operator_assignment_caretequal { }
}
