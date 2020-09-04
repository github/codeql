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
