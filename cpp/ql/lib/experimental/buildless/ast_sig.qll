import cpp

/*
    The syntax of a C++ program.
*/
signature module BuildlessASTSig
{
    class Node;
    predicate nodeLocation(Node node, Location location);

    // Include graph
    predicate userInclude(Node include, string path);
    predicate systemInclude(Node include, string path);

    // Functions
    predicate function(Node fn);
    predicate functionBody(Node fn, Node body);
    predicate functionReturn(Node fn, Node returnType);
    predicate functionName(Node fn, string name);
    predicate functionParameter(Node fn, int i, Node parameterDecl);

    // Statements
    predicate stmt(Node node);
    predicate blockStmt(Node stmt);
    predicate blockMember(Node stmt, int index, Node child);
    predicate ifStmt(Node stmt, Node condition, Node thenBranch);
    predicate ifStmt(Node tmt, Node condition, Node thenBranch, Node elseBranch);
    predicate whileStmt(Node stmt, Node condition, Node body);
    predicate doWhileStmt(Node stmt, Node condition, Node body);
    predicate forStmt(Node stmt, Node init, Node condition, Node update, Node body);
    predicate exprStmt(Node stmt, Node expr);
    predicate returnStmt(Node stmt, Node expr);
    predicate returnVoidStmt(Node stmt);
    // etc

    // Types
    predicate type(Node type);
    predicate ptrType(Node type, Node element);
    predicate refType(Node type, Node element);
    predicate constType(Node type, Node element);
    predicate rvalueRefType(Node type, Node element);
    predicate arrayType(Node type, Node element, Node size);
    predicate arrayType(Node type, Node element);
    predicate typename(Node node, string name);  // Any named type, including built-in types
    predicate templated(Node node);

    predicate classOrStructDefinition(Node node);
    predicate classMember(Node classOrStruct, int child, Node member);

    // Templates
    predicate templateParameter(Node node, int i, Node parameter);
    predicate typeParameter(Node templateParameter, Node type, Node parameter);
    predicate typeParameterDefault(Node templateParameter, Node defaultTypeOrValue);

    // Declarations
    predicate variableDeclaration(Node decl);
    predicate variableDeclarationType(Node decl, Node type);
    predicate variableDeclarationEntry(Node decl, int index, Node entry);
    predicate variableDeclarationEntryInitializer(Node entry, Node initializer);
    predicate variableName(Node entry, string name);
    predicate ptrEntry(Node entry, Node element);
    predicate refEntry(Node entry, Node element);
    predicate rvalueRefEntry(Node entry, Node element);
    predicate arrayEntry(Node entry, Node element);  // ?? Size

    // Expressions
    predicate expression(Node node);
    predicate prefixExpr(Node expr, string operator, Node operand);
    predicate postfixExpr(Node expr, Node operand, string operator);
    predicate binaryExpr(Node expr, Node lhs, string operator, Node rhs);
    predicate castExpr(Node expr, Node type, Node operand);
    predicate callExpr(Node call);
    predicate callArgument(Node call, int i, Node arg);
    predicate callReceiver(Node call, Node receiver);
    predicate accessExpr(Node expr, string name);
    predicate literal(Node expr, string value);
    predicate stringLiteral(Node expr, string value);
}
