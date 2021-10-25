import javascript
import semmle.javascript.dataflow.InferredTypes
import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps
import semmle.javascript.dataflow.internal.AbstractPropertiesImpl as AbstractPropertiesImpl
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

  override predicate shouldTrackProperties() {
    exists(DataFlow::PropWrite pwn |
      pwn.writes(node, "trackProps", any(BooleanLiteral l | l.getValue() = "true").flow())
    )
  }
}

boolean flowProps(AbstractValue val) {
  if FlowSteps::shouldTrackProperties(val) then result = true else result = false
}

boolean typeProps(AbstractValue val) {
  if AbstractPropertiesImpl::shouldTrackProperties(val) then result = true else result = false
}

from MyCustomAbstractValueDefinition def, AbstractValue val
where def.getAbstractValue() = val
select def, val, flowProps(val), typeProps(val)
