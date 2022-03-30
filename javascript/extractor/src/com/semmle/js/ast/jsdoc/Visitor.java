package com.semmle.js.ast.jsdoc;

/** Interface for visitors on {@link JSDocElement}. */
public interface Visitor {
  public void visit(AllLiteral nd);

  public void visit(ArrayType nd);

  public void visit(JSDocComment nd);

  public void visit(JSDocTag nd);

  public void visit(NameExpression nd);

  public void visit(NullableLiteral nd);

  public void visit(NullLiteral nd);

  public void visit(UndefinedLiteral nd);

  public void visit(VoidLiteral nd);

  public void visit(UnionType nd);

  public void visit(TypeApplication nd);

  public void visit(FunctionType nd);

  public void visit(NonNullableType nd);

  public void visit(NullableType nd);

  public void visit(OptionalType nd);

  public void visit(RestType nd);

  public void visit(RecordType nd);

  public void visit(FieldType nd);

  public void visit(ParameterType nd);
}
