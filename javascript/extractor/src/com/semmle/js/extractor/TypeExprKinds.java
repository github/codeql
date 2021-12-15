package com.semmle.js.extractor;

import com.semmle.jcorn.TokenType;
import com.semmle.js.ast.DefaultVisitor;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.Literal;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.TemplateElement;
import com.semmle.js.extractor.ASTExtractor.IdContext;
import com.semmle.ts.ast.ArrayTypeExpr;
import com.semmle.ts.ast.ConditionalTypeExpr;
import com.semmle.ts.ast.FunctionTypeExpr;
import com.semmle.ts.ast.GenericTypeExpr;
import com.semmle.ts.ast.ImportTypeExpr;
import com.semmle.ts.ast.IndexedAccessTypeExpr;
import com.semmle.ts.ast.InferTypeExpr;
import com.semmle.ts.ast.InterfaceTypeExpr;
import com.semmle.ts.ast.IntersectionTypeExpr;
import com.semmle.ts.ast.KeywordTypeExpr;
import com.semmle.ts.ast.MappedTypeExpr;
import com.semmle.ts.ast.OptionalTypeExpr;
import com.semmle.ts.ast.ParenthesizedTypeExpr;
import com.semmle.ts.ast.PredicateTypeExpr;
import com.semmle.ts.ast.RestTypeExpr;
import com.semmle.ts.ast.TemplateLiteralTypeExpr;
import com.semmle.ts.ast.TupleTypeExpr;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.ts.ast.TypeofTypeExpr;
import com.semmle.ts.ast.UnaryTypeExpr;
import com.semmle.ts.ast.UnionTypeExpr;
import com.semmle.util.exception.CatastrophicError;

public class TypeExprKinds {
  private static final int simpleTypeAccess = 0;
  private static final int typeDecl = 1;
  private static final int keywordTypeExpr = 2;
  private static final int stringLiteralTypeExpr = 3;
  private static final int numberLiteralTypeExpr = 4;
  private static final int booeleanLiteralTypeExpr = 5;
  private static final int arrayTypeExpr = 6;
  private static final int unionTypeExpr = 7;
  private static final int indexedAccessTypeExpr = 8;
  private static final int intersectionTypeExpr = 9;
  private static final int parenthesizedTypeExpr = 10;
  private static final int tupleTypeExpr = 11;
  private static final int keyofTypeExpr = 12;
  private static final int qualifiedTypeAccess = 13;
  private static final int genericTypeExpr = 14;
  private static final int typeLabel = 15;
  private static final int typeofTypeExpr = 16;
  private static final int simpleVarTypeAccess = 17;
  private static final int qualifiedVarTypeAccess = 18;
  private static final int thisVarTypeAccess = 19;
  private static final int isTypeExpr = 20;
  private static final int interfaceTypeExpr = 21;
  private static final int typeParameter = 22;
  private static final int plainFunctionTypeExpr = 23;
  private static final int constructorTypeExpr = 24;
  private static final int simpleNamespaceAccess = 25;
  private static final int qualifiedNamespaceAccess = 26;
  private static final int mappedTypeExpr = 27;
  private static final int conditionalTypeExpr = 28;
  private static final int inferTypeExpr = 29;
  private static final int importTypeAccess = 30;
  private static final int importNamespaceAccess = 31;
  private static final int importVarTypeAccess = 32;
  private static final int optionalTypeExpr = 33;
  private static final int restTypeExpr = 34;
  private static final int bigintLiteralTypeExpr = 35;
  private static final int readonlyTypeExpr = 36;
  private static final int templateLiteralTypeExpr = 37;

  public static int getTypeExprKind(final INode type, final IdContext idcontext) {
    Integer kind =
        type.accept(
            new DefaultVisitor<Void, Integer>() {
              @Override
              public Integer visit(Identifier nd, Void c) {
                switch (idcontext) {
                  case TYPE_DECL:
                    return TypeExprKinds.typeDecl;
                  case TYPE_BIND:
                    return simpleTypeAccess;
                  case VAR_IN_TYPE_BIND:
                    return simpleVarTypeAccess;
                  case NAMESPACE_BIND:
                    return simpleNamespaceAccess;
                  default:
                    return typeLabel;
                }
              }

              @Override
              public Integer visit(KeywordTypeExpr nd, Void c) {
                if (idcontext == IdContext.VAR_IN_TYPE_BIND && nd.getKeyword().equals("this")) {
                  return thisVarTypeAccess;
                }
                return keywordTypeExpr;
              }

              @Override
              public Integer visit(ArrayTypeExpr nd, Void c) {
                return arrayTypeExpr;
              }

              @Override
              public Integer visit(UnionTypeExpr nd, Void c) {
                return unionTypeExpr;
              }

              @Override
              public Integer visit(IndexedAccessTypeExpr nd, Void c) {
                return indexedAccessTypeExpr;
              }

              @Override
              public Integer visit(IntersectionTypeExpr nd, Void c) {
                return intersectionTypeExpr;
              }

              @Override
              public Integer visit(ParenthesizedTypeExpr nd, Void c) {
                return parenthesizedTypeExpr;
              }

              @Override
              public Integer visit(TupleTypeExpr nd, Void c) {
                return tupleTypeExpr;
              }

              @Override
              public Integer visit(UnaryTypeExpr nd, Void c) {
                switch (nd.getKind()) {
                  case KEYOF:
                    return keyofTypeExpr;
                  case READONLY:
                    return readonlyTypeExpr;
                }
                throw new CatastrophicError("Unhandled UnaryTypeExpr kind: " + nd.getKind());
              }

              @Override
              public Integer visit(MemberExpression nd, Void c) {
                if (idcontext == IdContext.VAR_IN_TYPE_BIND) {
                  return qualifiedVarTypeAccess;
                } else if (idcontext == IdContext.NAMESPACE_BIND) {
                  return qualifiedNamespaceAccess;
                } else {
                  return qualifiedTypeAccess;
                }
              }

              @Override
              public Integer visit(GenericTypeExpr nd, Void c) {
                return genericTypeExpr;
              }

              @Override
              public Integer visit(TypeofTypeExpr nd, Void c) {
                return typeofTypeExpr;
              }

              @Override
              public Integer visit(PredicateTypeExpr nd, Void c) {
                return isTypeExpr;
              }

              @Override
              public Integer visit(InterfaceTypeExpr nd, Void c) {
                return interfaceTypeExpr;
              }

              @Override
              public Integer visit(Literal nd, Void c) {
                TokenType type = nd.getTokenType();
                if (nd.getValue() == null) {
                  // We represent the null type as a keyword type in QL, but in the extractor AST
                  // it is a Literal because the TypeScript AST does not distinguish those.
                  //
                  // Main reasons not to expose the null type as a literal type:
                  // - TypeScript documentation does not treat the null type as a literal type.
                  // - There is an "undefined" type, but there is no "undefined" literal.
                  return keywordTypeExpr;
                } else if (type == TokenType.string) {
                  return stringLiteralTypeExpr;
                } else if (type == TokenType.num) {
                  return numberLiteralTypeExpr;
                } else if (type == TokenType._true || type == TokenType._false) {
                  return booeleanLiteralTypeExpr;
                } else if (type == TokenType.bigint) {
                  return bigintLiteralTypeExpr;
                } else {
                  throw new CatastrophicError(
                      "Unsupported literal type expression kind: " + nd.getValue().getClass());
                }
              }

              @Override
              public Integer visit(TypeParameter nd, Void c) {
                return typeParameter;
              }

              @Override
              public Integer visit(FunctionTypeExpr nd, Void c) {
                return nd.isConstructor() ? constructorTypeExpr : plainFunctionTypeExpr;
              }

              @Override
              public Integer visit(MappedTypeExpr nd, Void c) {
                return mappedTypeExpr;
              }

              @Override
              public Integer visit(ConditionalTypeExpr nd, Void c) {
                return conditionalTypeExpr;
              }

              @Override
              public Integer visit(InferTypeExpr nd, Void c) {
                return inferTypeExpr;
              }

              @Override
              public Integer visit(ImportTypeExpr nd, Void c) {
                switch (idcontext) {
                  case NAMESPACE_BIND:
                    return importNamespaceAccess;
                  case TYPE_BIND:
                    return importTypeAccess;
                  case VAR_IN_TYPE_BIND:
                    return importVarTypeAccess;
                  default:
                    return importTypeAccess;
                }
              }

              @Override
              public Integer visit(OptionalTypeExpr nd, Void c) {
                return optionalTypeExpr;
              }

              @Override
              public Integer visit(RestTypeExpr nd, Void c) {
                return restTypeExpr;
              }

              @Override
              public Integer visit(TemplateLiteralTypeExpr nd, Void c) {
                return templateLiteralTypeExpr;
              }

              @Override
              public Integer visit(TemplateElement nd, Void c) {
                return stringLiteralTypeExpr;
              }
            },
            null);
    if (kind == null)
      throw new CatastrophicError("Unsupported type expression kind: " + type.getClass());
    return kind;
  }
}
