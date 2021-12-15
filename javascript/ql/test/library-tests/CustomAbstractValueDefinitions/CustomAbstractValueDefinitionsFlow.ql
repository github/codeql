import javascript
import semmle.javascript.dataflow.InferredTypes
import semmle.javascript.dataflow.CustomAbstractValueDefinitions

class MyCustomAbstractValueDefinition extends CustomAbstractValueDefinition {
  DataFlow::ValueNode node;

  MyCustomAbstractValueDefinition() {
    DataFlow::valueNode(this) = node and
    node instanceof DataFlow::ObjectLiteralNode and
    exists(DataFlow::PropWrite pwn |
      pwn.writes(node, "custom", any(BooleanLiteral l | l.getValue() = "true").flow())
    )
  }

  override boolean getBooleanValue() { result = true }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override InferredType getType() { result = TTObject() }

  override predicate shouldTrackProperties() { none() }
}

from AnalyzedValueNode n, MyCustomAbstractValueDefinition def, CustomAbstractValueFromDefinition val
where
  def.getAbstractValue() = val and
  n.getAValue() = val
select n, val
