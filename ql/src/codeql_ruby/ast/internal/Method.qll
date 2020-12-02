import codeql_ruby.AST
private import TreeSitter

abstract class CallableRange extends AstNode {
  abstract Parameter getParameter(int n);
}

class MethodRange extends CallableRange, @method {
  final override Generated::Method generated;

  override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }

  string getName() {
    result = generated.getName().(Generated::Token).getValue() or
    // TODO: use hand-written Symbol class
    result = generated.getName().(Generated::Symbol).toString() or
    result = generated.getName().(Generated::Setter).getName().getValue() + "="
  }
}

class SingletonMethodRange extends CallableRange, @singleton_method {
  final override Generated::SingletonMethod generated;

  override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }

  string getName() {
    result = generated.getName().(Generated::Token).getValue() or
    // TODO: use hand-written Symbol class
    result = generated.getName().(Generated::Symbol).toString() or
    result = generated.getName().(Generated::Setter).getName().getValue() + "="
  }
}

class LambdaRange extends CallableRange, @lambda {
  final override Generated::Lambda generated;

  final override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
}

abstract class BlockRange extends CallableRange {
  Generated::BlockParameters params;

  final override Parameter getParameter(int n) { result = params.getChild(n) }
}

class DoBlockRange extends BlockRange, @do_block {
  final override Generated::DoBlock generated;

  DoBlockRange() { params = generated.getParameters() }
}

class BraceBlockRange extends BlockRange, @block {
  final override Generated::Block generated;

  BraceBlockRange() { params = generated.getParameters() }
}
