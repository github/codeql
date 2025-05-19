private import csharp as CS

class Node extends CS::ControlFlow::Node { }

class CallNode extends Node {
  CS::Call call;

  CallNode() { call = super.getAstNode() }

  Callable getARuntimeTarget() { result = call.getARuntimeTarget() }
}

class Callable = CS::Callable;
