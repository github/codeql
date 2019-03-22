import python


private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins

class SpecificInstanceInternal extends TSpecificInstance, ObjectInternal {

    override string toString() {
        result = this.getOrigin().getNode().toString()
    }

    /** The boolean value of this object, if it has one */
    override boolean booleanValue() {
        //result = this.getClass().instancesBooleanValue()
        result = maybe()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        this = TSpecificInstance(node, _, context)
    }

    /** Gets the class declaration for this object, if it is a declared class. */
    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = false }

    override ObjectInternal getClass() {
        this = TSpecificInstance(_, result, _)
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
        this = TSpecificInstance(result, _, _)
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        none()
    }

     override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
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

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    override predicate attributesUnknown() { any() }

}

/** Represents a value that has a known class, but no other information */
class UnknownInstanceInternal extends TUnknownInstance, ObjectInternal {

    override string toString() {
        result = "instance of " + this.getClass().(ClassObjectInternal).getName()
    }

    /** The boolean value of this object, if it has one */
    override boolean booleanValue() {
        //result = this.getClass().instancesBooleanValue()
        result = maybe()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        context.appliesTo(node) and
        this.getClass() = ObjectInternal::builtin("float") and 
        node.getNode() instanceof FloatLiteral
    }

    /** Gets the class declaration for this object, if it is a declared class. */
    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = false }

    override ObjectInternal getClass() {
        this = TUnknownInstance(result)
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
        none()
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
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

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    override predicate attributesUnknown() { any() }

}


class SuperInstance extends TSuperInstance, ObjectInternal {

    override string toString() {
        result = "super()"
    }

    override boolean booleanValue() { result = true }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        exists(ObjectInternal self, ClassObjectInternal startclass |
            super_instantiation(node, self, startclass, context) and
            this = TSuperInstance(self, startclass)
        )
    }

    ClassObjectInternal getStartClass() {
        this = TSuperInstance(_, result)
    }

    ObjectInternal getSelf() {
        this = TSuperInstance(result, _)
    }

    override ClassDecl getClassDeclaration() { none() }

    override boolean isClass() { result = false }

    override ObjectInternal getClass() {
        result = ObjectInternal::builtin("super")
    }

    override boolean isComparable() { none() }

    override Builtin getBuiltin() { none() }

    override ControlFlowNode getOrigin() {
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) { none() }

    override int intValue() { none() }

    override string strValue() { none() }

    override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate attributesUnknown() { none() }

}




