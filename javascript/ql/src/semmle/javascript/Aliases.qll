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
