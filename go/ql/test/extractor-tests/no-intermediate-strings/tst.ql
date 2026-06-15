import go

string checkStringValue(Expr e) {
  result = e.getStringValue()
  or
  not exists(e.getStringValue()) and result = "<no string value stored>"
}

from Expr e
where e.getType() instanceof StringType
// We should get string values for `"a"`, `"b"`, `"c"` and `"a" + "b" + "c"
// but not `"a" + "b"`. In the extractor we avoid storing the value of
// intermediate strings in string concatenations because in pathological cases
// this could lead to a quadratic blowup in the size of string values stored,
// which then causes performance problems when we iterate through all string
// values.
select e, checkStringValue(e)
