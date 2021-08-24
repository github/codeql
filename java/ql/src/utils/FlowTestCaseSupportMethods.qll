import java
private import semmle.code.java.dataflow.internal.DataFlowUtil
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.internal.FlowSummaryImpl
private import FlowTestCaseUtils

/**
 * Returns a valid Java token naming the field `fc`.
 */
private string getFieldToken(FieldContent fc) {
  result =
    fc.getField().getDeclaringType().getSourceDeclaration().getName() + "_" +
      fc.getField().getName()
}

/**
 * Returns a valid Java token naming the synthetic field `fc`,
 * assuming that the name of that field consists only of characters valid in a Java identifier and `.`.
 */
private string getSyntheticFieldToken(SyntheticFieldContent fc) {
  exists(string name, int parts |
    name = fc.getField() and
    parts = count(name.splitAt("."))
  |
    if parts = 1
    then result = name
    else result = name.splitAt(".", parts - 2) + "_" + name.splitAt(".", parts - 1)
  )
}

/**
 * Returns a token suitable for incorporation into a Java method name describing content `c`.
 */
string contentToken(Content c) {
  c instanceof ArrayContent and result = "ArrayElement"
  or
  c instanceof CollectionContent and result = "Element"
  or
  c instanceof MapKeyContent and result = "MapKey"
  or
  c instanceof MapValueContent and result = "MapValue"
  or
  result = getFieldToken(c)
  or
  result = getSyntheticFieldToken(c)
}

/**
 * Returns the `content` wrapped by `component`, if any.
 */
Content getContent(SummaryComponent component) { component = SummaryComponent::content(result) }
