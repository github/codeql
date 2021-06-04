import java
import semmle.code.java.dataflow.DataFlow

/**
 * Methods that trigger evaluation of an expression.
 */
class ExpressionEvaluationMethod extends Method {
  ExpressionEvaluationMethod() {
    getDeclaringType() instanceof Expression and
    (
      hasName("getValue") or
      hasName("getValueTypeDescriptor") or
      hasName("getValueType") or
      hasName("setValue")
    )
  }
}

/**
 * Holds if `node1` to `node2` is a dataflow step that converts `PropertyValues`
 * to an array of `PropertyValue`, i.e. `tainted.getPropertyValues()`.
 */
predicate getPropertyValuesStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    node1.asExpr() = ma.getQualifier() and
    node2.asExpr() = ma and
    m.getDeclaringType() instanceof PropertyValues and
    m.hasName("getPropertyValues")
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that constructs `MutablePropertyValues`,
 * i.e. `new MutablePropertyValues(tainted)`.
 */
predicate createMutablePropertyValuesStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof MutablePropertyValues |
    node1.asExpr() = cc.getAnArgument() and
    node2.asExpr() = cc
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that returns a name of `PropertyValue`,
 * i.e. `tainted.getName()`.
 */
predicate getPropertyNameStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    node1.asExpr() = ma.getQualifier() and
    node2.asExpr() = ma and
    m.getDeclaringType() instanceof PropertyValue and
    m.hasName("getName")
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that converts `MutablePropertyValues`
 * to a list of `PropertyValue`, i.e. `tainted.getPropertyValueList()`.
 */
predicate getPropertyValueListStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    node1.asExpr() = ma.getQualifier() and
    node2.asExpr() = ma and
    m.getDeclaringType() instanceof MutablePropertyValues and
    m.hasName("getPropertyValueList")
  )
}

/**
 * Holds if `node1` to `node2` is one of the dataflow steps that propagate
 * tainted data via Spring properties.
 */
predicate springPropertiesStep(DataFlow::Node node1, DataFlow::Node node2) {
  createMutablePropertyValuesStep(node1, node2) or
  getPropertyNameStep(node1, node2) or
  getPropertyValuesStep(node1, node2) or
  getPropertyValueListStep(node1, node2)
}

class PropertyValue extends RefType {
  PropertyValue() { hasQualifiedName("org.springframework.beans", "PropertyValue") }
}

class PropertyValues extends RefType {
  PropertyValues() { hasQualifiedName("org.springframework.beans", "PropertyValues") }
}

class MutablePropertyValues extends RefType {
  MutablePropertyValues() { hasQualifiedName("org.springframework.beans", "MutablePropertyValues") }
}

class SimpleEvaluationContext extends RefType {
  SimpleEvaluationContext() {
    hasQualifiedName("org.springframework.expression.spel.support", "SimpleEvaluationContext")
  }
}

class SimpleEvaluationContextBuilder extends RefType {
  SimpleEvaluationContextBuilder() {
    hasQualifiedName("org.springframework.expression.spel.support",
      "SimpleEvaluationContext$Builder")
  }
}

class Expression extends RefType {
  Expression() { hasQualifiedName("org.springframework.expression", "Expression") }
}

class ExpressionParser extends RefType {
  ExpressionParser() { hasQualifiedName("org.springframework.expression", "ExpressionParser") }
}
