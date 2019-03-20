import python


private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext2
private import semmle.python.types.Builtins

class InstanceInternal extends TInstance, ObjectInternal {

    override string toString() {
        result = "instance of " + this.getClass().(ClassObjectInternal).getName()
    }

    /** The boolean value of this object, if it has one */
    override boolean booleanValue() {
        //this.getClass().instancesAlways(result)
        none()
    }

    /** Holds if this object may be true or false when evaluated as a bool */
    override predicate maybe() {
        // this.getClass().instancesMaybe()
        any()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        this = TInstance(node, _, context)
    }

    /** Gets the class declaration for this object, if it is a declared class. */
    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() {
        none()
    }

    override predicate notClass() {
        any()
    }

    override ObjectInternal getClass() {
        this = TInstance(_, result, _)
    }

    /** Holds if whatever this "object" represents can be meaningfully analysed for
     * truth or false in comparisons. For example, `None` or `int` can be, but `int()`
     * or an unknown string cannot.
     */
    override predicate isComparable() {
        none()
    }

    /** The negation of `isComparable()` */
    override predicate notComparable() {
        any()
    }

    /** Gets the `Builtin` for this object, if any.
     * All objects (except unknown and undefined values) should return 
     * exactly one result for either this method or `getOrigin()`.
     */
    override Builtin getBuiltin() {
        none()
    }

    /** Gets a control flow node that represents the source origin of this 
     * objects.
     * All objects (except unknown and undefined values) should return 
     * exactly one result for either this method or `getBuiltin()`.
     */
    override ControlFlowNode getOrigin() {
        this = TInstance(result, _, _)
    }

    /** Holds if `obj` is the result of calling `this` and `origin` is
     * the origin of `obj`.
     */
    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // In general instances aren't callable, but some are...
        // TO DO -- Handle cases where class overrides __call__
        none()
    }

    override int intValue() {
        none()
    }

    override string strValue() {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

}
