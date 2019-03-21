import python
private import TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext2

class Value extends TObject {

    string toString() {
        result = this.(ObjectInternal).toString()
    }

    ControlFlowNode getAReferent() {
        PointsTo2::points_to(result, _, this, _)
    }

    predicate pointsTo(ControlFlowNode referent, PointsToContext2 context, ControlFlowNode origin) {
        PointsTo2::points_to(referent, context, this, origin)
    }

    Value getClass() {
        result = this.(ObjectInternal).getClass()
    }

    CallNode getACall() {
        PointsTo2::points_to(result.getFunction(), _, this, _)
        or
        exists(BoundMethodObjectInternal bm |
            PointsTo2::points_to(result.getFunction(), _, bm, _) and
            bm.getFunction() = this
        )
    }

    Value attr(string name) {
        this.(ObjectInternal).attribute(name, result, _)
    }

}
