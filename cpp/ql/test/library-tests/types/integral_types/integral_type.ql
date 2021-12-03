import cpp

string integralTypeKind(IntegralType t) {
  if exists(int kind | builtintypes(unresolveElement(t), _, kind, _, _, _))
  then
    exists(int kind | builtintypes(unresolveElement(t), _, kind, _, _, _) |
      result = (kind.toString() + " ").prefix(2)
    )
  else result = "--"
}

string getUnsignedType(IntegralType t) {
  if exists(t.getUnsigned())
  then result = t.getUnsigned().toString()
  else result = "<no unsigned equivalent>"
}

string describe(IntegralType t) {
  t instanceof MicrosoftInt8Type and
  result = "MicrosoftInt8Type"
  or
  t instanceof MicrosoftInt16Type and
  result = "MicrosoftInt16Type"
  or
  t instanceof MicrosoftInt32Type and
  result = "MicrosoftInt32Type"
  or
  t instanceof MicrosoftInt64Type and
  result = "MicrosoftInt64Type"
}

from
  IntegralType t, string tStr, string signed, string unsigned, string explicitlySigned,
  string explicitlyUnsigned, string implicitlySigned
where
  tStr = (t.toString() + "                  ").prefix(18) and
  (if t.isSigned() then signed = "signed" else signed = "------") and
  (if t.isUnsigned() then unsigned = "unsigned" else unsigned = "--------") and
  (
    if t.isExplicitlySigned()
    then explicitlySigned = "explicitlySigned"
    else explicitlySigned = "----------------"
  ) and
  (
    if t.isExplicitlyUnsigned()
    then explicitlyUnsigned = "explicitlyUnsigned"
    else explicitlyUnsigned = "------------------"
  ) and
  if t.isImplicitlySigned()
  then implicitlySigned = "implicitlySigned"
  else implicitlySigned = "----------------"
select integralTypeKind(t), tStr, signed, unsigned, explicitlySigned, explicitlyUnsigned,
  implicitlySigned, t.getSize(), t.getAlignment(), getUnsignedType(t), concat(describe(t), ", ")
