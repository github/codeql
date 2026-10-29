import javascript

from ClassDefinition class_, FieldDefinition field
where
  class_.getAField() = field and
  field.isStatic() and
  field.getInit().getFirstControlFlowNode().getAPredecessor*() = class_
select field, "Field initializer occurs after its class is created"
