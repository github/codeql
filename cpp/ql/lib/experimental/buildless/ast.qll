
import compiled_ast
import ast_sig

module Buildless<BuildlessASTSig AST>
{
    final class Node = AST::Node;

    class Function extends Node {
        Function() { AST::function(this) }

        string toString() { AST::functionName(this, result) }

        BlockStmt getBody() { AST::functionBody(this, result) }

        Location getLocation() { AST::nodeLocation(this, result) }
    }

    class Stmt extends Node {
        Stmt() { AST::stmt(this) }

        string toString() { result = "stmt" }

        Location getLocation() { AST::nodeLocation(this, result) }
    }

    class BlockStmt extends Stmt
    {
        BlockStmt()
        {
            AST::blockStmt(this)
        }

        override string toString() { result = "{ ... }" }
    }
}





module TestAST = Buildless<CompiledAST>;