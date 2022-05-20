package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A field type expression describing the type of a field in a record type. */
public class FieldType extends JSDocTypeExpression {
  private final String key;
  private final JSDocTypeExpression value;

  public FieldType(SourceLocation loc, String key, JSDocTypeExpression value) {
    super(loc, "FieldType");
    this.key = key;
    this.value = value;
  }

  /** The field name. */
  public String getKey() {
    return key;
  }

  /** Does this field type expression specify a type for the field? */
  public boolean hasValue() {
    return value != null;
  }

  /** Get the type expression for the field; may be null. */
  public JSDocTypeExpression getValue() {
    return value;
  }

  @Override
  public String pp() {
    if (value != null) return key + ": " + value.pp();
    else return key;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
