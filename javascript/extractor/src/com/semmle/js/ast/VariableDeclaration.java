package com.semmle.js.ast;

import com.semmle.js.extractor.ExtractorConfig.ECMAVersion;
import java.util.List;

/**
 * A variable declaration statement containing one or more {@link VariableDeclarator} expressions.
 */
public class VariableDeclaration extends Statement {
  private final String kind;
  private final List<VariableDeclarator> declarations;
  private final boolean hasDeclareKeyword;

  public VariableDeclaration(
      SourceLocation loc,
      String kind,
      List<VariableDeclarator> declarations,
      boolean hasDeclareKeyword) {
    super("VariableDeclaration", loc);
    this.kind = kind;
    this.declarations = declarations;
    this.hasDeclareKeyword = hasDeclareKeyword;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /**
   * The kind of this variable declaration statement; one of <code>"var"</code>, <code>"let"</code>,
   * <code>"const"</code>, or <code>"using"</code>.
   */
  public String getKind() {
    return kind;
  }

  /**
   * Is this a block-scoped declaration?
   *
   * <p>Note that <code>const</code> declarations are function-scoped pre-ECMAScript 2015.
   */
  public boolean isBlockScoped(ECMAVersion ecmaVersion) {
    return "let".equals(kind)
        || "using".equals(kind)
        || ecmaVersion.compareTo(ECMAVersion.ECMA2015) >= 0 && "const".equals(kind);
  }

  /** The declarations in this declaration statement. */
  public List<VariableDeclarator> getDeclarations() {
    return declarations;
  }

  public boolean hasDeclareKeyword() {
    return hasDeclareKeyword;
  }
}
