/**
 * Provides queries to pretty-print a JavaScript AST as a graph.
 *
 * By default, this will print the AST for all elements in the database. To change this behavior,
 * extend `PrintAstConfiguration` and override `shouldPrint` to hold for only the elements
 * you wish to view the AST for.
 */

import javascript

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
   * Controls whether the `Element` should be considered for AST printing.
   * By default it checks whether the `Element` `e` belongs to `Location` `l`.
   */
  predicate shouldPrint(Locatable e, Location l) { l = e.getLocation() }
}

private predicate shouldPrint(Locatable e, Location l) {
  exists(PrintAstConfiguration config | config.shouldPrint(e, l))
}

/**
 * Holds if the given element does not need to be rendered in the AST.
 * Either due to being the `TopLevel` for a file, or an internal node representing a decorator list.
 */
private predicate isNotNeeded(Locatable el) {
  el instanceof TopLevel and
  el.getLocation().getStartLine() = 0 and
  el.getLocation().getStartColumn() = 0
  or
  el instanceof @decorator_list // there is no public API for this.
  or
  // relaxing aggressive type inference.
  none()
}

/**
 * Retrieves the canonical QL class(es) for entity `el`
 */
private string getQlClass(Locatable el) {
  result = "[" + el.getPrimaryQlClasses() + "] "
  // Alternative implementation -- do not delete. It is useful for QL class discovery.
  // not el.getAPrimaryQlClass() = "???" and result = "[" + el.getPrimaryQlClasses() + "] " or el.getAPrimaryQlClass() = "???" and result = "??[" + concat(el.getAQlClass(), ",") + "] "
}

/**
 * Printed nodes for different file types.
 */
private newtype TPrintAstNode =
  // JavaScript / TypeScript
  TElementNode(AstNode el) { shouldPrint(el, _) and not isNotNeeded(el) } or
  TParametersNode(Function f) { shouldPrint(f, _) and not isNotNeeded(f) } or
  TTypeParametersNode(TypeParameterized f) { shouldPrint(f, _) and not isNotNeeded(f) } or
  TJsxAttributesNode(JsxElement n) { shouldPrint(n, _) and not isNotNeeded(n) } or
  TJsxBodyElementsNode(JsxNode n) { shouldPrint(n, _) and not isNotNeeded(n) } or
  TInvokeArgumentsNode(InvokeExpr n) { shouldPrint(n, _) and not isNotNeeded(n) } or
  TInvokeTypeArgumentsNode(InvokeExpr invk) { shouldPrint(invk, _) and not isNotNeeded(invk) } or
  // JSON
  TJsonNode(JsonValue value) { shouldPrint(value, _) and not isNotNeeded(value) } or
  // YAML
  TYamlNode(YamlNode n) { shouldPrint(n, _) and not isNotNeeded(n) } or
  TYamlMappingNode(YamlMapping mapping, int i) {
    shouldPrint(mapping, _) and not isNotNeeded(mapping) and exists(mapping.getKeyNode(i))
  } or
  // HTML
  THtmlElementNode(HTML::Element e) { shouldPrint(e, _) and not isNotNeeded(e) } or
  THtmlAttributesNodes(HTML::Element e) { shouldPrint(e, _) and not isNotNeeded(e) } or
  THtmlAttributeNode(HTML::Attribute attr) { shouldPrint(attr, _) and not isNotNeeded(attr) } or
  THtmlScript(Script script) { shouldPrint(script, _) and not isNotNeeded(script) } or
  THtmlCodeInAttr(CodeInAttribute attr) { shouldPrint(attr, _) and not isNotNeeded(attr) } or
  TRegExpTermNode(RegExpTerm term) {
    shouldPrint(term, _) and
    term.isUsedAsRegExp() and
    any(RegExpLiteral lit).getRoot() = term.getRootTerm()
  } or
  TXmlAttributeNode(XmlAttribute attr) { shouldPrint(attr, _) and not isNotNeeded(attr) }

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
 * Classes for printing JavaScript AST.
 */
private module PrintJavaScript {
  /**
   * A print node representing an `ASTNode`.
   *
   * Provides a default implementation that works for some (but not all) ASTNode's.
   * More specific subclasses can override this class to get more specific behavior.
   *
   * The more specific subclasses are mostly used aggregate the children of the `ASTNode`.
   * For example by aggregating all the parameters of a function under a single child node.
   */
  class ElementNode extends PrintAstNode, TElementNode {
    AstNode element;

    ElementNode() {
      this = TElementNode(element) and
      not element instanceof Script and // Handled in module `PrintHTML`
      not element instanceof CodeInAttribute // Handled in module `PrintHTML`
    }

    override string toString() { result = getQlClass(element) + PrettyPrinting::print(element) }

    override Location getLocation() { result = element.getLocation() }

    /**
     * Gets the `ASTNode` represented by this node.
     */
    final AstNode getElement() { result = element }

    override PrintAstNode getChild(int childIndex) {
      exists(AstNode el | result.(ElementNode).getElement() = el |
        el = this.getChildNode(childIndex)
      )
    }

    /**
     * Gets the `i`th child of `element`.
     * Can be overridden in subclasses to get more specific behavior for `getChild()`.
     */
    AstNode getChildNode(int i) { result = getLocationSortedChild(element, i) }
  }

  /** Provides predicates for pretty printing `AstNode`s. */
  private module PrettyPrinting {
    /**
     * Gets a pretty string representation of `element`.
     * Either the result is `ASTNode::toString`, or a custom made string representation of `element`.
     */
    string print(AstNode element) {
      shouldPrint(element, _) and
      (
        result = element.toString().regexpReplaceAll("(\\\\n|\\\\r|\\\\t| )+", " ") and
        not exists(repr(element))
        or
        result = repr(element)
      )
    }

    /**
     * Gets a string representing `a`.
     */
    private string repr(AstNode a) {
      shouldPrint(a, _) and
      (
        exists(DeclStmt decl | decl = a |
          result =
            getDeclarationKeyword(decl) + " " +
              strictconcat(string name, int i |
                name = decl.getDecl(i).getBindingPattern().getName()
              |
                name, ", " order by i
              ) + " = ..."
        )
        or
        exists(ObjectExpr obj | obj = a | result = "{" + obj.getProperty(0).getName() + ": ...}")
        or
        result = a.(Property).getName() + ": " + repr(a.(Property).getInit())
        or
        result = a.(Literal).getRawValue()
        or
        result = a.(Identifier).getName()
      )
    }

    /**
     * Gets "var" or "const" or "let" or "using" depending on what type of declaration `decl` is.
     */
    private string getDeclarationKeyword(DeclStmt decl) {
      decl instanceof VarDeclStmt and result = "var"
      or
      decl instanceof ConstDeclStmt and result = "const"
      or
      decl instanceof UsingDeclStmt and result = "using"
      or
      decl instanceof LetStmt and result = "let"
    }
  }

  private AstNode getLocationSortedChild(AstNode parent, int i) {
    result =
      rank[i](AstNode child, int childIndex |
        child = parent.getChild(childIndex)
      |
        child
        order by
          child.getLocation().getStartLine(), child.getLocation().getStartColumn(), childIndex
      )
  }

  /**
   * A print node for function invocations.
   *
   * The children of this node are split into 3.
   * 1: The callee.
   * 2: An aggregate node for all the arguments.
   * 3: An aggregate node for all the type argument.
   */
  class InvokeNode extends ElementNode {
    override InvokeExpr element;

    override PrintAstNode getChild(int childIndex) {
      childIndex = 0 and result.(ElementNode).getElement() = element.getCallee()
      or
      childIndex = 1 and
      exists(element.getAnArgument()) and
      result.(InvokeArgumentsNode).getInvokeExpr() = element
      or
      childIndex = 2 and
      exists(element.getATypeArgument()) and
      result.(InvokeTypeArgumentsNode).getInvokeExpr() = element
    }
  }

  /**
   * A print node for regexp literals.
   *
   * The single child of this node is the root `RegExpTerm`.
   */
  class RegexpNode extends ElementNode {
    override RegExpLiteral element;

    override PrintAstNode getChild(int childIndex) {
      childIndex = 0 and
      result.(RegExpTermNode).getTerm() = element.getRoot()
    }
  }

  /**
   * A print node for regexp terms.
   */
  class RegExpTermNode extends PrintAstNode, TRegExpTermNode {
    RegExpTerm term;

    RegExpTermNode() { this = TRegExpTermNode(term) }

    RegExpTerm getTerm() { result = term }

    override PrintAstNode getChild(int childIndex) {
      result.(RegExpTermNode).getTerm() = term.getChild(childIndex)
    }

    override string toString() { result = getQlClass(term) + term.toString() }

    override Location getLocation() { result = term.getLocation() }
  }

  /**
   * An aggregate node representing all the arguments for an function invocation.
   */
  class InvokeArgumentsNode extends PrintAstNode, TInvokeArgumentsNode {
    InvokeExpr invk;

    InvokeArgumentsNode() { this = TInvokeArgumentsNode(invk) and exists(invk.getAnArgument()) }

    override string toString() { result = "(Arguments)" }

    /**
     * Gets the `InvokeExpr` for which this node represents the arguments.
     */
    InvokeExpr getInvokeExpr() { result = invk }

    override PrintAstNode getChild(int childIndex) {
      result.(ElementNode).getElement() = invk.getArgument(childIndex)
    }
  }

  /**
   * An aggregate node representing all the type-arguments for an function invocation.
   */
  class InvokeTypeArgumentsNode extends PrintAstNode, TInvokeTypeArgumentsNode {
    InvokeExpr invk;

    InvokeTypeArgumentsNode() {
      this = TInvokeTypeArgumentsNode(invk) and exists(invk.getATypeArgument())
    }

    override string toString() { result = "(TypeArguments)" }

    /**
     * Gets the `InvokeExpr` for which this node represents the type-arguments.
     */
    InvokeExpr getInvokeExpr() { result = invk }

    override PrintAstNode getChild(int childIndex) {
      result.(ElementNode).getElement() = invk.getTypeArgument(childIndex)
    }
  }

  /**
   * A print node for JSX nodes.
   *
   * The children of this node are split into 3.
   * 1: The name of the JSX node (for example `Name` in `<Name href={foo} />`).
   * 2: An aggregate node for all the attributes  (for example `href={foo}` in `<Name href={foo} />`).
   * 3: An aggregate node for all the body element (for example `foo` in `<span>foo</span>`).
   */
  class JsxNodeNode extends ElementNode {
    override JsxNode element;

    override PrintAstNode getChild(int childIndex) {
      childIndex = 0 and result.(ElementNode).getElement() = element.(JsxElement).getNameExpr()
      or
      childIndex = 1 and
      exists(element.getABodyElement()) and
      result.(JsxBodyElementsNode).getJsxNode() = element
      or
      childIndex = 2 and
      exists(element.(JsxElement).getAttribute(_)) and
      result.(JsxAttributesNode).getJsxElement() = element
    }
  }

  /**
   * An aggregate node representing all the attributes in a `JSXNode`.
   */
  class JsxAttributesNode extends PrintAstNode, TJsxAttributesNode {
    JsxElement n;

    JsxAttributesNode() { this = TJsxAttributesNode(n) and exists(n.getAttribute(_)) }

    override string toString() { result = "(Attributes)" }

    /**
     * Gets the `JSXElement` for which this node represents the attributes.
     */
    JsxElement getJsxElement() { result = n }

    override PrintAstNode getChild(int childIndex) {
      result.(ElementNode).getElement() = n.getAttribute(childIndex)
    }
  }

  /**
   * An aggregate node representing all the body elements in a `JSXNode`.
   */
  class JsxBodyElementsNode extends PrintAstNode, TJsxBodyElementsNode {
    JsxNode n;

    JsxBodyElementsNode() { this = TJsxBodyElementsNode(n) and exists(n.getBodyElement(_)) }

    override string toString() { result = "(Body)" }

    /**
     * Gets the `JSXNode` for which this node represents the body elements.
     */
    JsxNode getJsxNode() { result = n }

    override PrintAstNode getChild(int childIndex) {
      result.(ElementNode).getElement() = n.getBodyElement(childIndex)
    }
  }

  /**
   * A node representing any `ASTNode` that has type-parameters.
   *
   * The first child of this node is an aggregate node representing all the type-parameters.
   */
  class TypeParameterizedNode extends ElementNode {
    override TypeParameterized element;

    override PrintAstNode getChild(int childIndex) {
      childIndex = -100 and result.(TypeParametersNode).getTypeParameterized() = element
      or
      result = super.getChild(childIndex) and
      not result.(ElementNode).getElement() = element.getATypeParameter()
    }
  }

  /**
   * A `PrintAstNode` for functions.
   *
   * The children of this node is split into 6:
   * - The identifier (name) of the function.
   * - An aggregate node for all the parameters of the function.
   * - An aggregate node for all the type parameters of the function.
   * - The `this` type annotation.
   * - The return type annotation.
   * - The body
   */
  class FunctionNode extends TypeParameterizedNode {
    override Function element;

    override PrintAstNode getChild(int childIndex) {
      childIndex = 0 and result.(ElementNode).getElement() = element.getIdentifier()
      or
      childIndex = 1 and
      result.(ParametersNode).getFunction() = element and
      exists(element.getAParameter())
      or
      childIndex = 2 and
      result.(TypeParametersNode).getTypeParameterized() = element and
      exists(element.getATypeParameter())
      or
      childIndex = 3 and result.(ElementNode).getElement() = element.getThisTypeAnnotation()
      or
      childIndex = 4 and result.(ElementNode).getElement() = element.getReturnTypeAnnotation()
      or
      childIndex = 5 and result.(ElementNode).getElement() = element.getBody()
    }
  }

  /**
   * A `PrintAstNode` for parameters.
   *
   * This node puts the type-annotation and default value of a parameter as children of the parameter itself.
   * Instead of the default behavior (from `ElementNode`) where they would be children of the function.
   */
  class ParameterNode extends ElementNode {
    override Parameter element;

    override AstNode getChildNode(int childIndex) {
      result = super.getChildNode(childIndex) // in case the parameter is a destructuring pattern
      or
      childIndex = -2 and result = element.getTypeAnnotation()
      or
      childIndex = -1 and result = element.getDefault()
    }
  }

  /**
   * An aggregate node representing all the parameters in a function.
   */
  class ParametersNode extends PrintAstNode, TParametersNode {
    Function f;

    ParametersNode() { this = TParametersNode(f) and exists(f.getAParameter()) }

    override string toString() { result = "(Parameters)" }

    /**
     * Gets the `Function` for which this node represents the parameters.
     */
    Function getFunction() { result = f }

    override PrintAstNode getChild(int childIndex) {
      result.(ElementNode).getElement() = f.getParameter(childIndex)
    }
  }

  /**
   * An aggregate node representing all the type parameters in a function.
   */
  class TypeParametersNode extends PrintAstNode, TTypeParametersNode {
    TypeParameterized f;

    TypeParametersNode() { this = TTypeParametersNode(f) and exists(f.getATypeParameter()) }

    override string toString() { result = "(TypeParameters)" }

    /**
     * Gets the `Function` for which this node represents the type-parameters.
     */
    TypeParameterized getTypeParameterized() { result = f }

    override PrintAstNode getChild(int childIndex) {
      result.(ElementNode).getElement() = f.getTypeParameter(childIndex)
    }
  }
}

/**
 * Classes for printing JSON AST.
 */
private module PrintJson {
  /**
   * A print node representing a JSON value in a .json file.
   */
  class JsonNode extends PrintAstNode, TJsonNode {
    JsonValue value;

    JsonNode() { this = TJsonNode(value) }

    override string toString() { result = getQlClass(value) + PrettyPrinting::print(value) }

    override Location getLocation() { result = value.getLocation() }

    /**
     * Gets the `JSONValue` represented by this node.
     */
    final JsonValue getValue() { result = value }

    override PrintAstNode getChild(int childIndex) {
      exists(JsonValue child | result.(JsonNode).getValue() = child |
        child = value.getChild(childIndex)
      )
    }
  }

  /** Provied predicates for pretty printing JSON. */
  private module PrettyPrinting {
    /**
     * Gets a string representation of `n`.
     * Either using the default `JSONValue::toString`, or a custom printing of the JSON value.
     */
    string print(JsonValue n) {
      shouldPrint(n, _) and
      (
        result = n.toString().regexpReplaceAll("(\\\\n|\\\\r|\\\\t| )+", " ") and
        not exists(repr(n))
        or
        result = repr(n)
      )
    }

    /** Gets a string representing `n`. */
    private string repr(JsonValue n) {
      shouldPrint(n, _) and
      (
        exists(JsonObject obj, string name, JsonValue prop | obj = n |
          prop = obj.getPropValue(name) and
          prop = obj.getChild(0) and
          result = "{" + name + ": ...}"
        )
        or
        n instanceof JsonObject and not exists(n.getChild(_)) and result = "{}"
        or
        result = n.(JsonPrimitiveValue).getRawValue()
        or
        exists(JsonArray arr | arr = n |
          result = "[]" and not exists(arr.getChild(_))
          or
          result = "[" + repr(arr.getChild(0)) + "]" and not exists(arr.getChild(1))
          or
          result = "[" + repr(arr.getChild(0)) + ", ...]" and exists(arr.getChild(1))
        )
      )
    }
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

    override string toString() { result = getQlClass(node) + node.toString() }

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

/**
 * Classes for printing HTML AST.
 */
module PrintHtml {
  /**
   * A print node representing an HTML node in a .html file.
   */
  class HtmlElementNode extends PrintAstNode, THtmlElementNode {
    HTML::Element element;

    HtmlElementNode() { this = THtmlElementNode(element) }

    override string toString() { result = getQlClass(element) + "<" + element.getName() + " ..." }

    override Location getLocation() { result = element.getLocation() }

    /**
     * Gets the `HTML::Element` represented by this node.
     */
    final HTML::Element getElement() { result = element }

    override PrintAstNode getChild(int childIndex) {
      childIndex = -1 and result.(HtmlAttributesNodes).getElement() = element
      or
      exists(HTML::Element child | result.(HtmlElementNode).getElement() = child |
        child = element.getChild(childIndex)
      )
    }
  }

  /**
   * A print node representing an HTML node in a .html file.
   */
  class HtmlScriptElementNode extends HtmlElementNode {
    override HTML::ScriptElement element;

    override PrintAstNode getChild(int childIndex) {
      childIndex = -200 and result.(HtmlScript).getScript() = element.getScript()
      or
      result = super.getChild(childIndex)
    }
  }

  /**
   * A print node representing the code inside a `<script>` element.
   */
  class HtmlScript extends PrintAstNode, THtmlScript {
    Script script;

    HtmlScript() {
      this = THtmlScript(script) and
      any(HtmlScriptElementNode se).getElement().(HTML::ScriptElement).getScript() = script
    }

    override string toString() { result = "(Script)" }

    override Location getLocation() { result = script.getLocation() }

    /**
     * Gets the `Script` for which this node represents code.
     */
    Script getScript() { result = script }

    override PrintAstNode getChild(int childIndex) {
      result.(PrintJavaScript::ElementNode).getElement() = script.getChild(childIndex)
    }
  }

  /**
   * A print node representing the code inside an attribute.
   */
  class HtmlCodeInAttr extends PrintAstNode, THtmlCodeInAttr {
    CodeInAttribute attr;

    HtmlCodeInAttr() {
      this = THtmlCodeInAttr(attr) and
      any(HtmlAttributeNode an).getAttribute().getCodeInAttribute() = attr
    }

    override string toString() { result = "(Script)" }

    override Location getLocation() { result = attr.getLocation() }

    /**
     * Gets the `CodeInAttribute` for which this node represents code.
     */
    CodeInAttribute getCode() { result = attr }

    override PrintAstNode getChild(int childIndex) {
      result.(PrintJavaScript::ElementNode).getElement() = attr.getChild(childIndex)
    }
  }

  /**
   * An aggregate node representing all the attributes of an HTMLElement.
   */
  class HtmlAttributesNodes extends PrintAstNode, THtmlAttributesNodes {
    HTML::Element element;

    HtmlAttributesNodes() {
      this = THtmlAttributesNodes(element) and exists(element.getAttribute(_))
    }

    override string toString() { result = "(Attributes)" }

    /**
     * Gets the `HTMLElement` for which this node represents the attributes.
     */
    HTML::Element getElement() { result = element }

    override PrintAstNode getChild(int childIndex) {
      result.(HtmlAttributeNode).getAttribute() = element.getAttribute(childIndex)
    }
  }

  /**
   * A print node representing an HTML attribute in a .html file.
   */
  class HtmlAttributeNode extends PrintAstNode, THtmlAttributeNode {
    HTML::Attribute attr;

    HtmlAttributeNode() { this = THtmlAttributeNode(attr) }

    override string toString() { result = getQlClass(attr) + attr.toString() }

    override Location getLocation() { result = attr.getLocation() }

    /**
     * Gets the `HTMLAttribute` represented by this node.
     */
    final HTML::Attribute getAttribute() { result = attr }

    override PrintAstNode getChild(int childIndex) {
      childIndex = 0 and result.(HtmlCodeInAttr).getCode() = attr.getCodeInAttribute()
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
