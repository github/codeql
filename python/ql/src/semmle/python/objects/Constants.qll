import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext2
private import semmle.python.types.Builtins


abstract class BooleanObjectInternal extends ObjectInternal {

    BooleanObjectInternal() {
        this = TTrue() or this = TFalse()
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("bool"))
    }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // Booleans aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}

class TrueObjectInternal extends BooleanObjectInternal, TTrue {

    override string toString() {
        result = "True"
    }

    override boolean booleanValue() {
        result = true
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        node.(NameNode).getId() = "True" and context.appliesTo(node)
    }

}

class FalseObjectInternal extends BooleanObjectInternal, TFalse {

    override string toString() {
        result = "False"
    }

    override boolean booleanValue() {
        result = false
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        node.(NameNode).getId() = "False" and context.appliesTo(node)
    }

}

class NoneObjectInternal extends ObjectInternal, TNone {

    override string toString() {
        result = "None"
    }

    override boolean booleanValue() {
        result = false
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("NoneType"))
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        node.(NameNode).getId() = "None" and context.appliesTo(node)
    }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // None isn't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}


class IntObjectInternal extends ObjectInternal, TInt {

    override string toString() {
        result = this.intValue().toString()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        context.appliesTo(node) and
        node.getNode().(IntegerLiteral).getValue() = this.intValue()
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("int"))
    }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // ints aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override int intValue() {
        this = TInt(result)
    }

    override boolean booleanValue() {
        this.intValue() = 0 and result = false
        or
        this.intValue() != 0 and result = true
    }

}


class StringObjectInternal extends ObjectInternal, TString {

    override string toString() {
        result =  "'" + this.strValue().toString() + "'"
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        context.appliesTo(node) and
        node.getNode().(StrConst).getText() = this.strValue()
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("str"))
    }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // strings aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
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




