package com.semmle.js.ast;

import com.semmle.util.data.StringUtil;
import java.util.ArrayList;
import java.util.List;

/**
 * A property in an object literal or an object pattern.
 *
 * <p>This includes both regular properties as well as accessor properties, method properties,
 * properties with computed names, and spread/rest properties.
 */
public class Property extends Node {
  public static enum Kind {
    /** Either a normal property or a spread/rest property. */
    INIT(false),

    /** Getter property. */
    GET(true),

    /** Setter property. */
    SET(true);

    public final boolean isAccessor;

    private Kind(boolean isAccessor) {
      this.isAccessor = isAccessor;
    }
  };

  private final Expression key;
  private final Expression value, rawValue;
  private final Expression defaultValue; // only applies to property patterns
  private final Kind kind;
  private final boolean computed, method;
  private final List<Decorator> decorators;

  public Property(
      SourceLocation loc,
      Expression key,
      Expression rawValue,
      String kind,
      Boolean computed,
      Boolean method) {
    super("Property", loc);
    this.key = key;
    if (rawValue instanceof AssignmentPattern) {
      AssignmentPattern ap = (AssignmentPattern) rawValue;
      if (ap.getLeft() == key)
        rawValue =
            ap =
                new AssignmentPattern(
                    ap.getLoc(), ap.getOperator(), new NodeCopier().copy(key), ap.getRight());
      this.value = ap.getLeft();
      this.defaultValue = ap.getRight();
    } else {
      this.value = rawValue == key ? new NodeCopier().copy(rawValue) : rawValue;
      this.defaultValue = null;
    }
    this.rawValue = rawValue;
    this.kind = Kind.valueOf(StringUtil.uc(kind));
    this.computed = computed == Boolean.TRUE;
    this.method = method == Boolean.TRUE;
    this.decorators = new ArrayList<Decorator>();
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /**
   * The key of this property; usually a {@link Literal} or an {@link Identifier}, but may be an
   * arbitrary expression for properties with computed names. For spread/rest properties this method
   * returns {@code null}.
   */
  public Expression getKey() {
    return key;
  }

  /** The value expression of this property. */
  public Expression getValue() {
    return value;
  }

  /** The default value of this property pattern. */
  public Expression getDefaultValue() {
    return defaultValue;
  }

  /** Is this a property pattern with a default value? */
  public boolean hasDefaultValue() {
    return defaultValue != null;
  }

  /** The kind of this property. */
  public Kind getKind() {
    return kind;
  }

  /** Is the name of this property computed? */
  public boolean isComputed() {
    return computed;
  }

  /** Is this property declared using method syntax? */
  public boolean isMethod() {
    return method;
  }

  /** Is this property declared using shorthand syntax? */
  public boolean isShorthand() {
    return key != null && key.getLoc().equals(value.getLoc());
  }

  /**
   * The raw value expression of this property; if this property is a property pattern with a
   * default value, this method returns an {@link AssignmentPattern}.
   */
  public Expression getRawValue() {
    return rawValue;
  }

  public void addDecorators(List<Decorator> decorators) {
    this.decorators.addAll(decorators);
  }

  public List<Decorator> getDecorators() {
    return this.decorators;
  }
}
