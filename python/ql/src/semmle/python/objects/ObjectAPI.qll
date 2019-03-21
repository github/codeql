import python
private import TObject
private import ObjectInternal
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

}
