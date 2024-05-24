import cpp
import ast_sig

module CompiledAST implements BuildlessASTSig {
  private newtype TNode = TFunction(Function fn) { any() }
  or TStatement(Stmt stmt) { any() }

  abstract class Node extends TNode {
    abstract string toString();
    abstract Location getLocation();
    string getName() { none() }
    Node getBody() { none() }
  }

  private class FunctionNode extends Node, TFunction {
    Function function;
    FunctionNode() { this = TFunction(function) } 

    override string toString() { result = function.toString() }
    override Location getLocation() { result = function.getLocation() }

    override string getName() { result = function.getName() }

    override Node getBody() { result = TStatement(function.getBlock()) }
  }

  private class StatementNode extends Node, TStatement {
    Stmt statement;
    StatementNode() { this = TStatement(statement) }

    override string toString() { result = statement.toString() }
    override Location getLocation() { result = statement.getLocation() }
  }

  predicate isFunction(Node node) { node instanceof FunctionNode }

  predicate isStatement(Node node) { node instanceof StatementNode }

  string getName(Node node) { result = node.getName() }

  Node getBody(Node node) { result = node.getBody() }
}
