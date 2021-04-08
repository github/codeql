import python
import semmle.python.objects.ObjectInternal

string vrepr(Value v) {
  /* Work around differing names in 2/3 */
  not v = ObjectInternal::boundMethod() and result = v.toString()
  or
  v = ObjectInternal::boundMethod() and result = "builtin-class method"
}

from ControlFlowNode f, Context ctx, Value v, ControlFlowNode origin
where f.pointsTo(ctx, v, origin)
select f.getLocation(), f.toString(), ctx, vrepr(v), vrepr(v.getClass())
