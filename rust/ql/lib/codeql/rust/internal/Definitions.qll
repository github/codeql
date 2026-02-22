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

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

cached
private module Cached {
  cached
  newtype TDef =
    TVariable(Variable v) or
    TFormatArgsArgName(Name name) { name = any(FormatArgsArg a).getName() } or
    TFormatArgsArgIndex(Expr e) { e = any(FormatArgsArg a).getExpr() } or
    TItemNode(ItemNode i)

  pragma[nomagic]
  private predicate isMacroCallLocation(Location loc) { loc = any(MacroCall m).getLocation() }

  /**
   * Gets an element, of kind `kind`, that element `use` uses, if any.
   */
  cached
  Definition definitionOf(Use use, string kind) {
    result = use.getDefinition() and
    kind = use.getUseType() and
    not isMacroCallLocation(result.getLocation())
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
    result.asItemNode() = this.getCall().getResolvedTarget()
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

// We don't have entities for the operator symbols, so we approximate a location.
// The location spans are chosen so that they align with rust-analyzer's jump-to-def
// behavior in VS Code, which means using weird locations where the end column is
// before the start column in the case of unary prefix operations.
private predicate operatorHasLocationInfo(
  Operation o, string filepath, int startline, int startcolumn, int endline, int endcolumn
) {
  o =
    // `-x`; placing the cursor before `-` jumps to `neg`, placing it after jumps to `x`
    any(PrefixExpr pe |
      pe.getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
      endline = startline and
      endcolumn = startcolumn - 1
    )
  or
  o =
    // `x + y`: placing the cursor before or after `+` jumps to `add`
    // `x+ y`: placing the cursor before `+` jumps to `x`, after `+` jumps to `add`
    any(BinaryExpr be |
      be.getLhs().getLocation().hasLocationInfo(filepath, _, _, startline, startcolumn - 2) and
      be.getRhs().getLocation().hasLocationInfo(filepath, endline, endcolumn + 2, _, _) and
      (
        startline < endline
        or
        endcolumn = startcolumn
      )
    )
}

private class OperationUse extends Use instanceof Operation {
  OperationUse() { operatorHasLocationInfo(this, _, _, _, _, _) }

  override Definition getDefinition() { result.asItemNode() = this.(Call).getStaticTarget() }

  override string getUseType() { result = "method" }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    operatorHasLocationInfo(this, filepath, startline, startcolumn, endline, endcolumn)
  }
}

private class IndexExprUse extends Use instanceof IndexExpr {
  override Definition getDefinition() { result.asItemNode() = this.(Call).getStaticTarget() }

  override string getUseType() { result = "method" }

  // We don't have entities for the bracket symbols, so approximate a location
  // The location spans are chosen so that they align with rust-analyzer's jump-to-def
  // behavior in VS Code.
  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    // `x[y]`: placing the cursor after `]` jumps to `index`
    super.getIndex().getLocation().hasLocationInfo(filepath, _, _, startline, startcolumn - 2) and
    this.getLocation().hasLocationInfo(_, _, _, endline, endcolumn)
  }
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
