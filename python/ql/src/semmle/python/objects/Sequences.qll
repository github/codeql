
import python




private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext
private import semmle.python.pointsto.MRO2
private import semmle.python.types.Builtins

abstract class SequenceObjectInternal extends ObjectInternal {

    abstract ObjectInternal getItem(int n);

    abstract int length();

    /** The boolean value of this object, this may be both
     * true and false if the "object" represents a set of possible objects. */
    override boolean booleanValue() {
        this.length() = 0 and result = false
        or
        this.length() != 0 and result = true
    }

    override boolean isDescriptor() { result = false }

    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

}

abstract class TupleObjectInternal extends SequenceObjectInternal {

    override string toString() {
        result = "tuple()"
    }

    /** Gets the class declaration for this object, if it is a declared class. */
    override ClassDecl getClassDeclaration() { none() }

    /** True if this "object" is a class. */
    override boolean isClass() { result = false }

    override ObjectInternal getClass() { result = ObjectInternal::builtin("tuple") }

    /** True if this "object" can be meaningfully analysed for
     * truth or false in comparisons. For example, `None` or `int` can be, but `int()`
     * or an unknown string cannot.
     */
    override boolean isComparable() { result = true }

    /** Holds if `obj` is the result of calling `this` and `origin` is
     * the origin of `obj`.
     */
    override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

    /** Holds if `obj` is the result of calling `this` and `origin` is
     * the origin of `obj` with callee context `callee`.
     */
    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) { none() }

    /** The integer value of things that have integer values.
     * That is, ints and bools.
     */
    override int intValue() { none() }

    /** The integer value of things that have integer values.
     * That is, strings.
     */
    override string strValue() { none() }

    override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate attributesUnknown() { none() }

}

class BuiltinTupleObjectInternal extends TBuiltinTuple, TupleObjectInternal {

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        none()
    }

    override Builtin getBuiltin() {
        this = TBuiltinTuple(result)
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override ObjectInternal getItem(int n) {
        result.getBuiltin() = this.getBuiltin().getItem(n)
    }

    override int length() {
        exists(Builtin b |
            b = this.getBuiltin() and
            result = count(int n | exists(b.getItem(n)))
        )
    }
}


class PythonTupleObjectInternal extends TPythonTuple, TupleObjectInternal {

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        this = TPythonTuple(node, context)
    }

    override Builtin getBuiltin() {
        none()
    }

    override ControlFlowNode getOrigin() {
        this = TPythonTuple(result, _)
    }

    override ObjectInternal getItem(int n) {
        exists(TupleNode t, PointsToContext context |
            this = TPythonTuple(t, context) and
            PointsTo2::pointsTo(t.getElement(n), context, result, _)
        )
    }

    override int length() {
        exists(TupleNode t |
            this = TPythonTuple(t, _) and
            result = count(int n | exists(t.getElement(n)))
        )
    }

}


