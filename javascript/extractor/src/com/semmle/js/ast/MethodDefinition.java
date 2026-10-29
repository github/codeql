package com.semmle.js.ast;

import java.util.ArrayList;
import java.util.List;

public class MethodDefinition extends MemberDefinition<FunctionExpression> {
  public enum Kind {
    CONSTRUCTOR,
    METHOD,
    GET,
    SET,
    FUNCTION_CALL_SIGNATURE,
    CONSTRUCTOR_CALL_SIGNATURE,
    INDEX_SIGNATURE
  };

  private final Kind kind;
  private final List<FieldDefinition> parameterFields;

  public MethodDefinition(
      SourceLocation loc, int flags, Kind kind, Expression key, FunctionExpression value) {
    this(loc, flags, kind, key, value, new ArrayList<>());
  }

  public MethodDefinition(
      SourceLocation loc,
      int flags,
      Kind kind,
      Expression key,
      FunctionExpression value,
      List<FieldDefinition> parameterFields) {
    super("MethodDefinition", loc, flags, key, value);
    this.kind = kind;
    this.parameterFields = parameterFields;
  }

  public Kind getKind() {
    return kind;
  }

  @Override
  public boolean isCallSignature() {
    return kind == Kind.FUNCTION_CALL_SIGNATURE || kind == Kind.CONSTRUCTOR_CALL_SIGNATURE;
  }

  @Override
  public boolean isIndexSignature() {
    return kind == Kind.INDEX_SIGNATURE;
  }

  @Override
  public boolean isConstructor() {
    return !isStatic() && !isComputed() && "constructor".equals(getName());
  }

  @Override
  public boolean isConcrete() {
    return getValue().getBody() != null;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  /**
   * Returns the parameter fields synthesized for initializing constructor parameters, if this is a
   * constructor, or an empty list otherwise.
   *
   * <p>The index in this list does not correspond to the parameter index, as there can be ordinary
   * parameters interleaved with parameter fields.
   */
  public List<FieldDefinition> getParameterFields() {
    return parameterFields;
  }
}
