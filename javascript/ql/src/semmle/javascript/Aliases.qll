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
