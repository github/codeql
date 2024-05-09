/**
 * Provides queries to pretty-print a Python AST as a graph.
 *
 * By default, this will print the AST for all elements in the database. To change this behavior,
 * extend `PrintAstConfiguration` and override `shouldPrint` to hold for only the elements
 * you wish to view the AST for.
 */

import python
import semmle.python.regexp.RegexTreeView
import semmle.python.Yaml

private newtype TPrintAstConfiguration = MkPrintAstConfiguration()

/**
 * The query can extend this class to control which elements are printed.
 */
class PrintAstConfiguration extends TPrintAstConfiguration {
  /**
   * Gets a textual representation of this `PrintAstConfiguration`.
   */
  string toString() { result = "PrintAstConfiguration" }

  /**
   * Controls whether the `AstNode` should be considered for AST printing.
   * By default it checks whether the `AstNode` `e` belongs to `Location` `l`.
   */
  predicate shouldPrint(AstNode e, Location l) { l = e.getLocation() }
}

private predicate shouldPrint(AstNode e, Location l) {
  exists(PrintAstConfiguration config | config.shouldPrint(e, l))
}

/** Holds if the given element does not need to be rendered in the AST. */
private predicate isNotNeeded(AstNode el) {
  el.isArtificial()
  or
  el instanceof Module
  or
  exists(AstNode parent | isNotNeeded(parent) and not parent instanceof Module |
    el = parent.getAChildNode()
  )
}

/**
 * Printed nodes.
 */
private newtype TPrintAstNode =
  TElementNode(AstNode el) { shouldPrint(el, _) and not isNotNeeded(el) } or
  TFunctionParamsNode(Function f) { shouldPrint(f, _) and not isNotNeeded(f) } or
  TCallArgumentsNode(Call c) { shouldPrint(c, _) and not isNotNeeded(c) } or
  TStmtListNode(StmtList list) {
    shouldPrint(list.getAnItem(), _) and
    not list = any(Module mod).getBody() and
    not forall(AstNode child | child = list.getAnItem() | isNotNeeded(child))
  } or
  TYamlNode(YamlNode node) or
  TYamlMappingNode(YamlMapping mapping, int i) { exists(mapping.getKeyNode(i)) }

/**
 * A node in the output tree.
 */
class PrintAstNode extends TPrintAstNode {
  /**
   * Gets a textual representation of this node in the PrintAst output tree.
   */
  string toString() { none() }

  /**
   * Gets the child node at index `childIndex`. Child indices must be unique,
   * but need not be contiguous.
   */
  PrintAstNode getChild(int childIndex) { none() }

  /**
   * Gets a child of this node.
   */
  final PrintAstNode getAChild() { result = this.getChild(_) }

  /**
   * Gets the parent of this node, if any.
   */
  final PrintAstNode getParent() { result.getAChild() = this }

  /**
   * Gets the location of this node in the source code.
   */
  Location getLocation() { none() }

  /**
   * Gets the value of the property of this node, where the name of the property
   * is `key`.
   */
  string getProperty(string key) {
    key = "semmle.label" and
    result = this.toString()
  }

  /**
   * Gets the label for the edge from this node to the specified child. By
   * default, this is just the index of the child, but subclasses can override
   * this.
   */
  string getChildEdgeLabel(int childIndex) {
    exists(this.getChild(childIndex)) and
    result = childIndex.toString()
  }
}

/** A top-level AST node. */
class TopLevelPrintAstNode extends PrintAstNode {
  TopLevelPrintAstNode() { not exists(this.getParent()) }

  private int getOrder() {
    this =
      rank[result](TopLevelPrintAstNode n, Location l |
        l = n.getLocation()
      |
        n
        order by
          l.getFile().getRelativePath(), l.getStartLine(), l.getStartColumn(), l.getEndLine(),
          l.getEndColumn()
      )
  }

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "semmle.order" and
    result = this.getOrder().toString()
  }
}

/**
 * An `AstNode` printed in the print-viewer.
 *
 * This class can be overridden to define more specific behavior for some `AstNode`s.
 * The `getChildNode` and `getStmtList` methods can be overridden to easily set up a child-parent relation between different `AstElementNode`s.
 * Be very careful about overriding `getChild`, as `getChildNode` and `getStmtList` depend on the default behavior of `getChild`.
 */
class AstElementNode extends PrintAstNode, TElementNode {
  AstNode element;

  AstElementNode() { this = TElementNode(element) }

  override string toString() {
    result = "[" + PrettyPrinting::getQlClass(element) + "] " + PrettyPrinting::prettyPrint(element)
  }

  override Location getLocation() { result = element.getLocation() }

  /**
   * Gets the `AstNode` that is printed by this print node.
   */
  final AstNode getAstNode() { result = element }

  override PrintAstNode getChild(int childIndex) {
    exists(AstNode el | result.(AstElementNode).getAstNode() = el |
      el = this.getChildNode(childIndex) and not el = this.getStmtList(_, _).getAnItem()
    )
    or
    // displaying all `StmtList` after the other children.
    exists(int offset | offset = 1 + max([0, any(int index | exists(this.getChildNode(index)))]) |
      exists(int index | childIndex = index + offset |
        result.(StmtListNode).getList() = this.getStmtList(index, _)
      )
    )
  }

  /**
   * Gets a child node for the AstNode that this print node represents.
   *
   * The default behavior in `getChild` uses `getChildNode` to easily define a parent-child relation between different `AstElementNode`s.
   */
  AstNode getChildNode(int childIndex) { result = getChild(element, childIndex) }

  /**
   * Gets the `index`th `StmtList` that is a child of the `AstNode` that this print node represents.
   * `label` is used for pretty-printing a label in the parent-child relation in the ast-viewer.
   *
   * The `StmtListNode` class and the `getChild` predicate uses `getStmtList` to define a parent-child relation with labels.
   *
   * `index` must be 0 or positive.
   */
  StmtList getStmtList(int index, string label) { none() }
}

/**
 * A print node for `Try` statements.
 */
class TryNode extends AstElementNode {
  override Try element;

  override StmtList getStmtList(int index, string label) {
    index = 0 and result = element.getBody() and label = "body"
    or
    index = 1 and result = element.getOrelse() and label = "orelse"
    or
    index = 2 and result = element.getHandlers() and label = "handlers"
    or
    index = 3 and result = element.getFinalbody() and label = "final body"
  }
}

/**
 * A print node for `If` statements.
 */
class IfNode extends AstElementNode {
  override If element;

  override AstNode getChildNode(int childIndex) { childIndex = 0 and result = element.getTest() }

  override StmtList getStmtList(int index, string label) {
    index = 1 and result = element.getBody() and label = "body"
    or
    index = 2 and result = element.getOrelse() and label = "orelse"
  }
}

/**
 * A print node for classes.
 */
class ClassNode extends AstElementNode {
  override Class element;

  override StmtList getStmtList(int index, string label) {
    index = 1 and result = element.getBody() and label = "body"
  }
}

/**
 * A print node for `ExceptStmt`.
 */
class ExceptNode extends AstElementNode {
  override ExceptStmt element;

  override StmtList getStmtList(int index, string label) {
    index = 1 and result = element.getBody() and label = "body"
  }
}

/**
 * A print node for `With` statements.
 */
class WithNode extends AstElementNode {
  override With element;

  override StmtList getStmtList(int index, string label) {
    index = 1 and result = element.getBody() and label = "body"
  }
}

/**
 * A print node for `For` statements.
 */
class ForPrintNode extends AstElementNode {
  override For element;

  override StmtList getStmtList(int index, string label) {
    index = 1 and result = element.getBody() and label = "body"
    or
    index = 2 and result = element.getOrelse() and label = "orelse"
  }
}

/**
 * A print node for `While` statements.
 */
class WhilePrintNode extends AstElementNode {
  override While element;

  override StmtList getStmtList(int index, string label) {
    index = 1 and result = element.getBody() and label = "body"
    or
    index = 2 and result = element.getOrelse() and label = "orelse"
  }
}

/**
 * A print node for `StmtList`.
 * A `StmtListNode` is always a child of an `AstElementNode`,
 * and the child-parent relation is defined by the `getStmtList` predicate in `AstElementNode`.
 *
 * The label for a `StmtList` is decided based on the result from the `getStmtList` predicate in `AstElementNode`.
 */
class StmtListNode extends PrintAstNode, TStmtListNode {
  StmtList list;

  StmtListNode() {
    this = TStmtListNode(list) and
    list = any(AstElementNode node).getStmtList(_, _)
  }

  /**
   * Gets the `StmtList` that this print node represents.
   */
  StmtList getList() { result = list }

  private string getLabel() { this.getList() = any(AstElementNode node).getStmtList(_, result) }

  override string toString() { result = "(StmtList) " + this.getLabel() }

  override PrintAstNode getChild(int childIndex) {
    exists(AstNode el | result.(AstElementNode).getAstNode() = el | el = list.getItem(childIndex))
  }
}

/**
 * A print node for a `Call`.
 *
 * The arguments to this call are aggregated into a `CallArgumentsNode`.
 */
class CallPrintNode extends AstElementNode {
  override Call element;

  override PrintAstNode getChild(int childIndex) {
    childIndex = 0 and result.(AstElementNode).getAstNode() = element.getFunc()
    or
    childIndex = 1 and result.(CallArgumentsNode).getCall() = element
  }
}

/**
 * A synthetic print node for the arguments to `call`.
 */
class CallArgumentsNode extends PrintAstNode, TCallArgumentsNode {
  Call call;

  CallArgumentsNode() { this = TCallArgumentsNode(call) }

  /**
   * Gets the call for which this print node represents the arguments.
   */
  Call getCall() { result = call }

  override string toString() { result = "(arguments)" }

  override PrintAstNode getChild(int childIndex) {
    result.(AstElementNode).getAstNode() = getChild(call, childIndex) and
    not result.(AstElementNode).getAstNode() = call.getFunc()
  }
}

/**
 * A print node for a `Function`.
 */
class FunctionNode extends AstElementNode {
  override Function element;

  override PrintAstNode getChild(int childIndex) {
    exists(FunctionParamsNode paramsNode | paramsNode.getFunction() = element |
      childIndex = 0 and result = paramsNode
      or
      result = AstElementNode.super.getChild(childIndex) and
      // parameters is handled above
      not result.(AstElementNode).getAstNode() =
        paramsNode.getChild(_).(AstElementNode).getAstNode() and
      // The default of a Parameter is handled by `ParameterNode`
      not result.(AstElementNode).getAstNode() = any(Parameter param).getDefault() and
      // The annotation is a parameter is handled by `ParameterNode`.
      not result.(AstElementNode).getAstNode() = any(Parameter param).getAnnotation()
    )
  }

  override StmtList getStmtList(int index, string label) {
    index = 1 and result = element.getBody() and label = "body"
  }
}

/**
 * A print node for a `FunctionDef`.
 */
class FunctionDefNode extends AstElementNode {
  override FunctionDef element;

  override AstNode getChildNode(int childIndex) {
    childIndex = 0 and result = element.getTarget(0)
    or
    childIndex = 1 and result = element.getValue()
  }
}

/**
 * A print node for the parameters in `func`.
 */
class FunctionParamsNode extends PrintAstNode, TFunctionParamsNode {
  Function func;

  FunctionParamsNode() { this = TFunctionParamsNode(func) }

  /**
   * Gets the `Function` that this print node represents.
   */
  Function getFunction() { result = func }

  override string toString() { result = "(parameters)" }

  override PrintAstNode getChild(int childIndex) {
    // everything that is not a stmt is a parameter.
    exists(AstNode el | result.(AstElementNode).getAstNode() = el |
      el = getChild(func, childIndex) and not el = func.getAStmt()
    )
  }
}

/**
 * A print node for a `Parameter`.
 *
 * This print node has the annotation and default value of the `Parameter` as children.
 * The type annotation and default value would by default exist as children of the parent `Function`.
 */
class ParameterNode extends AstElementNode {
  Parameter param;

  ParameterNode() { this.getAstNode() = param.asName() or this.getAstNode() = param.asTuple() }

  override AstNode getChildNode(int childIndex) {
    childIndex = 0 and result = param.getAnnotation()
    or
    childIndex = 1 and result = param.getDefault()
  }
}

/**
 * A print node for a `StringLiteral`.
 *
 * The string has a child, if the child is used as a regular expression,
 * which is the root of the regular expression.
 */
class StringLiteralNode extends AstElementNode {
  override StringLiteral element;
}

/**
 * Gets the `i`th child from `node` ordered by location.
 */
private AstNode getChild(AstNode node, int i) {
  shouldPrint(node, _) and
  result =
    rank[i](AstNode child |
      child = node.getAChildNode()
    |
      child
      order by
        child.getLocation().getStartLine(), child.getLocation().getStartColumn(),
        child.getLocation().getEndLine(), child.getLocation().getEndColumn()
    )
}

/**
 * A module for pretty-printing some `AstNode`s.
 */
private module PrettyPrinting {
  /**
   * Gets the QL class for the `AstNode` `a`.
   * Most `AstNode`s print their QL class in the `toString()` method, however there are exceptions.
   * These exceptions are handled in the `getQlCustomClass` predicate.
   */
  string getQlClass(AstNode a) {
    shouldPrint(a, _) and
    (
      not exists(getQlCustomClass(a)) and result = strictconcat(a.toString(), " | ")
      or
      result = strictconcat(getQlCustomClass(a), " | ")
    )
  }

  /**
   * Gets the QL class for `AstNode`s where the `toString` method does not print the QL class.
   */
  string getQlCustomClass(AstNode a) {
    shouldPrint(a, _) and
    (
      a instanceof Name and
      result = "Name" and
      not a instanceof Parameter and
      not a instanceof NameConstant
      or
      a instanceof Parameter and result = "Parameter"
      or
      a instanceof PlaceHolder and result = "PlaceHolder"
      or
      a instanceof Function and result = "Function"
      or
      a instanceof Class and result = "Class"
      or
      a instanceof Call and result = "Call"
      or
      a instanceof NameConstant and result = "NameConstant"
    )
  }

  /**
   * Gets a human-readable representation of the `AstNode` `a`, or the empty string.
   *
   * Has exactly one result for every `AstNode`.
   */
  string prettyPrint(AstNode a) {
    shouldPrint(a, _) and
    (
      // this strictconcat should not be needed.
      // However, the printAst feature breaks if this predicate has more than one result for an `AstNode`, so the strictconcat stays.
      result = strictconcat(reprRec(a), " | ")
      or
      not exists(reprRec(a)) and
      result = ""
    )
  }

  /**
   * Gets a human-readable representation of the given `AstNode`.
   *
   * Only has a result for some `AstNode`s.
   *
   * The monotonicity of this recursive predicate is kept by defining the non-recursive cases inside the `reprBase` predicate,
   * and then using `reprBase` when there is a negative edge.
   */
  private string reprRec(AstNode a) {
    shouldPrint(a, _) and
    not isNotNeeded(a) and
    (
      // For NameNodes, we just use the underlying variable name
      result = reprBase(a)
      or
      exists(Expr obj |
        obj = a.(Attribute).getObject() // Attribute .getname .getObject
      |
        // Attributes of the form `name.name2`
        result = reprBase(obj) + "." + a.(Attribute).getName()
        or
        // Attributes where the object is a more complicated expression
        not exists(reprBase(obj)) and
        result = "(...)." + a.(Attribute).getName()
      )
      or
      result = "import " + reprRec(a.(Import).getName(_).getAsname())
      or
      exists(Keyword keyword | keyword = a |
        result = keyword.getArg() + "=" + reprRec(keyword.getValue())
      )
      or
      result = reprRec(a.(Call).getFunc()) + "(" + printArgs(a) + ")"
      or
      not exists(printArgs(a)) and result = reprRec(a.(Call).getFunc()) + "(...)"
      or
      result = "try " + reprRec(a.(Try).getBody().getItem(0))
      or
      result = "if " + reprRec(a.(If).getTest()) + ":"
      or
      result = reprRec(a.(Compare).getLeft()) + " " + a.(Compare).getOp(0).getSymbol() + " ..."
      or
      result = a.(Subscript).getObject() + "[" + reprRec(a.(Subscript).getIndex()) + "]"
      or
      exists(Assign asn | asn = a |
        strictcount(asn.getTargets()) = 1 and
        result = reprRec(a.(Assign).getTarget(0)) + " = " + reprRec(asn.getValue())
      )
      or
      result = "return " + reprRec(a.(Return).getValue())
      or
      result = reprRec(a.(ExprStmt).getValue())
      or
      exists(BoolExpr b, string op |
        a = b and
        (
          b.getOp() instanceof And and op = "and"
          or
          b.getOp() instanceof Or and op = "or"
        )
      |
        result = reprRec(b.getValue(0)) + " " + op + " " + reprRec(b.getValue(1))
      )
    )
  }

  /**
   * Gets a comma separated pretty printed list of the arguments in `call`.
   */
  string printArgs(Call call) {
    not exists(call.getAnArg()) and result = ""
    or
    result = strictconcat(int i | | reprBase(call.getArg(i)), ", ")
  }

  /**
   * Gets a human-readable representation of the given `AstNode`.
   * Is only defined for `AstNode`s for which a human-readable representation can be created without using recursion.
   */
  private string reprBase(AstNode a) {
    shouldPrint(a, _) and
    not isNotNeeded(a) and
    (
      result = a.(Name).getId()
      or
      result = a.(PlaceHolder).toString()
      or
      result = "class " + a.(ClassExpr).getName()
      or
      result = "class " + a.(Class).getName()
      or
      result = a.(StringLiteral).getText()
      or
      result = "yield " + a.(Yield).getValue()
      or
      result = "yield from " + a.(YieldFrom).getValue()
      or
      result = "*" + a.(Starred).getValue()
      or
      result = "`" + a.(Repr).getValue() + "`"
      or
      a instanceof Ellipsis and result = "..."
      or
      result = a.(Num).getText()
      or
      result = a.(NegativeIntegerLiteral).getValue().toString()
      or
      result = a.(NameConstant).toString()
      or
      result = "await " + a.(Await).getValue()
      or
      result = "function " + a.(FunctionExpr).getName() + "(...)"
      or
      result = "function " + a.(Function).getName() + "(...)"
      or
      a instanceof List and result = "[...]"
      or
      a instanceof Set and result = "{...}"
      or
      a instanceof Continue and result = "continue"
      or
      a instanceof Break and result = "break"
      or
      a instanceof Pass and result = "pass"
    )
  }
}

/**
 * Classes for printing YAML AST.
 */
module PrintYaml {
  /**
   * A print node representing a YAML value in a .yml file.
   */
  class YamlNodeNode extends PrintAstNode, TYamlNode {
    YamlNode node;

    YamlNodeNode() { this = TYamlNode(node) }

    override string toString() {
      result = "[" + concat(node.getAPrimaryQlClass(), ",") + "] " + node.toString()
    }

    override Location getLocation() { result = node.getLocation() }

    /**
     * Gets the `YAMLNode` represented by this node.
     */
    final YamlNode getValue() { result = node }

    override PrintAstNode getChild(int childIndex) {
      exists(YamlNode child | result.(YamlNodeNode).getValue() = child |
        child = node.getChildNode(childIndex)
      )
    }
  }

  /**
   * A print node representing a `YAMLMapping`.
   *
   * Each child of this node aggregates the key and value of a mapping.
   */
  class YamlMappingNode extends YamlNodeNode {
    override YamlMapping node;

    override PrintAstNode getChild(int childIndex) {
      exists(YamlMappingMapNode map | map = result | map.maps(node, childIndex))
    }
  }

  /**
   * A print node representing the `i`th mapping in `mapping`.
   */
  class YamlMappingMapNode extends PrintAstNode, TYamlMappingNode {
    YamlMapping mapping;
    int i;

    YamlMappingMapNode() { this = TYamlMappingNode(mapping, i) }

    override string toString() {
      result = "(Mapping " + i + ")" and not exists(mapping.getKeyNode(i).(YamlScalar).getValue())
      or
      result = "(Mapping " + i + ") " + mapping.getKeyNode(i).(YamlScalar).getValue() + ":"
    }

    /**
     * Holds if this print node represents the `index`th mapping of `m`.
     */
    predicate maps(YamlMapping m, int index) {
      m = mapping and
      index = i
    }

    override PrintAstNode getChild(int childIndex) {
      childIndex = 0 and result.(YamlNodeNode).getValue() = mapping.getKeyNode(i)
      or
      childIndex = 1 and result.(YamlNodeNode).getValue() = mapping.getValueNode(i)
    }
  }
}

/** Holds if `node` belongs to the output tree, and its property `key` has the given `value`. */
query predicate nodes(PrintAstNode node, string key, string value) { value = node.getProperty(key) }

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of the edge has the
 * given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  exists(int childIndex |
    target = source.getChild(childIndex) and
    (
      key = "semmle.label" and value = source.getChildEdgeLabel(childIndex)
      or
      key = "semmle.order" and value = childIndex.toString()
    )
  )
}

/** Holds if property `key` of the graph has the given `value`. */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
