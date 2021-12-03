package com.semmle.js.ast;

import com.semmle.ts.ast.INodeWithSymbol;
import com.semmle.ts.ast.ITypeExpression;
import java.util.List;

/** An invocation, that is, either a {@link CallExpression} or a {@link NewExpression}. */
public abstract class InvokeExpression extends Expression implements INodeWithSymbol, Chainable {
  private final Expression callee;
  private final List<ITypeExpression> typeArguments;
  private final List<Expression> arguments;
  private final boolean optional;
  private final boolean onOptionalChain;
  private int resolvedSignatureId = -1;
  private int overloadIndex = -1;
  private int symbol = -1;

  public InvokeExpression(
      String type,
      SourceLocation loc,
      Expression callee,
      List<ITypeExpression> typeArguments,
      List<Expression> arguments,
      Boolean optional,
      Boolean onOptionalChain) {
    super(type, loc);
    this.callee = callee;
    this.typeArguments = typeArguments;
    this.arguments = arguments;
    this.optional = optional == Boolean.TRUE;
    this.onOptionalChain = onOptionalChain == Boolean.TRUE;
  }

  /** The callee expression of this invocation. */
  public Expression getCallee() {
    return callee;
  }

  /** The type arguments of this invocation. */
  public List<ITypeExpression> getTypeArguments() {
    return typeArguments;
  }

  /** The argument expressions of this invocation. */
  public List<Expression> getArguments() {
    return arguments;
  }

  @Override
  public boolean isOptional() {
    return optional;
  }

  @Override
  public boolean isOnOptionalChain() {
    return onOptionalChain;
  }

  public int getResolvedSignatureId() {
    return resolvedSignatureId;
  }

  public void setResolvedSignatureId(int resolvedSignatureId) {
    this.resolvedSignatureId = resolvedSignatureId;
  }

  public int getOverloadIndex() {
    return overloadIndex;
  }

  public void setOverloadIndex(int overloadIndex) {
    this.overloadIndex = overloadIndex;
  }

  @Override
  public int getSymbol() {
    return symbol;
  }

  @Override
  public void setSymbol(int symbol) {
    this.symbol = symbol;
  }
}
