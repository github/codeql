/**
 * Provides classes and predicates related to jump-to-definition links
 * in the code viewer.
 */

private import rust
private import codeql.rust.elements.Variable
private import codeql.rust.elements.Locatable
private import codeql.rust.elements.FormatArgsExpr
private import codeql.rust.elements.FormatArgsArg
private import codeql.rust.elements.Format
private import codeql.rust.elements.MacroCall
private import codeql.rust.elements.NamedFormatArgument
private import codeql.rust.elements.PositionalFormatArgument
private import codeql.Locations
private import codeql.rust.internal.PathResolution

/** An element with an associated definition. */
abstract class Use extends Locatable {
  Use() { not this.(AstNode).isFromMacroExpansion() }

  /** Gets the definition associated with this element. */
  abstract Definition getDefinition();

  /**
   * Gets the type of use.
   */
  abstract string getUseType();
}

cached
private module Cached {
  cached
  newtype TDef =
    TVariable(Variable v) or
    TFormatArgsArgName(Name name) { name = any(FormatArgsArg a).getName() } or
    TFormatArgsArgIndex(Expr e) { e = any(FormatArgsArg a).getExpr() } or
    TItemNode(ItemNode i)

  /**
   * Gets an element, of kind `kind`, that element `use` uses, if any.
   */
  cached
  Definition definitionOf(Use use, string kind) {
    result = use.getDefinition() and
    kind = use.getUseType() and
    not result.getLocation() = any(MacroCall m).getLocation()
  }
}

predicate definitionOf = Cached::definitionOf/2;

/** A definition */
class Definition extends Cached::TDef {
  /** Gets the location of this variable. */
  Location getLocation() {
    result = this.asVariable().getLocation() or
    result = this.asName().getLocation() or
    result = this.asExpr().getLocation() or
    result = this.asItemNode().getLocation()
  }

  /** Gets this definition as a `Variable` */
  Variable asVariable() { this = Cached::TVariable(result) }

  /** Gets this definition as a `Name` */
  Name asName() { this = Cached::TFormatArgsArgName(result) }

  /** Gets this definition as an `Expr` */
  Expr asExpr() { this = Cached::TFormatArgsArgIndex(result) }

  /** Gets this definition as an `ItemNode` */
  ItemNode asItemNode() { this = Cached::TItemNode(result) }

  /** Gets the string representation of this element. */
  string toString() {
    result = this.asExpr().toString() or
    result = this.asVariable().toString() or
    result = this.asName().getText() or
    result = this.asItemNode().toString()
  }
}

private class LocalVariableUse extends Use instanceof VariableAccess {
  private Variable def;

  LocalVariableUse() { this = def.getAnAccess() }

  override Definition getDefinition() { result.asVariable() = def }

  override string getUseType() { result = "local variable" }
}

private class NamedFormatArgumentUse extends Use instanceof NamedFormatArgument {
  private Name def;

  NamedFormatArgumentUse() {
    exists(FormatArgsExpr parent |
      parent = this.getParent().getParent() and
      parent.getAnArg().getName() = def and
      this.getName() = def.getText()
    )
  }

  override Definition getDefinition() { result.asName() = def }

  override string getUseType() { result = "format argument" }
}

private class PositionalFormatUse extends Use instanceof Format {
  PositionalFormatUse() { not exists(this.getArgumentRef()) }

  override Definition getDefinition() {
    exists(FormatArgsExpr parent, int index | parent.getFormat(_) = this |
      this = rank[index + 1](PositionalFormatUse f, int i | parent.getFormat(i) = f | f order by i) and
      result.asExpr() = parent.getArg(index).getExpr()
    )
  }

  override string getUseType() { result = "format argument" }
}

private class PositionalFormatArgumentUse extends Use instanceof PositionalFormatArgument {
  private Expr def;

  PositionalFormatArgumentUse() {
    exists(FormatArgsExpr parent |
      parent = this.getParent().getParent() and
      def = parent.getArg(this.getIndex()).getExpr()
    )
  }

  override Definition getDefinition() { result.asExpr() = def }

  override string getUseType() { result = "format argument" }
}

private class PathUse extends Use instanceof NameRef {
  private Path path;

  PathUse() { this = path.getSegment().getIdentifier() }

  private CallExpr getCall() { result.getFunction().(PathExpr).getPath() = path }

  override Definition getDefinition() {
    // Our call resolution logic may disambiguate some calls, so only use those
    result.asItemNode() = this.getCall().getStaticTarget()
    or
    not exists(this.getCall()) and
    result.asItemNode() = resolvePath(path)
  }

  override string getUseType() { result = "path" }
}

private class MethodUse extends Use instanceof NameRef {
  private MethodCallExpr mc;

  MethodUse() { this = mc.getIdentifier() }

  override Definition getDefinition() { result.asItemNode() = mc.getStaticTarget() }

  override string getUseType() { result = "method" }
}

private class FileUse extends Use instanceof Name {
  override Definition getDefinition() {
    exists(Module m |
      this = m.getName() and
      fileImport(m, result.asItemNode())
    )
  }

  override string getUseType() { result = "file" }
}
