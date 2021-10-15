package com.semmle.js.ast;

import java.util.ArrayList;
import java.util.List;

/**
 * A member definition in a {@linkplain ClassBody}.
 *
 * <p>A member definition has a name and an optional initial value, whose type is given by the type
 * parameter {@code V}.
 */
public abstract class MemberDefinition<V extends Node> extends Node {
  /** A bitmask of flags defined in {@linkplain DeclarationFlags}. */
  private final int flags;

  /**
   * The name of the member.
   *
   * <p>If {@link #isComputed()} is false, this must be an {@link Identifier}, otherwise it can be
   * an arbitrary expression.
   */
  private final Expression key;

  /** The initial value / initializer of the member. */
  private final V value;

  /** The decorators applied to this member, if any. */
  private final List<Decorator> decorators;

  public MemberDefinition(String type, SourceLocation loc, int flags, Expression key, V value) {
    super(type, loc);
    this.flags = flags;
    this.key = key;
    this.value = value;
    this.decorators = new ArrayList<Decorator>();
  }

  /** Returns the flags, as defined by {@linkplain DeclarationFlags}. */
  public int getFlags() {
    return flags;
  }

  /** Returns true if this has the <code>static</code> modifier. */
  public boolean isStatic() {
    return DeclarationFlags.isStatic(flags);
  }

  /** Returns true if the member name is computed. */
  public boolean isComputed() {
    return DeclarationFlags.isComputed(flags);
  }

  /** Returns true if this is an abstract member. */
  public boolean isAbstract() {
    return DeclarationFlags.isAbstract(flags);
  }

  /** Returns true if has the <code>public</code> modifier (not true for implicitly public members). */
  public boolean hasPublicKeyword() {
    return DeclarationFlags.isPublic(flags);
  }

  /** Returns true if this is a private member. */
  public boolean hasPrivateKeyword() {
    return DeclarationFlags.isPrivate(flags);
  }

  /** Returns true if this is a protected member. */
  public boolean hasProtectedKeyword() {
    return DeclarationFlags.isProtected(flags);
  }

  /** Returns true if this is a readonly member. */
  public boolean hasReadonlyKeyword() {
    return DeclarationFlags.isReadonly(flags);
  }

  /** Returns true if this has the <code>declare</code> modifier. */
  public boolean hasDeclareKeyword() {
    return DeclarationFlags.hasDeclareKeyword(flags);
  }

  /**
   * Returns the expression denoting the name of the member, or {@code null} if this is a
   * call/construct signature.
   */
  public Expression getKey() {
    return key;
  }

  public V getValue() {
    return value;
  }

  /** The name of the method, if it can be determined. */
  public String getName() {
    if (!isComputed() && key instanceof Identifier) return ((Identifier) key).getName();
    if (key instanceof Literal) return ((Literal) key).getStringValue();
    return null;
  }

  /** True if this is a constructor; does not hold for construct signatures. */
  public boolean isConstructor() {
    return false;
  }

  /** True if this is a non-abstract field or a method with a body. */
  public abstract boolean isConcrete();

  public boolean isCallSignature() {
    return false;
  }

  public boolean isIndexSignature() {
    return false;
  }

  public void addDecorators(List<Decorator> decorators) {
    this.decorators.addAll(decorators);
  }

  public List<Decorator> getDecorators() {
    return this.decorators;
  }

  public boolean isParameterField() {
    return false;
  }
}
