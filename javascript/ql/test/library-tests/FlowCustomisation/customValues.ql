import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * A custom abstract value representing the DOM object `document`.
 */
class Document extends CustomAbstractValueTag {
  Document() { this = "document" }

  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result.getType() = TTString() }

  override string describe() { result = "document" }
}

/**
 * A custom abstract value representing the DOM object `document.all`,
 * which is falsy.
 *
 * Note that `getType()` isn't quite right, since `typeof document.all === 'undefined'`,
 * but that's fine for the purposes of this test.
 */
class DocumentAll extends CustomAbstractValueTag {
  DocumentAll() { this = "document.all" }

  override boolean getBooleanValue() { result = false }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result.getType() = TTString() }

  override string describe() { result = "document.all" }
}

class DocumentRef extends DataFlow::AnalyzedNode, DataFlow::ValueNode {
  override GlobalVarAccess astNode;

  DocumentRef() { astNode.getName() = "document" }

  override AbstractValue getALocalValue() {
    result = DataFlow::AnalyzedNode.super.getALocalValue() or
    result.(CustomAbstractValue).getTag() instanceof Document
  }
}

class DocumentAllRef extends DataFlow::AnalyzedNode, DataFlow::ValueNode {
  override PropAccess astNode;

  DocumentAllRef() { astNode.getPropertyName() = "all" }

  override AbstractValue getAValue() {
    result = DataFlow::AnalyzedNode.super.getAValue()
    or
    astNode.getBase().analyze().getALocalValue().(CustomAbstractValue).getTag() instanceof Document and
    result.(CustomAbstractValue).getTag() instanceof DocumentAll
  }
}

from VariableDeclarator vd, DataFlow::AnalyzedNode init
where init = vd.getInit().analyze()
select vd.getBindingPattern(), init, init.getAValue()
