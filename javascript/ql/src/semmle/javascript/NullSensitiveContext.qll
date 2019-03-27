/**
 * Provides classes for working with contexts sensitive to containing null
 * and undefined.
 */

import javascript




/**
 * A `NullSensitiveContext` is a syntactic context in which neither null nor
 * undefined should occur, because the context is guaranteed to inspect its
 * content and thereby throw an error.
 * 
 * The expression found in that context is called the principal argument of
 * the context.
 * 
 * In examples, we denote the position of the principal argument by use of
 * an underscore. For example, in `_ + 0`, the context's principle argument
 * is the left operand of the addition.
 */

abstract class NullSensitiveContext extends Expr {
	abstract Expr getPrincipalArgument();
}



/*
 * _[p]
 */

class IndexExprBase extends NullSensitiveContext, IndexExpr {
	
	override Expr getPrincipalArgument() { result = this.getBase() }
	
}



/*
 * o[_]
 */

class IndexExprIndex extends NullSensitiveContext, IndexExpr {
	
	override Expr getPrincipalArgument() { result = this.getPropertyNameExpr() }
	
}



/*
 * _.p
 */

class DotExprBase extends NullSensitiveContext, DotExpr {
	
	override Expr getPrincipalArgument() { result = this.getBase() }
	
}
 
 
 
/*
 * new _
 */

class NewExprCallee extends NullSensitiveContext, NewExpr {
	
	override Expr getPrincipalArgument() { result = this.getCallee() }
	
}



/*
 * _(args)
 */

class CallExprCallee extends NullSensitiveContext, CallExpr {
	
	override Expr getPrincipalArgument() { result = this.getCallee() }
	
}



/*
 * _ + y
 */

class AddExprLeftOperand extends NullSensitiveContext, AddExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x + _
 */

class AddExprRightOperand extends NullSensitiveContext, AddExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ - y
 */

class SubExprLeftOperand extends NullSensitiveContext, SubExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x - _
 */

class SubExprRightOperand extends NullSensitiveContext, SubExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ * u
 */

class MulExprLeftOperand extends NullSensitiveContext, MulExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x * _
 */

class MulExprRightOperand extends NullSensitiveContext, MulExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ / y
 */

class DivExprLeftOperand extends NullSensitiveContext, DivExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x / _
 */

class DivExprRightOperand extends NullSensitiveContext, DivExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ % y
 */

class ModExprLeftOperand extends NullSensitiveContext, ModExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x % _
 */

class ModExprRightOperand extends NullSensitiveContext, ModExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * +_
 */

class PlusExprOperand extends NullSensitiveContext, PlusExpr {
	
	override Expr getPrincipalArgument() { result = this.getOperand() }
	
}



/*
 * -_
 */

class NegExprOperand extends NullSensitiveContext, NegExpr {
	
	override Expr getPrincipalArgument() { result = this.getOperand() }
	
}



/*
 * ++_
 */

class PreIncExprOperand extends NullSensitiveContext, PreIncExpr {
	
	override Expr getPrincipalArgument() { result = this.getOperand() }
	
}



/*
 * _++
 */

class PostIncExprOperand extends NullSensitiveContext, PostIncExpr {
	
	override Expr getPrincipalArgument() { result = this.getOperand() }
	
}



/*
 * --_
 */

class PreDecExprOperand extends NullSensitiveContext, PreDecExpr {
	
	override Expr getPrincipalArgument() { result = this.getOperand() }
	
}



/*
 * _--
 */

class PostDecExprOperand extends NullSensitiveContext, PostDecExpr {
	
	override Expr getPrincipalArgument() { result = this.getOperand() }
	
}



/*
 * _ += y
 */

class AssignAddExprLhs extends NullSensitiveContext, AssignAddExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x += _
 */

class AssignAddExprRhs extends NullSensitiveContext, AssignAddExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ -= y
 */

class AssignSubExprLhs extends NullSensitiveContext, AssignSubExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x -= _
 */

class AssignSubExprRhs extends NullSensitiveContext, AssignSubExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ *= y
 */

class AssignMulExprLhs extends NullSensitiveContext, AssignMulExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x *= _
 */

class AssignMulExprRhs extends NullSensitiveContext, AssignMulExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ /= y
 */

class AssignDivExprLhs extends NullSensitiveContext, AssignDivExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x /= _
 */

class AssignDivExprRhs extends NullSensitiveContext, AssignDivExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ %= y
 */

class AssignModExprLhs extends NullSensitiveContext, AssignModExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x %= _
 */

class AssignModExprRhs extends NullSensitiveContext, AssignModExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ & y
 */

class BitAndExprLeftOperand extends NullSensitiveContext, BitAndExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x & _
 */

class BitAndExprRightOperand extends NullSensitiveContext, BitAndExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ | y
 */

class BitOrExprLeftOperand extends NullSensitiveContext, BitOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x | _
 */

class BitOrExprRightOperand extends NullSensitiveContext, BitOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ ^ y
 */

class XOrExprLeftOperand extends NullSensitiveContext, XOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x ^ _
 */

class XOrExprRightOperand extends NullSensitiveContext, XOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ << y
 */

class LShiftExprLeftOperand extends NullSensitiveContext, LShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x << _
 */

class LShiftExprRightOperand extends NullSensitiveContext, LShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ >> y
 */

class RShiftExprLeftOperand extends NullSensitiveContext, RShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x >> _
 */

class RShiftExprRightOperand extends NullSensitiveContext, RShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ >>> y
 */

class URShiftExprLeftOperand extends NullSensitiveContext, URShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * x >>> _
 */

class URShiftExprRightOperand extends NullSensitiveContext, URShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * ~_
 */

class BitNotExprOperand extends NullSensitiveContext, BitNotExpr {
	
	override Expr getPrincipalArgument() { result = this.getOperand() }
	
}



/*
 * _ &= y
 */

class AssignAndExprLhs extends NullSensitiveContext, AssignAndExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x &= _
 */

class AssignAndExprRhs extends NullSensitiveContext, AssignAndExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ |= y
 */

class AssignOrExprLhs extends NullSensitiveContext, AssignOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x |= _
 */

class AssignOrExprRhs extends NullSensitiveContext, AssignOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ ^= y
 */

class AssignXOrExprLhs extends NullSensitiveContext, AssignXOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x ^= _
 */

class AssignXOrExprRhs extends NullSensitiveContext, AssignXOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ <<= y
 */

class AssignLShiftExprLhs extends NullSensitiveContext, AssignLShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x <<= _
 */

class AssignLShiftExprRhs extends NullSensitiveContext, AssignLShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ >>= y
 */

class AssignRShiftExprLhs extends NullSensitiveContext, AssignRShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x >>= _
 */

class AssignRShiftExprRhs extends NullSensitiveContext, AssignRShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * _ >>>= y
 */

class AssignURShiftExprLhs extends NullSensitiveContext, AssignURShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLhs() }
	
}



/*
 * x >>>= _
 */

class AssignURShiftExprRhs extends NullSensitiveContext, AssignURShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * pat = _
 */

class DestructuringAssignExprRhs extends NullSensitiveContext, AssignExpr {
	
	DestructuringAssignExprRhs() { this.getLhs() instanceof DestructuringPattern }
	
	override Expr getPrincipalArgument() { result = this.getRhs() }
	
}



/*
 * [..._]
 */

class SpreadElementOperand extends NullSensitiveContext, SpreadElement {
	
	override Expr getPrincipalArgument() { result = this.getOperand() }
	
}