private import javascript
private import semmle.javascript.dataflow.internal.DataFlowNode

class Node = DataFlow::Node;

class PostUpdateNode = DataFlow::PostUpdateNode;

cached
predicate postUpdatePair(Node pre, Node post) {
  exists(AST::ValueNode expr |
    pre = TValueNode(expr) and
    post = TExprPostUpdateNode(expr)
  )
  or
  exists(NewExpr expr |
    pre = TConstructorThisArgumentNode(expr) and
    post = TValueNode(expr)
  )
  or
  exists(SuperCall expr |
    pre = TConstructorThisArgumentNode(expr) and
    post = TConstructorThisPostUpdate(expr.getBinder())
  )
  or
  exists(Function constructor |
    pre = TThisNode(constructor) and
    post = TConstructorThisPostUpdate(constructor)
  )
}
