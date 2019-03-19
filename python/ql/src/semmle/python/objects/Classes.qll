import python


private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext2
private import semmle.python.types.Builtins


abstract class ClassObjectInternal extends ObjectInternal {

    override boolean booleanValue() {
        result = true
    }

    override predicate maybe() { none() }

    override predicate isClass() { any() }

    override predicate notClass() { none() }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // TO DO .. Result should (in most cases) be an instance
        none()
    }

}

class PythonClassObjectInternal extends ClassObjectInternal, TPythonClassObject {

    Class getScope() {
        exists(ClassDef def |
            this = TPythonClassObject(def.getAFlowNode()) and
            result = def.getDefinedClass()
        )
    }

    override string toString() {
        result = this.getScope().toString()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        exists(DefinitionNode def |
            this = TPythonClassObject(def) and 
            node = def.getValue() and
            context.appliesTo(node)
        )
    }

    override ClassDecl getClassDeclaration() {
        this = TPythonClassObject(result)
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("FunctionType"))
    }

    override Builtin getBuiltin() {
        none()
    }

    override ControlFlowNode getOrigin() {
        this = TPythonClassObject(result)
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        exists(PythonFunctionObjectInternal init |
            // TO DO... Lookup init...
            none() |
            init.getScope() = scope and paramOffset = 1
        )
    }

}

class BuiltinClassObjectInternal extends ClassObjectInternal, TBuiltinClassObject {

    override Builtin getBuiltin() {
        this = TBuiltinClassObject(result)
    }

    override string toString() {
        result = "builtin class " + this.getBuiltin().getName()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override ClassDecl getClassDeclaration() {
        this = TBuiltinClassObject(result)
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}
