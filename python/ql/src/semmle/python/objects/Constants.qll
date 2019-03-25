import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.MRO2
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins


abstract class BooleanObjectInternal extends ObjectInternal {

    BooleanObjectInternal() {
        this = TTrue() or this = TFalse()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = true }


    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("bool"))
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        // Booleans aren't callable
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        // Booleans aren't callable
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

    override @py_object getSource() {
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

    override @py_object getSource() {
        result = Builtin::special("False")
    }

}

class NoneObjectInternal extends ObjectInternal, TNone {

    override string toString() {
        result = "None"
    }

    override boolean booleanValue() {
        result = false
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = true }


    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("NoneType"))
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        node.(NameNode).getId() = "None" and context.appliesTo(node)
    }

    override Builtin getBuiltin() {
        result = Builtin::special("None")
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        // None isn't callable
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        // None isn't callable
        none()
    }

    override ControlFlowNode getOrigin() {
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

    override predicate attributesUnknown() { none() }

    override @py_object getSource() {
        result = Builtin::special("None")
    }

    override boolean isDescriptor() { result = false }

    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

}


class IntObjectInternal extends ObjectInternal, TInt {

    override string toString() {
        result = "int " + this.intValue().toString()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        context.appliesTo(node) and
        node.getNode().(IntegerLiteral).getValue() = this.intValue()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = true }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("int"))
    }


    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        // ints aren't callable
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        // ints aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
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

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    override predicate attributesUnknown() { none() }

    override @py_object getSource() {
        result.(Builtin).intValue() = this.intValue()
    }

    override boolean isDescriptor() { result = false }

    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

}


class StringObjectInternal extends ObjectInternal, TString {

    override string toString() {
        result =  "'" + this.strValue() + "'"
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        context.appliesTo(node) and
        node.getNode().(StrConst).getText() = this.strValue()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = true }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("unicode"))
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        // strings aren't callable
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        // strings aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
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

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    override predicate attributesUnknown() { none() }

    override @py_object getSource() {
        result.(Builtin).strValue() = this.strValue()
    }

    override boolean isDescriptor() { result = false }

    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

}




