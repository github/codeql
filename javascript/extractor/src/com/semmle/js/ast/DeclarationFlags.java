package com.semmle.js.ast;

import java.util.Arrays;
import java.util.List;

/**
 * Defines bitmasks where each bit corresponds to a flag on {@linkplain MemberDefinition} or
 * {@linkplain VariableDeclarator}.
 */
public class DeclarationFlags {
  public static final int computed = 1 << 0;
  public static final int abstract_ = 1 << 1;
  public static final int static_ = 1 << 2;
  public static final int readonly = 1 << 3;
  public static final int public_ = 1 << 4;
  public static final int private_ = 1 << 5;
  public static final int protected_ = 1 << 6;
  public static final int optional = 1 << 7;
  public static final int definiteAssignmentAssertion = 1 << 8;
  public static final int declareKeyword = 1 << 9;

  public static final int none = 0;
  public static final int numberOfFlags = 10;

  public static final List<String> names =
      Arrays.asList(
          "computed",
          "abstract",
          "static",
          "readonly",
          "public",
          "private",
          "protected",
          "optional",
          "definiteAssignmentAssertion",
          "declare");

  public static final List<String> relationNames =
      Arrays.asList(
          "is_computed",
          "is_abstract_member",
          "is_static",
          "has_readonly_keyword",
          "has_public_keyword",
          "has_private_keyword",
          "has_protected_keyword",
          "is_optional_member",
          "has_definite_assignment_assertion",
          "has_declare_keyword");

  public static boolean isComputed(int flags) {
    return (flags & computed) != 0;
  }

  public static boolean isAbstract(int flags) {
    return (flags & abstract_) != 0;
  }

  public static boolean isStatic(int flags) {
    return (flags & static_) != 0;
  }

  public static boolean isReadonly(int flags) {
    return (flags & readonly) != 0;
  }

  public static boolean isPublic(int flags) {
    return (flags & public_) != 0;
  }

  public static boolean isPrivate(int flags) {
    return (flags & private_) != 0;
  }

  public static boolean isProtected(int flags) {
    return (flags & protected_) != 0;
  }

  public static boolean isOptional(int flags) {
    return (flags & optional) != 0;
  }

  public static boolean hasDefiniteAssignmentAssertion(int flags) {
    return (flags & definiteAssignmentAssertion) != 0;
  }

  public static boolean hasDeclareKeyword(int flags) {
    return (flags & declareKeyword) != 0;
  }

  /** Returns a mask with the computed bit set to the value of <code>enable</code>. */
  public static int getComputed(boolean enable) {
    return enable ? computed : 0;
  }

  /** Returns a mask with the abstract bit set to the value of <code>enable</code>. */
  public static int getAbstract(boolean enable) {
    return enable ? abstract_ : 0;
  }

  /** Returns a mask with the static bit set to the value of <code>enable</code>. */
  public static int getStatic(boolean enable) {
    return enable ? static_ : 0;
  }

  /** Returns a mask with the public bit set to the value of <code>enable</code>. */
  public static int getPublic(boolean enable) {
    return enable ? public_ : 0;
  }

  /** Returns a mask with the readonly bit set to the value of <code>enable</code>. */
  public static int getReadonly(boolean enable) {
    return enable ? readonly : 0;
  }

  /** Returns a mask with the private bit set to the value of <code>enable</code>. */
  public static int getPrivate(boolean enable) {
    return enable ? private_ : 0;
  }

  /** Returns a mask with the protected bit set to the value of <code>enable</code>. */
  public static int getProtected(boolean enable) {
    return enable ? protected_ : 0;
  }

  /** Returns a mask with the optional bit set to the value of <code>enable</code>. */
  public static int getOptional(boolean enable) {
    return enable ? optional : 0;
  }

  /**
   * Returns a mask with the definite assignment assertion bit set to the value of <code>enable</code>.
   */
  public static int getDefiniteAssignmentAssertion(boolean enable) {
    return enable ? definiteAssignmentAssertion : 0;
  }

  /** Returns a mask with the declare keyword bit set to the value of <code>enable</code>. */
  public static int getDeclareKeyword(boolean enable) {
    return enable ? declareKeyword : 0;
  }

  /** Returns true if the <code>n</code>th bit is set in <code>flags</code>. */
  public static boolean hasNthFlag(int flags, int n) {
    return (flags & (1 << n)) != 0;
  }

  public static String getFlagNames(int flags) {
    StringBuilder b = new StringBuilder();
    for (int i = 0; i < numberOfFlags; ++i) {
      if (hasNthFlag(flags, i)) {
        if (b.length() > 0) {
          b.append(", ");
        }
        b.append(names.get(i));
      }
    }
    return b.toString();
  }
}
