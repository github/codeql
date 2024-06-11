import CompiledAST
import ASTSig

module BuildlessAST<BuildlessASTSig AST> {
  final class Node = AST::Node;

  // Any node in the abstract syntax tree
  class SourceElement extends Node {
    Location getLocation() { AST::nodeLocation(this, result) }

    string toString() { result = "element" }

    SourceElement getParent() { AST::edge(result, _, this) }

    SourceElement getChild(int i) { AST::edge(this, i, result) }

    SourceElement getAChild() { result = this.getChild(_) }
  }

  bindingset[path]
  private File getAnIncludeTarget(string path) {
    exists(string p | p = result.toString() | path = p.suffix(p.length() - path.length()))
  }

  class Include extends SourceElement {
    string path;

    Include() { AST::userInclude(this, path) or AST::systemInclude(this, path) }

    File getATarget() {
      result = getAnIncludeTarget(path)
      or
      path.prefix(3) = "../" and result = getAnIncludeTarget(path.suffix(3))
      or
      path.prefix(2) = "./" and result = getAnIncludeTarget(path.suffix(2))
    }

    predicate isSystemInclude() { AST::systemInclude(this, _) }

    predicate isUserInclude() { AST::userInclude(this, _) }

    override string toString() {
      this.isSystemInclude() and result = "#include <" + path + ">"
      or
      this.isUserInclude() and result = "#include \"" + path + "\""
    }
  }

  abstract class SourceScope extends SourceElement { }

  class SourceNamespace extends SourceScope, SourceDeclaration {
    SourceNamespace() { AST::namespace(this) }

    override string getName() { AST::namespaceName(this, result) }

    override string toString() { result = "namespace " + this.getName() }
  }

  // Any syntax node that is a declaration
  abstract class SourceDeclaration extends SourceElement {
    abstract string getName();
  }

  // A syntax node that declares or defines a function
  class SourceFunction extends SourceDeclaration {
    SourceFunction() { AST::function(this) }

    override string getName() { AST::functionName(this, result) }

    override string toString() { result = this.getName() }

    BlockStmt getBody() { AST::functionBody(this, result) }

    SourceParameter getParameter(int i) { AST::functionParameter(this, i, result) }

    SourceType getReturnType() { AST::functionReturn(this, result) }

    predicate isDefinition() { AST::functionDefinition(this) }
  }

  // A syntax node that declares a variable (including fields and parameters)
  class SourceVariableDeclaration extends SourceDeclaration {
    SourceVariableDeclaration() { AST::variableDeclaration(this) }

    override string getName() { AST::variableName(this, result) }

    override string toString() { result = this.getName() }

    SourceType getType() { AST::variableDeclarationType(this, result) }
  }

  // A syntax node that declares a parameter
  class SourceParameter extends SourceVariableDeclaration {
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
  }

  class Expr extends SourceElement {
    Expr() { AST::expression(this) }
  }

  class AccessExpr extends Expr {
    string identifier;

    AccessExpr() { AST::accessExpr(this, identifier) }

    string getName() { result = identifier }

    override string toString() { result = this.getName() }
  }

  class CallExpr extends Expr {
    CallExpr() { AST::callExpr(this) }

    Expr getReceiver() { AST::callReceiver(this, result) }

    Expr getArgument(int i) { AST::callArgument(this, i, result) }

    override string toString() { result = "...(...)" }
  }

  class Literal extends Expr {
    string value;

    Literal() { AST::literal(this, value) }

    override string toString() { result = value }

    string getValue() { result = value }
  }

  class StringLiteral extends Literal {
    StringLiteral() { AST::stringLiteral(this, _) }
  }

  abstract class SourceDefinition extends SourceDeclaration { }

  class SourceTypeDefinition extends SourceDefinition {
    SourceTypeDefinition() { AST::classOrStructDefinition(this) }

    override string getName() { AST::typename(this, result) }

    override string toString() { result = this.getName() }

    SourceElement getAMember() { AST::classMember(this, _, result) }

    predicate isDefinition() { AST::typeDefinition(this) }
  }

  // A node that contains a type of some kind
  class SourceType extends SourceElement {
    SourceType() { AST::type(this) }

    override string toString() { AST::typename(this, result) }
  }

  class SourcePointer extends SourceType {
    SourceType pointee;

    SourcePointer() { AST::ptrType(this, pointee) }

    SourceType getType() { result = pointee }
  }

  class SourceConst extends SourceType {
    SourceType type;

    SourceConst() { AST::constType(this, type) }

    SourceType getType() { result = type }
  }

  class SourceReference extends SourceType {
    SourceType type;

    SourceReference() { AST::refType(this, type) }

    SourceType getType() { result = type }
  }
}

module TestAST = BuildlessAST<CompiledAST>;
