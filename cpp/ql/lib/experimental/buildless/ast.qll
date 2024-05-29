import compiled_ast
import ast_sig

module Buildless<BuildlessASTSig AST> {
  final class Node = AST::Node;

  class SourceElement extends Node {
    Location getLocation() { AST::nodeLocation(this, result) }

    string toString() { result = "element" }
  }

  class SourceFunction extends SourceElement {
    SourceFunction() { AST::function(this) }

    string getName() { AST::functionName(this, result) }

    override string toString() { result = getName() }

    BlockStmt getBody() { AST::functionBody(this, result) }

    VariableDeclaration getParameter(int i) { AST::functionParameter(this, i, result) }
  }

  class VariableDeclaration extends SourceElement {
    VariableDeclaration() { AST::variableDeclaration(this) }

    string getName() { AST::variableName(this, result) }

    override string toString() { result = getName() }
  }

  class SourceParameter extends VariableDeclaration {
    SourceFunction fn;
    int index;

    SourceParameter() { AST::functionParameter(fn, index, this) }
  }

  class Stmt extends SourceElement {
    Stmt() { AST::stmt(this) }

    override string toString() { result = "stmt" }
  }

  class BlockStmt extends Stmt {
    BlockStmt() { AST::blockStmt(this) }

    override string toString() { result = "{ ... }" }

    Stmt getChild(int i) { AST::blockMember(this, i, result) }
  }
}

module TestAST = Buildless<CompiledAST>;
