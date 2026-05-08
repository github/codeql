/** Provides classes for representing type mentions, used in type inference. */

private import swift as Swift
private import Type
private import TypeAbstraction
private import TypeInference

private Type getTypeAt(Swift::Type t, TypePath path) {
  exists(Swift::Type u | u = t.getUnderlyingType() |
    path = "" and
    (
      result.(TypeDeclType).getDecl() = u.(AnyGenericType).getDeclaration()
      or
      result.(TypeDeclType).getDecl().getDeclaredInterfaceType() =
        u.(PrimaryArchetypeType).getInterfaceType()
      or
      result.(TypeDeclType).getDecl().(GenericTypeParamDecl).getDeclaredInterfaceType() = u
      or
      result = TTupleType(u.(Swift::TupleType).getNumberOfTypes())
    )
    or
    exists(BoundGenericType b, GenericTypeDecl decl |
      b = u and
      decl = b.getDeclaration()
    |
      exists(TypePath suffix, int i, GenericTypeParamDeclTypeParameter tp |
        result = getTypeAt(b.getArgType(i), suffix) and
        tp.getDecl() = decl.getGenericTypeParam(i) and
        path = TypePath::singleton(tp).append(suffix)
      )
    )
    or
    exists(Swift::TupleType tt | tt = u |
      exists(TypePath suffix, int i, TupleTypeTypeParameter tp |
        result = getTypeAt(tt.getType(i), suffix) and
        tp = TTupleTypeTypeParameter(tt.getNumberOfTypes(), i) and
        path = TypePath::singleton(tp).append(suffix)
      )
    )
  )
}

newtype TTypeMention =
  TGenericContextMention(GenericContext context) or
  TTypeDeclBaseTypeMention(TypeDecl decl, int i) { exists(decl.getInheritedType(i)) } or
  TExtensionDeclBaseTypeMention(ExtensionDecl decl, int i) { exists(decl.getProtocol(i)) } or
  TParamDeclTypeMention(ParamDecl decl) {
    // assume that all closure parameters are implicitly typed
    not decl = any(ClosureExpr ce).getAParam()
  } or
  TCallableReturnTypeMention(Callable c) or
  TTypedPatternTypeMention(TypedPattern p)

/** An AST node that may mention a type. */
abstract private class TypeMentionImpl extends TTypeMention {
  /** Gets the type at `path` that this type mention resolves to, if any. */
  pragma[nomagic]
  abstract Type getTypeAt(TypePath path);

  /** Gets the root type that this type mention resolves to. */
  pragma[nomagic]
  final Type getType() { result = this.getTypeAt(TypePath::nil()) }

  /** Gets a textual representation of this type mention. */
  abstract string toString();

  /** Gets the location of this type mention. */
  abstract Location getLocation();
}

final class TypeMention = TypeMentionImpl;

/**
 * A type mention corresponding to a declaration such as
 *
 * ```swift
 * class C<A, B> { }
 * //    ^^^^^^^ mentions the type `C<A, B>` itself
 * ```
 *
 * or an extension such as
 *
 * ```swift
 * extension Type { }
 * //        ^^^^ mentions the type `Type` itself
 *
 * extension Type: Protocol { }
 * //        ^^^^ mentions the type `Type` itself
 */
class GenericContextMention extends TypeMentionImpl, TGenericContextMention {
  GenericContext context;

  GenericContextMention() { this = TGenericContextMention(context) }

  GenericContext getContext() { result = context }

  override Type getTypeAt(TypePath path) {
    path.isEmpty() and
    result = TTypeDeclType(context)
    or
    exists(TypeDeclType t |
      context = t.getDecl() and
      result = t.getATypeParameter() and
      path = TypePath::singleton(result)
    )
    or
    result =
      getTypeAt(context.(ExtensionDecl).getExtendedTypeDecl().getDeclaredInterfaceType(), path)
  }

  override string toString() { result = context.toString() }

  override Location getLocation() { result = context.(Locatable).getLocation() }
}

/** A type mention corresponding to a base type of a type declaration. */
class TypeDeclBaseTypeMention extends TypeMentionImpl, TTypeDeclBaseTypeMention {
  TypeDecl decl;
  int index;

  TypeDeclBaseTypeMention() { this = TTypeDeclBaseTypeMention(decl, index) }

  TypeDecl getDecl() { result = decl }

  int getIndex() { result = index }

  override Type getTypeAt(TypePath path) { result = getTypeAt(decl.getInheritedType(index), path) }

  override string toString() { result = decl.getName() + " [base type " + index + "]" }

  override Location getLocation() { result = decl.getLocation() }
}

/** A type mention corresponding to a base type of an extension declaration. */
class ExtensionDeclBaseTypeMention extends TypeMentionImpl, TExtensionDeclBaseTypeMention {
  ExtensionDecl decl;
  int index;

  ExtensionDeclBaseTypeMention() { this = TExtensionDeclBaseTypeMention(decl, index) }

  ExtensionDecl getDecl() { result = decl }

  int getIndex() { result = index }

  override Type getTypeAt(TypePath path) {
    result = getTypeAt(decl.getProtocol(index).getDeclaredInterfaceType(), path)
  }

  override string toString() { result = decl.toString() + " [extended type " + index + "]" }

  override Location getLocation() { result = decl.getLocation() }
}

/** A type mention corresponding to a parameter with an explicit type. */
class ParamDeclTypeMention extends TypeMentionImpl, TParamDeclTypeMention {
  ParamDecl decl;

  ParamDeclTypeMention() { this = TParamDeclTypeMention(decl) }

  ParamDecl getDecl() { result = decl }

  override Type getTypeAt(TypePath path) {
    result = getTypeAt(decl.getType(), path)
    or
    result = TSelfTypeParameter(decl.(SelfParamDecl).getEnclosingDecl().getEnclosingDecl()) and
    path.isEmpty()
  }

  override string toString() { result = decl.toString() + " [parameter type]" }

  override Location getLocation() { result = decl.getLocation() }
}

/** A type mention corresponding to the return type of a callable. */
class CallableReturnTypeMention extends TypeMentionImpl, TCallableReturnTypeMention {
  Callable c;

  CallableReturnTypeMention() { this = TCallableReturnTypeMention(c) }

  Callable getCallable() { result = c }

  override Type getTypeAt(TypePath path) {
    exists(Swift::Type res, Swift::Type t |
      res = c.(ValueDecl).getInterfaceType().(AnyFunctionType).getResult() and
      t = [res.(FunctionType).getResult(), res.(Swift::TupleType)] and
      result = getTypeAt(t, path)
    )
  }

  override string toString() { result = c.toString() + " [return type]" }

  override Location getLocation() { result = c.getLocation() }
}

/** A type mention corresponding to a typed pattern. */
class TypedPatternTypeMention extends TypeMentionImpl, TTypedPatternTypeMention {
  TypedPattern p;

  TypedPatternTypeMention() { this = TTypedPatternTypeMention(p) }

  TypedPattern getPattern() { result = p }

  override Type getTypeAt(TypePath path) { result = getTypeAt(p.getType(), path) }

  override string toString() { result = p.toString() + " [pattern type]" }

  override Location getLocation() { result = p.getLocation() }
}
