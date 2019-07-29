
class LambdaCapture extends @lambdacapture { string toString() { none() } }
class Lambda extends @lambdaexpr { string toString() { none() } }
class Field extends @membervariable { string toString() { none() } }
class Location extends @location_default { string toString() { none() } }
class Type extends @usertype { string toString() { none() } }

from LambdaCapture lc, Lambda l, int i, Field f,
     boolean captured_by_reference, boolean is_implicit,
     Location loc, Type t
where lambda_capture(lc, l, i, captured_by_reference, is_implicit, loc)
  and expr_types(l, t, _)
  and member(t, i, f)
select lc, l, i, f, captured_by_reference, is_implicit, loc

