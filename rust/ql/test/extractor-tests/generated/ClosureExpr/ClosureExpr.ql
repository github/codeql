// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

query predicate instances(
  ClosureExpr x, string isAsync__label, string isAsync, string isConst__label, string isConst,
  string isGen__label, string isGen, string isMove__label, string isMove, string isStatic__label,
  string isStatic
) {
  toBeTested(x) and
  not x.isUnknown() and
  isAsync__label = "isAsync:" and
  (if x.isAsync() then isAsync = "yes" else isAsync = "no") and
  isConst__label = "isConst:" and
  (if x.isConst() then isConst = "yes" else isConst = "no") and
  isGen__label = "isGen:" and
  (if x.isGen() then isGen = "yes" else isGen = "no") and
  isMove__label = "isMove:" and
  (if x.isMove() then isMove = "yes" else isMove = "no") and
  isStatic__label = "isStatic:" and
  if x.isStatic() then isStatic = "yes" else isStatic = "no"
}

query predicate getParamList(ClosureExpr x, ParamList getParamList) {
  toBeTested(x) and not x.isUnknown() and getParamList = x.getParamList()
}

query predicate getAttr(ClosureExpr x, int index, Attr getAttr) {
  toBeTested(x) and not x.isUnknown() and getAttr = x.getAttr(index)
}

query predicate getParam(ClosureExpr x, int index, Param getParam) {
  toBeTested(x) and not x.isUnknown() and getParam = x.getParam(index)
}

query predicate getBody(ClosureExpr x, Expr getBody) {
  toBeTested(x) and not x.isUnknown() and getBody = x.getBody()
}

query predicate getClosureBinder(ClosureExpr x, ClosureBinder getClosureBinder) {
  toBeTested(x) and not x.isUnknown() and getClosureBinder = x.getClosureBinder()
}

query predicate getRetType(ClosureExpr x, RetTypeRepr getRetType) {
  toBeTested(x) and not x.isUnknown() and getRetType = x.getRetType()
}
