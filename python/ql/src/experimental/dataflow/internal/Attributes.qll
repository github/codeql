/** This module provides an API for attribute reads and writes. */

import DataFlowUtil
import DataFlowPublic
private import DataFlowPrivate

/**
 * A data flow node that reads or writes an attribute of an object.
 *
 * This abstract base class only knows about the base object on which the attribute is being
 * accessed, and the attribute itself, if it is statically inferrable.
 */
abstract class AttrRef extends Node {
  /**
   * Gets the data flow node corresponding to the object whose attribute is being read or written.
   */
  abstract Node getObject();

  /**
   * Gets the expression control flow node that defines the attribute being accessed. This is
   * usually an identifier or literal.
   */
  abstract ExprNode getAttributeNameExpr();

  /** Holds if this attribute reference may access an attribute named `attrName`. */
  predicate mayHaveAttributeName(string attrName) {
    attrName = this.getAttributeName()
    or
    exists(Node nodeFrom |
      localFlow(nodeFrom, this.getAttributeNameExpr()) and
      attrName = nodeFrom.asExpr().(StrConst).getText()
    )
  }

  /** Gets the name of the attribute being read or written, if it can be determined statically. */
  abstract string getAttributeName();
}

/**
 * A data flow node that writes an attribute of an object. This includes
 * - Simple attribute writes: `object.attr = value`
 * - Dynamic attribute writes: `setattr(object, attr, value)`
 * - Fields written during class initialization: `class MyClass: attr = value`
 */
abstract class AttrWrite extends AttrRef {
  /** Gets the data flow node corresponding to the value that is written to the attribute. */
  abstract Node getValue();
}

/** A simple attribute assignment: `object.attr = value`. */
private class AttributeAssignmentAsAttrWrite extends AttrWrite, CfgNode {
  DefinitionNode attr_node;

  AttributeAssignmentAsAttrWrite() { this = TCfgNode(attr_node) and attr_node instanceof AttrNode }

  override Node getValue() { result = TCfgNode(attr_node.(DefinitionNode).getValue()) }

  override Node getObject() { result = TCfgNode(attr_node.(AttrNode).getObject()) }

  override ExprNode getAttributeNameExpr() {
    // Attribute names don't exist as `Node`s in the control flow graph, as they can only ever be
    // identifiers, and are therefore represented directly as strings.
    // Use `getAttributeName` to access the name of the attribute.
    none()
  }

  override string getAttributeName() { result = attr_node.(AttrNode).getName() }
}

import semmle.python.types.Builtins

/** Represents `CallNode`s that may refer to calls to built-in functions or classes. */
private class BuiltInCallNode extends CallNode {
  string name;

  BuiltInCallNode() {
    // TODO disallow instances where `setattr` may refer to an in-scope variable of that name.
    exists(NameNode id | this.getFunction() = id and id.getId() = name and id.isGlobal()) and
    name = any(Builtin b).getName()
  }

  /** Gets the name of the built-in function that is called at this `CallNode` */
  string getBuiltinName() { result = name }
}

/**
 * Represents a call to the built-ins that handle dynamic inspection and modification of
 * attributes: `getattr`, `setattr`, and `hasattr`.
 */
private class BuiltinAttrCallNode extends BuiltInCallNode {
  BuiltinAttrCallNode() {
    name = "setattr" or
    name = "getattr" or
    name = "hasattr"
  }

  /** Gets the control flow node for object on which the attribute is accessed. */
  ControlFlowNode getObject() { result in [this.getArg(0), this.getArgByName("object")] }

  /**
   * Gets the control flow node for the value that is being written to the attribute.
   * Only relevant for `setattr` calls.
   */
  ControlFlowNode getValue() {
    // only valid for `setattr`
    name = "setattr" and
    result in [this.getArg(2), this.getArgByName("value")]
  }

  /** Gets the control flow node that defines the name of the attribute being accessed. */
  ControlFlowNode getName() { result in [this.getArg(1), this.getArgByName("name")] }
}

/** Represents calls to the built-in `setattr`. */
private class SetAttrCallNode extends BuiltinAttrCallNode {
  SetAttrCallNode() { name = "setattr" }
}

/** Represents calls to the built-in `getattr`. */
private class GetAttrCallNode extends BuiltinAttrCallNode {
  GetAttrCallNode() { name = "getattr" }
}

/** An attribute assignment using `setattr`, e.g. `setattr(object, attr, value)` */
private class SetAttrCallAsAttrWrite extends AttrWrite, CfgNode {
  SetAttrCallNode setattr_call;

  SetAttrCallAsAttrWrite() { this = TCfgNode(setattr_call) }

  override Node getValue() { result = TCfgNode(setattr_call.getValue()) }

  override Node getObject() { result = TCfgNode(setattr_call.getObject()) }

  override ExprNode getAttributeNameExpr() { result = TCfgNode(setattr_call.getName()) }

  override string getAttributeName() {
    // TODO track this back using local flow
    exists(StrConst s, Node nodeFrom |
      s = nodeFrom.asExpr() and
      simpleLocalFlowStep*(nodeFrom, this.getAttributeNameExpr()) and
      result = s.getText()
    )
  }
}

/**
 * An attribute assignment via a class field, e.g.
 * ```python
 * class MyClass:
 *     attr = value
 * ```
 * is treated as equivalent to `MyClass.attr = value`.
 */
private class ClassDefinitionAsAttrWrite extends AttrWrite, Node {
  ClassExpr cls;
  DefinitionNode attr_node;

  ClassDefinitionAsAttrWrite() {
    attr_node instanceof NameNode and
    this.asCfgNode() = attr_node and
    attr_node.getScope() = cls.getInnerScope()
  }

  override Node getValue() { result = TCfgNode(attr_node.getValue()) }

  override Node getObject() { result = TCfgNode(cls.getAFlowNode()) }

  override ExprNode getAttributeNameExpr() { none() }

  override string getAttributeName() { result = attr_node.(NameNode).getId() }
}

/**
 * A read of an attribute on an object. This includes
 * - Simple attribute reads: `object.attr`
 * - Dynamic attribute reads using `getattr`: `getattr(object, attr)`
 * - Qualified imports: `from module import attr as name`
 */
abstract class AttrRead extends AttrRef, Node { }

/** A simple attribute read, e.g. `object.attr` */
private class AttributeReadAsAttrRead extends AttrRead, CfgNode {
  AttrNode attr_node;

  AttributeReadAsAttrRead() { this = TCfgNode(attr_node) }

  override Node getObject() { result = TCfgNode(attr_node.getObject()) }

  override ExprNode getAttributeNameExpr() {
    // Attribute names don't exist as `Node`s in the control flow graph, as they can only ever be
    // identifiers, and are therefore represented directly as strings.
    // Use `getAttributeName` to access the name of the attribute.
    none()
  }

  override string getAttributeName() { result = attr_node.getName() }
}

/** An attribute read using `getattr`: `getattr(object, attr)` */
private class GetAttrCallAsAttrRead extends AttrRead, CfgNode {
  GetAttrCallNode getattr_call;

  GetAttrCallAsAttrRead() { this.asCfgNode() = getattr_call }

  override Node getObject() { result = TCfgNode(getattr_call.getObject()) }

  override ExprNode getAttributeNameExpr() { result = TCfgNode(getattr_call.getName()) }

  override string getAttributeName() {
    exists(StrConst s, Node nodeFrom |
      s = nodeFrom.asExpr() and
      simpleLocalFlowStep*(nodeFrom, this.getAttributeNameExpr()) and
      result = s.getText()
    )
  }
}
