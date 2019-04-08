import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.MRO
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins



abstract class ConstantObjectInternal extends ObjectInternal {

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = true }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        // Constants aren't callable
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        // Constants aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    override predicate attributesUnknown() { none() }

    override boolean isDescriptor() { result = false }

    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

}

abstract class BooleanObjectInternal extends ConstantObjectInternal {

    BooleanObjectInternal() {
        this = TTrue() or this = TFalse()
    }


    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("bool"))
    }

}

class TrueObjectInternal extends BooleanObjectInternal, TTrue {

    override string toString() {
        result = "bool True"
    }

    override boolean booleanValue() {
        result = true
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        node.(NameNode).getId() = "True" and context.appliesTo(node)
    }

    override int intValue() {
        result = 1
    }

    override string strValue() {
        none()
    }

    override Builtin getBuiltin() {
        result = Builtin::special("True")
    }

}

class FalseObjectInternal extends BooleanObjectInternal, TFalse {

    override string toString() {
        result = "bool False"
    }

    override boolean booleanValue() {
        result = false
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        node.(NameNode).getId() = "False" and context.appliesTo(node)
    }

    override int intValue() {
        result = 0
    }

    override string strValue() {
        none()
    }

    override Builtin getBuiltin() {
        result = Builtin::special("False")
    }

}

class NoneObjectInternal extends ConstantObjectInternal, TNone {

    override string toString() {
        result = "None"
    }

    override boolean booleanValue() {
        result = false
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("NoneType"))
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        node.(NameNode).getId() = "None" and context.appliesTo(node)
    }

    override Builtin getBuiltin() {
        result = Builtin::special("None")
    }

    override int intValue() {
        none()
    }

    override string strValue() {
        none()
    }

}


class IntObjectInternal extends ConstantObjectInternal, TInt {

    override string toString() {
        result = "int " + this.intValue().toString()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        context.appliesTo(node) and
        node.getNode().(IntegerLiteral).getValue() = this.intValue()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("int"))
    }

    override Builtin getBuiltin() {
        result.intValue() = this.intValue()
    }

    override int intValue() {
        this = TInt(result)
    }

    override string strValue() {
        none()
    }

    override boolean booleanValue() {
        this.intValue() = 0 and result = false
        or
        this.intValue() != 0 and result = true
    }

}

class FloatObjectInternal extends ConstantObjectInternal, TFloat {

    override string toString() {
        result = "float " + this.floatValue().toString()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        context.appliesTo(node) and
        node.getNode().(FloatLiteral).getValue() = this.floatValue()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("float"))
    }

    override Builtin getBuiltin() {
        result.floatValue() = this.floatValue()
    }

    private float floatValue() {
        this = TFloat(result)
    }

    override int intValue() {
        this = TFloat(result)
    }

    override string strValue() {
        none()
    }

    override boolean booleanValue() {
        this.floatValue() = 0.0 and result = false
        or
        this.floatValue() != 0.0 and result = true
    }

}


class StringObjectInternal extends ConstantObjectInternal, TString {

    override string toString() {
        result =  "'" + this.strValue() + "'"
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        context.appliesTo(node) and
        node.getNode().(StrConst).getText() = this.strValue()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("unicode"))
    }

    override Builtin getBuiltin() {
        result.(Builtin).strValue() = this.strValue()
    }

    override int intValue() {
        none()
    }

    override string strValue() {
        this = TString(result)
    }

    override boolean booleanValue() {
        this.strValue() = "" and result = false
        or
        this.strValue() != "" and result = true
    }

}




