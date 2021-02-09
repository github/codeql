private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Parameter
private import TreeSitter

module Callable {
  abstract class Range extends Expr::Range {
    abstract Parameter::Range getParameter(int n);
  }
}

module Method {
  class Range extends Callable::Range, BodyStatement::Range, @method {
    final override Generated::Method generated;

    override Parameter::Range getParameter(int n) { result = generated.getParameters().getChild(n) }

    string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result = generated.getName().(SymbolLiteral).getValueText() or
      result = generated.getName().(Generated::Setter).getName().getValue() + "="
    }

    final predicate isSetter() { generated.getName() instanceof Generated::Setter }

    final override Expr getExpr(int i) { result = generated.getChild(i) }

    final override string toString() { result = this.getName() }
  }
}

module SingletonMethod {
  class Range extends Callable::Range, BodyStatement::Range, @singleton_method {
    final override Generated::SingletonMethod generated;

    override Parameter::Range getParameter(int n) { result = generated.getParameters().getChild(n) }

    string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result = generated.getName().(SymbolLiteral).getValueText() or
      result = generated.getName().(Generated::Setter).getName().getValue() + "="
    }

    final override Expr getExpr(int i) { result = generated.getChild(i) }

    final override string toString() { result = this.getName() }
  }
}

module Lambda {
  class Range extends Callable::Range, @lambda {
    final override Generated::Lambda generated;

    final override Parameter::Range getParameter(int n) {
      result = generated.getParameters().getChild(n)
    }

    final override string toString() { result = "-> { ... }" }
  }
}

module Block {
  abstract class Range extends Callable::Range { }
}

module DoBlock {
  class Range extends Block::Range, BodyStatement::Range, @do_block {
    final override Generated::DoBlock generated;

    final override Expr getExpr(int i) { result = generated.getChild(i) }

    final override Parameter::Range getParameter(int n) {
      result = generated.getParameters().getChild(n)
    }

    final override string toString() { result = "do ... end" }
  }
}

module BraceBlock {
  class Range extends Block::Range, @block {
    final override Generated::Block generated;

    final override Parameter::Range getParameter(int n) {
      result = generated.getParameters().getChild(n)
    }

    final override string toString() { result = "{ ... }" }
  }
}
