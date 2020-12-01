import codeql_ruby.AST
private import codeql_ruby.Generated

abstract class CallableRange extends AstNode {
  abstract Parameter getParameter(int n);
}

private class MethodRange extends CallableRange, @method {
  final override Generated::Method generated;

  override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
}

private class SingletonMethodRange extends CallableRange, @singleton_method {
  final override Generated::SingletonMethod generated;

  override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
}

private class LambdaRange extends CallableRange, @lambda {
  final override Generated::Lambda generated;

  final override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
}

abstract class BlockRange extends CallableRange {
  Generated::BlockParameters params;

  final override Parameter getParameter(int n) { result = params.getChild(n) }
}

private class DoBlockRange extends BlockRange, @do_block {
  final override Generated::DoBlock generated;

  DoBlockRange() { params = generated.getParameters() }
}

private class BraceBlockRange extends BlockRange, @block {
  final override Generated::Block generated;

  BraceBlockRange() { params = generated.getParameters() }
}
