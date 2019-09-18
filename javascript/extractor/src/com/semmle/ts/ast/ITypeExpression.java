package com.semmle.ts.ast;

import com.semmle.js.ast.INode;
import com.semmle.js.ast.Literal;

/**
 * An AST node that may occur as part of a TypeScript type annotation.
 *
 * <p>At the QL level, expressions and type annotations are completely separate. In the extractor,
 * however, some expressions such as {@link Literal} type may occur in a type annotation because the
 * TypeScript AST does not distinguish <tt>null</tt> literals from the <tt>null</tt> type.
 */
public interface ITypeExpression extends INode, ITypedAstNode {}
