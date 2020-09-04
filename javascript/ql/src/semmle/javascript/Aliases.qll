/**
 * Provides aliases for commonly used classes that have different names
 * in the QL libraries for other languages.
 */

import javascript

class AndBitwiseExpr = BitAndExpr;

class AndLogicalExpr = LogAndExpr;

class ArrayAccess = IndexExpr;

class AssignOp = CompoundAssignExpr;

class Block = BlockStmt;

class BoolLiteral = BooleanLiteral;

class CaseStmt = Case;

class ComparisonOperation = Comparison;

class DoStmt = DoWhileStmt;

class EqualityOperation = EqualityTest;

class FieldAccess = DotExpr;

class InstanceOfExpr = InstanceofExpr;

class LabelStmt = LabeledStmt;

class LogicalAndExpr = LogAndExpr;

class LogicalNotExpr = LogNotExpr;

class LogicalOrExpr = LogOrExpr;

class Loop = LoopStmt;

class MultilineComment = BlockComment;

class OrBitwiseExpr = BitOrExpr;

class OrLogicalExpr = LogOrExpr;

class ParenthesisExpr = ParExpr;

class ParenthesizedExpr = ParExpr;

class RelationalOperation = RelationalComparison;

class RemExpr = ModExpr;

class SingleLineComment = LineComment;

class SuperAccess = SuperExpr;

class SwitchCase = Case;

class ThisAccess = ThisExpr;

class VariableAccess = VarAccess;

class XorBitwiseExpr = XOrExpr;

// Aliases for deprecated predicates from the dbscheme
 
/**
 * Alias for the predicate `is_externs` defined in the .dbscheme.
 * Use `TopLevel#isExterns()` instead.
 */ 
deprecated predicate isExterns(TopLevel toplevel) { is_externs(toplevel) }
/**
 * Alias for the predicate `is_module` defined in the .dbscheme.
 * Use the `Module` class in `Module.qll` instead.
 */ 
deprecated predicate isModule(TopLevel toplevel) { is_module(toplevel) }
/**
 * Alias for the predicate `is_nodejs` defined in the .dbscheme.
 * Use `NodeModule` from `NodeJS.qll` instead.
 */ 
deprecated predicate isNodejs(TopLevel toplevel) { is_nodejs(toplevel) }
/**
 * Alias for the predicate `is_es2015_module` defined in the .dbscheme.
 * Use `ES2015Module` from `ES2015Modules.qll` instead.
 */ 
deprecated predicate isES2015Module(TopLevel toplevel) { is_es2015_module(toplevel) }
/**
 * Alias for the predicate `is_closure_module` defined in the .dbscheme.
 */ 
deprecated predicate isClosureModule(TopLevel toplevel) { is_closure_module(toplevel) }
/**
 * Alias for the predicate `stmt_containers` defined in the .dbscheme.
 * Use `ASTNode#getContainer()` instead.
 */ 
deprecated predicate stmtContainers(Stmt stmt, StmtContainer container) { stmt_containers(stmt, container) }
/**
 * Alias for the predicate `jump_targets` defined in the .dbscheme.
 * Use `JumpStmt#getTarget()` instead.
 */ 
deprecated predicate jumpTargets(Stmt jump, Stmt target) { jump_targets(jump, target) }
/**
 * Alias for the predicate `is_instantiated` defined in the .dbscheme.
 * Use `NamespaceDeclaration#isInstantiated() instead.`
 */ 
deprecated predicate isInstantiated(NamespaceDeclaration decl) { is_instantiated(decl) }
/**
 * Alias for the predicate `has_declare_keyword` defined in the .dbscheme.
 */ 
deprecated predicate hasDeclareKeyword(ASTNode stmt) { has_declare_keyword(stmt) }
/**
 * Alias for the predicate `is_for_await_of` defined in the .dbscheme.
 * Use `ForOfStmt#isAwait()` instead.
 */ 
deprecated predicate isForAwaitOf(ForOfStmt forof) { is_for_await_of(forof) }
/**
 * Alias for the predicate `enclosing_stmt` defined in the .dbscheme.
 * Use `ExprOrType#getEnclosingStmt` instead.
 */ 
deprecated predicate enclosingStmt(ExprOrType expr, Stmt stmt) { enclosing_stmt(expr, stmt) }
/**
 * Alias for the predicate `expr_containers` defined in the .dbscheme.
 * Use `ASTNode#getContainer()` instead.
 */ 
deprecated predicate exprContainers(ExprOrType expr, StmtContainer container) { expr_containers(expr, container) }
/**
 * Alias for the predicate `array_size` defined in the .dbscheme.
 * Use `ArrayExpr#getSize()` instead.
 */ 
deprecated predicate arraySize(Expr ae, int sz) { array_size(ae, sz) }
/**
 * Alias for the predicate `is_delegating` defined in the .dbscheme.
 * Use `YieldExpr#isDelegating()` instead.
 */ 
deprecated predicate isDelegating(YieldExpr yield) { is_delegating(yield) }
/**
 * Alias for the predicate `is_arguments_object` defined in the .dbscheme.
 * Use the `ArgumentsVariable` class instead.
 */ 
deprecated predicate isArgumentsObject(Variable id) { is_arguments_object(id) }
/**
 * Alias for the predicate `is_computed` defined in the .dbscheme.
 * Use the `isComputed()` method on the `MemberDeclaration`/`Property`/`PropertyPattern` class instead.
 */ 
deprecated predicate isComputed(Property prop) { is_computed(prop) }
/**
 * Alias for the predicate `is_method` defined in the .dbscheme.
 * Use the `isMethod()` method on the `MemberDeclaration`/`Property` class instead.
 */ 
deprecated predicate isMethod(Property prop) { is_method(prop) }
/**
 * Alias for the predicate `is_static` defined in the .dbscheme.
 * Use `MemberDeclaration#isStatic()` instead.
 */ 
deprecated predicate isStatic(Property prop) { is_static(prop) }
/**
 * Alias for the predicate `is_abstract_member` defined in the .dbscheme.
 * Use `MemberDeclaration#isAbstract()` instead.
 */ 
deprecated predicate isAbstractMember(Property prop) { is_abstract_member(prop) }
/**
 * Alias for the predicate `is_const_enum` defined in the .dbscheme.
 * Use `EnumDeclaration#isConst()` instead.
 */ 
deprecated predicate isConstEnum(EnumDeclaration id) { is_const_enum(id) }
/**
 * Alias for the predicate `is_abstract_class` defined in the .dbscheme.
 * Use `ClassDefinition#isAbstract()` instead.
 */ 
deprecated predicate isAbstractClass(ClassDeclStmt id) { is_abstract_class(id) }
/**
 * Alias for the predicate `has_public_keyword` defined in the .dbscheme.
 * Use `MemberDeclaration#hasPublicKeyword() instead.
 */ 
deprecated predicate hasPublicKeyword(Property prop) { has_public_keyword(prop) }
/**
 * Alias for the predicate `has_private_keyword` defined in the .dbscheme.
 * Use `MemberDeclaration#isPrivate() instead.
 */ 
deprecated predicate hasPrivateKeyword(Property prop) { has_private_keyword(prop) }
/**
 * Alias for the predicate `has_protected_keyword` defined in the .dbscheme.
 * Use `MemberDeclaration#isProtected() instead.
 */ 
deprecated predicate hasProtectedKeyword(Property prop) { has_protected_keyword(prop) }
/**
 * Alias for the predicate `has_readonly_keyword` defined in the .dbscheme.
 * Use `FieldDeclaration#isReadonly()` instead.
 */ 
deprecated predicate hasReadonlyKeyword(Property prop) { has_readonly_keyword(prop) }
/**
 * Alias for the predicate `has_type_keyword` defined in the .dbscheme.
 * Use the `isTypeOnly` method on the `ImportDeclaration`/`ExportDeclaration` classes instead.
 */ 
deprecated predicate hasTypeKeyword(ASTNode id) { has_type_keyword(id) }
/**
 * Alias for the predicate `is_optional_member` defined in the .dbscheme.
 * Use `FieldDeclaration#isOptional()` instead.
 */ 
deprecated predicate isOptionalMember(Property id) { is_optional_member(id) }
/**
 * Alias for the predicate `has_definite_assignment_assertion` defined in the .dbscheme.
 * Use the `hasDefiniteAssignmentAssertion` method on the `FieldDeclaration`/`VariableDeclarator` classes instead.
 */ 
deprecated predicate hasDefiniteAssignmentAssertion(ASTNode id) { has_definite_assignment_assertion(id) }
/**
 * Alias for the predicate `is_optional_parameter_declaration` defined in the .dbscheme.
 * Use `Parameter#isDeclaredOptional()` instead.
 */ 
deprecated predicate isOptionalParameterDeclaration(Parameter parameter) { is_optional_parameter_declaration(parameter) }
/**
 * Alias for the predicate `has_asserts_keyword` defined in the .dbscheme.
 * Use `PredicateTypeExpr#hasAssertsKeyword() instead.
 */ 
deprecated predicate hasAssertsKeyword(PredicateTypeExpr node) { has_asserts_keyword(node) }
