import python

/* Parents */

/** Internal implementation class */
library class FunctionParent extends FunctionParent_ {

}

/** Internal implementation class */
library class ArgumentsParent extends ArgumentsParent_ {

}

/** Internal implementation class */
library class ExprListParent extends ExprListParent_ {

}

/** Internal implementation class */
library class ExprContextParent extends ExprContextParent_ {

}

/** Internal implementation class */
library class StmtListParent extends StmtListParent_ {

}

/** Internal implementation class */
library class StrListParent extends StrListParent_ {

}

/** Internal implementation class */
library class ExprParent extends ExprParent_ {

}

library class DictItem extends DictItem_, AstNode {

    override string toString() {
        result = DictItem_.super.toString()
    }

    override AstNode getAChildNode() { none() }

    override Scope getScope() { none() }

}

/** A comprehension part, the 'for a in seq' part of  [ a * a for a in seq ] */
class Comprehension extends Comprehension_, AstNode {

    /** Gets the scope of this comprehension */
    override Scope getScope() {
        /* Comprehensions exists only in Python 2 list comprehensions, so their scope is that of the list comp. */
        exists(ListComp l |
            this = l.getAGenerator() |
            result = l.getScope() 
        )
    }

    override string toString() {
        result = "Comprehension"
    }

    override Location getLocation() {
        result = Comprehension_.super.getLocation()
    }

    override AstNode getAChildNode() {
        result = this.getASubExpression()
    }

    Expr getASubExpression() {
        result = this.getIter() or
        result = this.getAnIf() or
        result = this.getTarget()
    }

}

class BytesOrStr extends BytesOrStr_ {

}

/** Part of a string literal formed by implicit concatenation.
 * For example the string literal "abc" expressed in the source as `"a" "b" "c"`
 * would be composed of three `StringPart`s.
 * 
 */
class StringPart extends StringPart_, AstNode {

    override Scope getScope() {
        exists(Bytes b | this = b.getAnImplicitlyConcatenatedPart() | result = b.getScope())
        or
        exists(Unicode u | this = u.getAnImplicitlyConcatenatedPart() | result = u.getScope())
    }

    override AstNode getAChildNode() {
        none()
    }

    override string toString() {
        result = StringPart_.super.toString()
    }

    override Location getLocation() {
        result = StringPart_.super.getLocation()
    }

}

class StringPartList extends StringPartList_ {

}

