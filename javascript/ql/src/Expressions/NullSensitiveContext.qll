import javascript




abstract class NullSensitiveContext extends Expr {
	abstract Expr getPrincipalArgument();
}



/*
 * _[prop]
 */

class IndexExprBase extends NullSensitiveContext, IndexExpr {
	
	override Expr getPrincipalArgument() { result = this.getBase() }
	
}



/*
 * obj[_]
 */

class IndexExprIndex extends NullSensitiveContext, IndexExpr {
	
	override Expr getPrincipalArgument() { result = this.getPropertyNameExpr() }
	
}



/*
 * _.prop
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
 * _ + expr
 */

class AddExprLeftOperand extends NullSensitiveContext, AddExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr + _
 */

class AddExprRightOperand extends NullSensitiveContext, AddExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ - expr
 */

class SubExprLeftOperand extends NullSensitiveContext, SubExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr - _
 */

class SubExprRightOperand extends NullSensitiveContext, SubExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ * expr
 */

class MulExprLeftOperand extends NullSensitiveContext, MulExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr * _
 */

class MulExprRightOperand extends NullSensitiveContext, MulExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ / expr
 */

class DivExprLeftOperand extends NullSensitiveContext, DivExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr / _
 */

class DivExprRightOperand extends NullSensitiveContext, DivExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ % expr
 */

class ModExprLeftOperand extends NullSensitiveContext, ModExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr % _
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
 * _ & expr
 */

class BitAndExprLeftOperand extends NullSensitiveContext, BitAndExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr & _
 */

class BitAndExprRightOperand extends NullSensitiveContext, BitAndExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ | expr
 */

class BitOrExprLeftOperand extends NullSensitiveContext, BitOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr | _
 */

class BitOrExprRightOperand extends NullSensitiveContext, BitOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ ^ expr
 */

class XOrExprLeftOperand extends NullSensitiveContext, XOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr ^ _
 */

class XOrExprRightOperand extends NullSensitiveContext, XOrExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ << expr
 */

class LShiftExprLeftOperand extends NullSensitiveContext, LShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr << _
 */

class LShiftExprRightOperand extends NullSensitiveContext, LShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ >> expr
 */

class RShiftExprLeftOperand extends NullSensitiveContext, RShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr >> _
 */

class RShiftExprRightOperand extends NullSensitiveContext, RShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * _ >>> expr
 */

class URShiftExprLeftOperand extends NullSensitiveContext, URShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getLeftOperand() }
	
}



/*
 * expr >>> _
 */

class URShiftExprRightOperand extends NullSensitiveContext, URShiftExpr {
	
	override Expr getPrincipalArgument() { result = this.getRightOperand() }
	
}



/*
 * ~expr
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