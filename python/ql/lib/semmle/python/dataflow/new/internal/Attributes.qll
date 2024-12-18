/** This module provides an API for attribute reads and writes. */

import DataFlowUtil
import DataFlowPublic
private import DataFlowPrivate
private import semmle.python.types.Builtins

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
   * Holds if this data flow node accesses attribute named `attrName` on object `object`.
   */
  predicate accesses(Node object, string attrName) {
    this.getObject() = object and this.getAttributeName() = attrName
  }

  /**
   * Gets the expression node that defines the attribute being accessed, if any. This is
   * usually an identifier or literal.
   */
  abstract ExprNode getAttributeNameExpr();

  /**
   * Holds if this attribute reference may access an attribute named `attrName`.
   * Uses local data flow to track potential attribute names, which may lead to imprecision. If more
   * precision is needed, consider using `getAttributeName` instead.
   */
  predicate mayHaveAttributeName(string attrName) {
    attrName = this.getAttributeName()
    or
    exists(LocalSourceNode nodeFrom |
      nodeFrom.flowsTo(this.getAttributeNameExpr()) and
      attrName = nodeFrom.(CfgNode).getNode().getNode().(StringLiteral).getText()
    )
  }

  /**
   * Gets the name of the attribute being read or written. For dynamic attribute accesses, this
   * method is not guaranteed to return a result. For such cases, using `mayHaveAttributeName` may yield
   * better results.
   */
  abstract string getAttributeName();

  /** Holds if a name could not be determined for this attribute. */
  predicate unknownAttribute() { not exists(this.getAttributeName()) }
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

/**
 * Represents a control flow node for a simple attribute assignment. That is,
 * ```python
 * object.attr = value
 * ```
 * Also gives access to the `value` being written, by extending `DefinitionNode`.
 */
private class AttributeAssignmentNode extends DefinitionNode, AttrNode { }

/** A simple attribute assignment: `object.attr = value`. */
private class AttributeAssignmentAsAttrWrite extends AttrWrite, CfgNode {
  override AttributeAssignmentNode node;

  override Node getValue() { result.asCfgNode() = node.getValue() }

  override Node getObject() { result.asCfgNode() = node.getObject() }

  override ExprNode getAttributeNameExpr() {
    // Attribute names don't exist as `Node`s in the control flow graph, as they can only ever be
    // identifiers, and are therefore represented directly as strings.
    // Use `getAttributeName` to access the name of the attribute.
    none()
  }

  override string getAttributeName() { result = node.getName() }
}

/**
 * An attribute assignment where the object is a global variable: `global_var.attr = value`.
 *
 * Syntactically, this is identical to the situation that is covered by
 * `AttributeAssignmentAsAttrWrite`, however in this case we want to behave as if the object that is
 * being written is the underlying `ModuleVariableNode`.
 */
private class GlobalAttributeAssignmentAsAttrWrite extends AttrWrite, CfgNode {
  override AttributeAssignmentNode node;

  override Node getValue() { result.asCfgNode() = node.getValue() }

  override Node getObject() {
    result.(ModuleVariableNode).getVariable() = node.getObject().getNode().(Name).getVariable()
  }

  override ExprNode getAttributeNameExpr() {
    // Attribute names don't exist as `Node`s in the control flow graph, as they can only ever be
    // identifiers, and are therefore represented directly as strings.
    // Use `getAttributeName` to access the name of the attribute.
    none()
  }

  override string getAttributeName() { result = node.getName() }
}

/** Represents `CallNode`s that may refer to calls to built-in functions or classes. */
private class BuiltInCallNode extends CallNode {
  string name;

  BuiltInCallNode() {
    // TODO disallow instances where the name of the built-in may refer to an in-scope variable of that name.
    exists(NameNode id | this.getFunction() = id and id.getId() = name and id.isGlobal()) and
    name = any(Builtin b).getName()
  }

  /** Gets the name of the built-in function that is called at this `CallNode` */
  string getBuiltinName() { result = name }
}

/**
 * Represents a call to the built-ins that handle dynamic inspection and modification of
 * attributes: `getattr`, `setattr`, `hasattr`, and `delattr`.
 */
private class BuiltinAttrCallNode extends BuiltInCallNode {
  BuiltinAttrCallNode() { name in ["setattr", "getattr", "hasattr", "delattr"] }

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
  override SetAttrCallNode node;

  override Node getValue() { result.asCfgNode() = node.getValue() }

  override Node getObject() { result.asCfgNode() = node.getObject() }

  override ExprNode getAttributeNameExpr() { result.asCfgNode() = node.getName() }

  override string getAttributeName() {
    result = this.getAttributeNameExpr().(CfgNode).getNode().getNode().(StringLiteral).getText()
  }
}

/**
 * Represents an attribute of a class that is assigned statically during class definition. For instance
 * ```python
 * class MyClass:
 *     attr = value
 *     ...
 * ```
 * Instances of this class correspond to the `NameNode` for `attr`, and also gives access to `value` by
 * virtue of being a `DefinitionNode`.
 */
private class ClassAttributeAssignmentNode extends DefinitionNode, NameNode {
  ClassAttributeAssignmentNode() { this.getScope() = any(ClassExpr c).getInnerScope() }
}

/**
 * An attribute assignment via a class field, e.g.
 * ```python
 * class MyClass:
 *     attr = value
 * ```
 * is treated as equivalent to `MyClass.attr = value`.
 */
private class ClassDefinitionAsAttrWrite extends AttrWrite, CfgNode {
  ClassExpr cls;
  override ClassAttributeAssignmentNode node;

  ClassDefinitionAsAttrWrite() { node.getScope() = cls.getInnerScope() }

  override Node getValue() { result.asCfgNode() = node.getValue() }

  override Node getObject() { result.asCfgNode() = cls.getAFlowNode() }

  override ExprNode getAttributeNameExpr() { none() }

  override string getAttributeName() { result = node.getId() }
}

/**
 * A read of an attribute on an object. This includes
 * - Simple attribute reads: `object.attr`
 * - Dynamic attribute reads using `getattr`: `getattr(object, attr)`
 * - Qualified imports: `from module import attr as name`
 */
abstract class AttrRead extends AttrRef, Node, LocalSourceNode { }

/** A simple attribute read, e.g. `object.attr` */
private class AttributeReadAsAttrRead extends AttrRead, CfgNode {
  override AttrNode node;

  AttributeReadAsAttrRead() { node.isLoad() }

  override Node getObject() { result.asCfgNode() = node.getObject() }

  override ExprNode getAttributeNameExpr() {
    // Attribute names don't exist as `Node`s in the control flow graph, as they can only ever be
    // identifiers, and are therefore represented directly as strings.
    // Use `getAttributeName` to access the name of the attribute.
    none()
  }

  override string getAttributeName() { result = node.getName() }
}

/** An attribute read using `getattr`: `getattr(object, attr)` */
private class GetAttrCallAsAttrRead extends AttrRead, CfgNode {
  override GetAttrCallNode node;

  override Node getObject() { result.asCfgNode() = node.getObject() }

  override ExprNode getAttributeNameExpr() { result.asCfgNode() = node.getName() }

  override string getAttributeName() {
    result = this.getAttributeNameExpr().(CfgNode).getNode().getNode().(StringLiteral).getText()
  }
}

/**
 * Represents a named import as an attribute read. That is,
 * ```python
 * from module import attr as attr_ref
 * ```
 * is treated as if it is a read of the attribute `module.attr`, even if `module` is not imported directly.
 */
private class ModuleAttributeImportAsAttrRead extends AttrRead, CfgNode {
  override ImportMemberNode node;

  override Node getObject() { result.asCfgNode() = node.getModule(_) }

  override ExprNode getAttributeNameExpr() {
    // The name of an imported attribute doesn't exist as a `Node` in the control flow graph, as it
    // can only ever be an identifier, and is therefore represented directly as a string.
    // Use `getAttributeName` to access the name of the attribute.
    none()
  }

  override string getAttributeName() { exists(node.getModule(result)) }
}
