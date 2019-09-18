package com.semmle.js.ast;

import com.semmle.ts.ast.ITypeExpression;

public class FieldDefinition extends MemberDefinition<Expression> {
  private final ITypeExpression typeAnnotation;
  private final int fieldParameterIndex;

  private static final int notFieldParameter = -1;

  public FieldDefinition(SourceLocation loc, int flags, Expression key, Expression value) {
    this(loc, flags, key, value, null);
  }

  public FieldDefinition(
      SourceLocation loc,
      int flags,
      Expression key,
      Expression value,
      ITypeExpression typeAnnotation) {
    this(loc, flags, key, value, typeAnnotation, notFieldParameter);
  }

  public FieldDefinition(
      SourceLocation loc,
      int flags,
      Expression key,
      Expression value,
      ITypeExpression typeAnnotation,
      int fieldParameterIndex) {
    super("FieldDefinition", loc, flags, key, value);
    this.typeAnnotation = typeAnnotation;
    this.fieldParameterIndex = fieldParameterIndex;
  }

  public ITypeExpression getTypeAnnotation() {
    return typeAnnotation;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public boolean isConcrete() {
    return !isAbstract();
  }

  @Override
  public boolean isParameterField() {
    return fieldParameterIndex != notFieldParameter;
  }

  /**
   * If this is a field parameter, returns the index of the parameter that generated it, or -1 if
   * this is not a field parameter.
   */
  public int getFieldParameterIndex() {
    return fieldParameterIndex;
  }
}
