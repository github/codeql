import ruby

////////////////////////////////////////////////////////////////////////////////
// Query predicates for various types of parameter
query predicate idParams(NamedParameter np, string name) { name = np.getName() }

query predicate blockParams(BlockParameter bp, string name) { name = bp.getName() }

query predicate patternParams(TuplePatternParameter tpp, Pattern child, int childIndex) {
  tpp.getElement(childIndex) = child
}

query predicate splatParams(SplatParameter sp, string name) { name = sp.getName() }

query predicate hashSplatParams(HashSplatParameter hsp, string name) { name = hsp.getName() }

query predicate keywordParams(KeywordParameter kp, string name, string defaultValueStr) {
  name = kp.getName() and
  if exists(kp.getDefaultValue())
  then defaultValueStr = kp.getDefaultValue().toString()
  else defaultValueStr = "(none)"
}

query predicate optionalParams(OptionalParameter op, string name, AstNode defaultValue) {
  name = op.getName() and
  defaultValue = op.getDefaultValue()
}

////////////////////////////////////////////////////////////////////////////////
// Query predicates for various contexts of parameters
query predicate paramsInMethods(Method m, int i, Parameter p, string pClass) {
  p = m.getParameter(i) and pClass = p.describeQlClass()
}

query predicate paramsInBlocks(Block b, int i, Parameter p, string pClass) {
  p = b.getParameter(i) and pClass = p.describeQlClass()
}

query predicate paramsInLambdas(Lambda l, int i, Parameter p, string pClass) {
  p = l.getParameter(i) and pClass = p.describeQlClass()
}

////////////////////////////////////////////////////////////////////////////////
// General query selecting all parameters
from Parameter p
select p, p.getPosition(), p.describeQlClass()
