package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** A JSDoc block tag. */
public class JSDocTag extends JSDocElement {
  private final String title;
  private final String description;
  private final String name;
  private final JSDocTypeExpression type;
  private final List<String> errors;

  public JSDocTag(
      SourceLocation loc,
      String title,
      String description,
      String name,
      JSDocTypeExpression type,
      List<String> errors) {
    super(loc);
    this.title = title;
    this.description = description;
    this.name = name;
    this.type = type;
    this.errors = errors;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The type of this tag; e.g., <code>"param"</code> for a <code>@param</code> tag. */
  public String getTitle() {
    return title;
  }

  /** Does this tag have a description? */
  public boolean hasDescription() {
    return description != null;
  }

  /** The description of this tag; may be null. */
  public String getDescription() {
    return description;
  }

  /** Does this tag specify a name? */
  public boolean hasName() {
    return name != null;
  }

  /** The name this tag refers to; null except for <code>@param</code> tags. */
  public String getName() {
    return name;
  }

  /** The type expression this tag specifies; may be null. */
  public JSDocTypeExpression getType() {
    return type;
  }

  /** Does this tag specify a type expression? */
  public boolean hasType() {
    return type != null;
  }

  /** Errors encountered while parsing this tag. */
  public List<String> getErrors() {
    return errors;
  }
}
