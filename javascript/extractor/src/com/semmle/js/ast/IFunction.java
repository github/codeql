package com.semmle.js.ast;

import com.semmle.ts.ast.DecoratorList;
import com.semmle.ts.ast.INodeWithSymbol;
import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.ITypedAstNode;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.util.data.IntList;
import java.util.List;

/** A function declaration or expression. */
public interface IFunction extends IStatementContainer, INodeWithSymbol, ITypedAstNode {
  /** The function name; may be null for function expressions. */
  public Identifier getId();

  /** The parameters of the function, not including the rest parameter. */
  public List<IPattern> getParams();

  /** The parameters of the function, including the rest parameter. */
  public List<IPattern> getAllParams();

  /** Does the i'th parameter have a default expression? */
  public boolean hasDefault(int i);

  /** The default expression for the i'th parameter; may be null. */
  public Expression getDefault(int i);

  /** The rest parameter of this function; may be null. */
  public IPattern getRest();

  /**
   * The body of the function; usually a {@link BlockStatement}, but may be an {@link Expression}
   * for function expressions.
   */
  public Node getBody();

  /** Does this function have a rest parameter? */
  public boolean hasRest();

  /** Is this function a generator function? */
  public boolean isGenerator();

  /**
   * The raw parameters of this function; parameters with defaults are represented as {@link
   * AssignmentPattern}s and the rest parameter (if any) as a {@link RestElement}.
   */
  public List<Expression> getRawParameters();

  /** Is this function an asynchronous function? */
  public boolean isAsync();

  /** The return type of the function, if any. */
  public ITypeExpression getReturnType();

  /** Does the i'th parameter have a type annotation? */
  public boolean hasParameterType(int i);

  /** The type annotation for the i'th parameter; may be null. */
  public ITypeExpression getParameterType(int i);

  public List<TypeParameter> getTypeParameters();

  public ITypeExpression getThisParameterType();

  public List<DecoratorList> getParameterDecorators();

  public boolean hasDeclareKeyword();

  /**
   * Gets the type signature of this function as determined by the TypeScript compiler, or -1 if no
   * call signature was extracted.
   *
   * <p>The ID refers to a signature in a table that is extracted on a per-project basis, and the
   * meaning of this type ID is not available at the AST level.
   */
  public int getDeclaredSignatureId();

  public void setDeclaredSignatureId(int id);

  public IntList getOptionalParameterIndices();
}
