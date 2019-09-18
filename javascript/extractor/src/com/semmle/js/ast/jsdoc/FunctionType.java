package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** A function type expression. */
public class FunctionType extends JSDocTypeExpression {
  private final JSDocTypeExpression _this;
  private final boolean _new;
  private final List<JSDocTypeExpression> params;
  private final JSDocTypeExpression result;

  public FunctionType(
      SourceLocation loc,
      JSDocTypeExpression _this,
      Boolean _new,
      List<JSDocTypeExpression> params,
      JSDocTypeExpression result) {
    super(loc, "FunctionType");
    this._this = _this;
    this._new = _new == Boolean.TRUE;
    this.params = params;
    this.result = result;
  }

  @Override
  public String pp() {
    StringBuilder sb = new StringBuilder();

    sb.append("function (");

    if (_this != null) {
      if (_new) {
        sb.append("new: ");
      } else {
        sb.append("this: ");
      }
      sb.append(_this.pp());
    }

    for (JSDocTypeExpression param : params) {
      if (sb.length() > 10) sb.append(", ");
      sb.append(param.pp());
    }

    sb.append(")");

    if (result != null) {
      sb.append(": ");
      sb.append(result.pp());
    }

    return sb.toString();
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /**
   * Does this function type expression specify a receiver type, that is, a type for <code>this
   * </code>?
   */
  public boolean hasThis() {
    return _this != null;
  }

  /** Get the receiver type for this function expression; may be null. */
  public JSDocTypeExpression getThis() {
    return _this;
  }

  /** Is this a constructor type? */
  public boolean isNew() {
    return _new;
  }

  /** The parameter types of the function. */
  public List<JSDocTypeExpression> getParams() {
    return params;
  }

  /** Does this function type specify a result type? */
  public boolean hasResult() {
    return result != null;
  }

  /** The result type of the function; may be null. */
  public JSDocTypeExpression getResult() {
    return result;
  }
}
