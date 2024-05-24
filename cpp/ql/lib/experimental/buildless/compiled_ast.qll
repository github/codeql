import cpp
import ast_sig

module CompiledAST implements BuildlessASTSig {
  private class SourceLocation extends Location {
    SourceLocation() { not this.hasLocationInfo(_, 0, 0, 0, 0) }
  }

  private newtype TNode =
    TFunction(SourceLocation loc) { exists(Function f | f.getLocation() = loc) } or
    TStatement(SourceLocation loc) { exists(Stmt s | s.getLocation() = loc) }

  abstract class Node extends TNode {
    abstract string toString();

    abstract Location getLocation();

    string getName() { none() }

    Node getBody() { none() }
  }

  private class FunctionNode extends Node, TFunction {
    Function function;

    FunctionNode() { this = TFunction(function.getLocation()) }

    override string toString() { result = function.toString() }

    override Location getLocation() { result = function.getLocation() }

    override string getName() { result = function.getName() }

    override Node getBody() { result = TStatement(function.getBlock().getLocation()) }
  }

  private class StatementNode extends Node, TStatement {
    Stmt statement;

    StatementNode() { this = TStatement(statement.getLocation()) }

    override string toString() { result = statement.toString() }

    override Location getLocation() { result = statement.getLocation() }

    Stmt getStmt() { result = statement }
  }

  predicate nodeLocation(Node node, Location location) { location = node.getLocation() }

  // Include graph
  predicate userInclude(Node include, string path) { none() }

  predicate systemInclude(Node include, string path) { none() }

  // Functions
  predicate function(Node fn) { fn instanceof FunctionNode }

  predicate functionBody(Node fn, Node body) { body = fn.getBody() }

  predicate functionReturn(Node fn, Node returnType) { none() }

  predicate functionName(Node fn, string name) { name = fn.getName() }

  predicate functionParameter(Node fn, int i, Node parameterDecl) { none() }

  // Statements
  predicate stmt(Node node) { node instanceof StatementNode }

  predicate blockStmt(Node stmt) { stmt.(StatementNode).getStmt() instanceof BlockStmt }

  predicate blockMember(Node stmt, int index, Node child) { none() }

  predicate ifStmt(Node stmt, Node condition, Node thenBranch) { none() }

  predicate ifStmt(Node tmt, Node condition, Node thenBranch, Node elseBranch) { none() }

  predicate whileStmt(Node stmt, Node condition, Node body) { none() }

  predicate doWhileStmt(Node stmt, Node condition, Node body) { none() }

  predicate forStmt(Node stmt, Node init, Node condition, Node update, Node body) { none() }

  predicate exprStmt(Node stmt, Node expr) { none() }

  predicate returnStmt(Node stmt, Node expr) { none() }

  predicate returnVoidStmt(Node stmt) { none() }

  // etc
  // Types
  predicate ptrType(Node type, Node element) { none() }

  predicate refType(Node type, Node element) { none() }

  predicate rvalueRefType(Node type, Node element) { none() }

  predicate arrayType(Node type, Node element, Node size) { none() }

  predicate arrayType(Node type, Node element) { none() }

  predicate typename(Node node, string name) { none() }

  predicate templated(Node node) { none() }

  predicate classOrStructDefinition(Node node) { none() }

  predicate classMember(Node classOrStruct, int child, Node member) { none() }

  // Templates
  predicate templateParameter(Node node, int i, Node parameter) { none() }

  predicate typeParameter(Node templateParameter, Node type, Node parameter) { none() }

  predicate typeParameterDefault(Node templateParameter, Node defaultTypeOrValue) { none() }

  // Declarations
  predicate variableDeclaration(Node decl) { none() }

  predicate variableDeclarationType(Node decl, Node type) { none() }

  predicate variableDeclarationEntry(Node decl, int index, Node entry) { none() }

  predicate variableDeclarationEntryInitializer(Node entry, Node initializer) { none() }

  predicate variableName(Node entry, string name) { none() }

  predicate ptrEntry(Node entry, Node element) { none() }

  predicate refEntry(Node entry, Node element) { none() }

  predicate rvalueRefEntry(Node entry, Node element) { none() }

  predicate arrayEntry(Node entry, Node element) { none() }

  // Expressions
  predicate expression(Node node) { none() }

  predicate prefixExpr(Node expr, string operator, Node operand) { none() }

  predicate postfixExpr(Node expr, Node operand, string operator) { none() }

  predicate binaryExpr(Node expr, Node lhs, string operator, Node rhs) { none() }

  predicate castExpr(Node expr, Node type, Node operand) { none() }

  predicate callExpr(Node call) { none() }

  predicate callArgument(Node call, int i, Node arg) { none() }

  predicate callReceiver(Node call, Node receiver) { none() }
}
