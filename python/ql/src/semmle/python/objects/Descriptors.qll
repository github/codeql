import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.pointsto.MRO
private import semmle.python.types.Builtins

class PropertyInternal extends ObjectInternal, TProperty {

    override string toString() {
        result = "property" + this.getName()
    }

    override boolean booleanValue() { result = true }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        this = TProperty(node, context, _)
    }

    override ClassDecl getClassDeclaration() { none() }

    override boolean isClass() { result = false }

    override ObjectInternal getClass() { result = ObjectInternal::property() }

    CallableObjectInternal getGetter() {
        this = TProperty(_, _, result)
    }

    override boolean isComparable() { result = true }

    override Builtin getBuiltin() { none() }

    string getName() {
        result = this.getGetter().getName()
    }

    override ControlFlowNode getOrigin() { this = TProperty(result, _, _) }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) { none() }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

    override int intValue() { none() }

    override string strValue() { none() }

    override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate attributesUnknown() { none() }

    override boolean isDescriptor() { result = true }

    override int length() { none() }

    private Context getContext() { this = TProperty(_,result,  _) }

    CallableObjectInternal getSetter() {
        exists(CallNode call, AttrNode setter |
            call.getFunction() = setter and 
            PointsToInternal::pointsTo(setter.getObject("setter"), this.getContext(), this, _) and
            PointsToInternal::pointsTo(call.getArg(0), this.getContext(), result, _)
        )
    }

    override predicate binds(ObjectInternal cls, string name, ObjectInternal descriptor) { none() }

    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) {
        /* Just give an unknown value for now. We could improve this, but it would mean
         * changing Contexts to account for property accesses.
         */
        exists(AttrNode attr, ClassObjectInternal cls, string name |
            name = this.getName() and
            PointsToInternal::pointsTo(attr.getObject(name), _, instance, _) and
            instance.getClass() = cls and
            cls.lookup(name, this, _) and
            origin = CfgOrigin::fromCfgNode(attr) and value = ObjectInternal::unknown()
        )
    }

}

class ClassMethodObjectInternal extends ObjectInternal, TClassMethod {

    override string toString() {
        result = "classmethod(" + this.getFunction() + ")"
    }

    override boolean booleanValue() { result = true }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        exists(CallableObjectInternal function |
            this = TClassMethod(node, function) and
            class_method(node, function, context)
        )
    }

    CallableObjectInternal getFunction() {
        this = TClassMethod(_, result)
    }

    override ClassDecl getClassDeclaration() { none() }

    override boolean isClass() { result = false }

    override ObjectInternal getClass() { result = ObjectInternal::classMethod() }

    override boolean isComparable() { result = true }

    override Builtin getBuiltin() { none() }

    override ControlFlowNode getOrigin() { this = TClassMethod(result, _) }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) { none() }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

    override int intValue() { none() }

    override string strValue() { none() }

    override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate attributesUnknown() { none() }

    override boolean isDescriptor() { result = true }

    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) {
        any(ObjectInternal obj).binds(instance, _, this) and
        exists(ObjectInternal cls |
            instance.isClass() = false and cls = instance.getClass()
            or
            instance.isClass() = true and cls = instance
            |
            value = TBoundMethod(cls, this.getFunction()) and
            origin = CfgOrigin::unknown()
        )
    }

    override predicate binds(ObjectInternal cls, string name, ObjectInternal descriptor) {
        descriptor = this.getFunction() and
        exists(ObjectInternal instance |
            any(ObjectInternal obj).binds(instance, name, this) |
            instance.isClass() = false and cls = instance.getClass()
            or
            instance.isClass() = true and cls = instance
        )
    }

    override int length() { none() }

}

class StaticMethodObjectInternal extends ObjectInternal, TStaticMethod {

    override string toString() {
        result = "staticmethod()"
    }

    override boolean booleanValue() { result = true }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        exists(CallableObjectInternal function |
            this = TStaticMethod(node, function) and
            static_method(node, function, context)
        )
    }

    CallableObjectInternal getFunction() {
        this = TStaticMethod(_, result)
    }

    override ClassDecl getClassDeclaration() { none() }

    override boolean isClass() { result = false }

    override ObjectInternal getClass() { result = ObjectInternal::builtin("staticmethod") }

    override boolean isComparable() { result = true }

    override Builtin getBuiltin() { none() }

    override ControlFlowNode getOrigin() { this = TStaticMethod(result, _) }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) { none() }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

    override int intValue() { none() }

    override string strValue() { none() }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        this.getFunction().calleeAndOffset(scope, paramOffset)
    }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate attributesUnknown() { none() }

    override boolean isDescriptor() { result = true }

    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) {
        any(ObjectInternal obj).binds(instance, _, this) and
        value = this.getFunction() and origin = CfgOrigin::unknown()
    }

    override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

    override int length() { none() }

}
