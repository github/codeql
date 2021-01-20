private import codeql_ruby.AST
private import TreeSitter

module Callable {
  abstract class Range extends AstNode {
    abstract Parameter getParameter(int n);
  }
}

module Method {
  class Range extends Callable::Range, @method {
    final override Generated::Method generated;

    override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }

    string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result = generated.getName().(SymbolLiteral).getValueText() or
      result = generated.getName().(Generated::Setter).getName().getValue() + "="
    }
  }
}

module SingletonMethod {
  class Range extends Callable::Range, @singleton_method {
    final override Generated::SingletonMethod generated;

    override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }

    string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result = generated.getName().(SymbolLiteral).getValueText() or
      result = generated.getName().(Generated::Setter).getName().getValue() + "="
    }
  }
}

module Lambda {
  class Range extends Callable::Range, @lambda {
    final override Generated::Lambda generated;

    final override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
  }
}

module Block {
  abstract class Range extends Callable::Range {
    Generated::BlockParameters params;

    final override Parameter getParameter(int n) { result = params.getChild(n) }
  }
}

module DoBlock {
  class Range extends Block::Range, @do_block {
    final override Generated::DoBlock generated;

    Range() { params = generated.getParameters() }
  }
}

module BraceBlock {
  class Range extends Block::Range, @block {
    final override Generated::Block generated;

    Range() { params = generated.getParameters() }
  }
}
