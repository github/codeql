/**
 * Provides shared functionality for computing type inference in QL.
 *
 * The code examples in this file use C# syntax, but the concepts should
 * carry over to other languages as well.
 *
 * The library is initialized in two phases: `Make1`, which constructs
 * the `TypePath` type, and `Make2`, which (using `TypePath` in the input
 * signature) constructs the `Matching` module.
 */

private import codeql.util.Location

/** Provides the input to `Make1`. */
signature module InputSig1<LocationSig Location> {
  /**
   * A type without type arguments.
   *
   * For example `int` or ``IEnumerable`1``.
   */
  class Type {
    /** Gets a type parameter of this type, if any. */
    TypeParameter getATypeParameter();

    /** Gets a textual representation of this type. */
    string toString();

    /** Gets the location of this type. */
    Location getLocation();
  }

  /** A type parameter. */
  class TypeParameter extends Type;

  /**
   * Gets the unique identifier of type parameter `tp`.
   *
   * This is used to represent type paths `.`-separated type parameter
   * identifiers.
   */
  int getTypeParameterId(TypeParameter tp);

  /**
   * A type argument position, for example an integer.
   *
   * Type argument positions are used when type arguments are supplied explicitly,
   * for example in a method call like `M<int>()` the type argument `int` is at
   * position `0`.
   */
  bindingset[this]
  class TypeArgumentPosition {
    /** Gets the textual representation of this position. */
    bindingset[this]
    string toString();
  }

  /** A type parameter position, for example an integer. */
  bindingset[this]
  class TypeParameterPosition {
    /** Gets the textual representation of this position. */
    bindingset[this]
    string toString();
  }

  /** Holds if `tapos` and `tppos` match. */
  bindingset[tapos]
  bindingset[tppos]
  predicate typeArgumentParameterPositionMatch(
    TypeArgumentPosition tapos, TypeParameterPosition tppos
  );

  /**
   * Gets the limit on the length of type paths. Set to `none()` if there should
   * be no limit.
   *
   * Having a limit can be useful to avoid inifinite recursion on malformed
   * programs.
   */
  default int getTypePathLimit() { result = 10 }
}

module Make1<LocationSig Location, InputSig1<Location> Input1> {
  private import Input1

  private module TypeParameter {
    private import codeql.util.DenseRank

    private module DenseRankInput implements DenseRankInputSig {
      class Ranked = TypeParameter;

      predicate getRank = getTypeParameterId/1;
    }

    private int getTypeParameterRank(TypeParameter tp) {
      tp = DenseRank<DenseRankInput>::denseRank(result)
    }

    string encode(TypeParameter tp) { result = getTypeParameterRank(tp).toString() }

    bindingset[s]
    TypeParameter decode(string s) { encode(result) = s }
  }

  final private class String = string;

  /**
   * A path into a type.
   *
   * Paths are represented in left-to-right order, for example, a path `"A0.B1"`
   * into the type `A<B<S,T>,C<U,V>>` points at the type `T`, assuming that the
   * first type parameter of `A` is named `A0` and the second type parameter of
   * `B` is named `B1`.
   *
   * Type paths are used to represent constructed types without using a `newtype`, which
   * makes it practically feasible to do type inference in mutual recursion with call
   * resolution.
   *
   * As an example, the type above can be represented by the following set of
   * tuples, if assuming the same naming convention for type parameters as
   * above:
   *
   * `TypePath`  | `Type`
   * ----------- | --------
   * `""`        | ``A`2``
   * `"A0"`      | ``B`2``
   * `"A0.B0"`   | `S`
   * `"A0.B1"`   | `T`
   * `"A1"`      | ``C`2``
   * `"A1.C0"`   | `U`
   * `"A1.C1"`   | `V`
   *
   * Note that while we write type paths using type parameter names, the actual
   * implementation uses unique type parameter identifiers, in order to not mix
   * up type parameters from different types.
   */
  class TypePath extends String {
    bindingset[this]
    TypePath() { exists(this) }

    bindingset[this]
    private TypeParameter getTypeParameter(int i) {
      result = TypeParameter::decode(this.splitAt(".", i))
    }

    /** Gets a textual representation of this type path. */
    bindingset[this]
    string toString() {
      result =
        concat(int i, TypeParameter tp |
          tp = this.getTypeParameter(i)
        |
          tp.toString(), "." order by i
        )
    }

    /** Holds if this type path is empty. */
    predicate isEmpty() { this = "" }

    /** Gets the length of this path. */
    bindingset[this]
    pragma[inline_late]
    int length() {
      this.isEmpty() and result = 0
      or
      result = strictcount(this.indexOf(".")) + 1
    }

    /** Gets the path obtained by appending `suffix` onto this path. */
    bindingset[suffix, result]
    bindingset[this, result]
    bindingset[this, suffix]
    TypePath append(TypePath suffix) {
      if this.isEmpty()
      then result = suffix
      else
        if suffix.isEmpty()
        then result = this
        else (
          result = this + "." + suffix and
          not result.length() > getTypePathLimit()
        )
    }

    /** Holds if this path starts with `tp`, followed by `suffix`. */
    bindingset[this]
    predicate isCons(TypeParameter tp, TypePath suffix) {
      tp = TypeParameter::decode(this) and
      suffix.isEmpty()
      or
      exists(int first |
        first = min(this.indexOf(".")) and
        suffix = this.suffix(first + 1) and
        tp = TypeParameter::decode(this.prefix(first))
      )
    }
  }

  /** Provides predicates for constructing `TypePath`s. */
  module TypePath {
    /** Gets the empty type path. */
    TypePath nil() { result.isEmpty() }

    /** Gets the singleton type path `tp`. */
    TypePath singleton(TypeParameter tp) { result = TypeParameter::encode(tp) }

    /**
     * Gets the type path obtained by appending the singleton type path `tp`
     * onto `suffix`.
     */
    bindingset[result]
    bindingset[suffix]
    TypePath cons(TypeParameter tp, TypePath suffix) { result = singleton(tp).append(suffix) }
  }

  /** Provides the input to `Make2`. */
  signature module InputSig2 {
    /** A type mention, for example a type annotation in a local variable declaration. */
    class TypeMention {
      /**
       * Gets the type being mentioned at `path` inside this type mention.
       *
       * For example, in
       *
       * ```csharp
       * C<int> x = ...
       * ```
       *
       * the type mention in the declaration of `x` resolves to the following
       * types:
       *
       * `TypePath` | `Type`
       * ---------- | -------
       * `""`       | ``C`1``
       * `"0"`      | `int`
       */
      Type resolveTypeAt(TypePath path);

      /** Gets a textual representation of this type mention. */
      string toString();

      /** Gets the location of this type mention. */
      Location getLocation();
    }

    /**
     * Gets a base type mention of `t`, if any. Example:
     *
     * ```csharp
     * class C<T> : Base<T>, Interface { }
     * //    ^ `t`
     * //           ^^^^^^^ `result`
     * //                    ^^^^^^^^^ `result`
     * ```
     */
    TypeMention getABaseTypeMention(Type t);
  }

  module Make2<InputSig2 Input2> {
    private import Input2

    /** Gets the type at the empty path of `tm`. */
    bindingset[tm]
    pragma[inline_late]
    private Type resolveTypeMentionRoot(TypeMention tm) {
      result = tm.resolveTypeAt(TypePath::nil())
    }

    /** Provides logic related to base types. */
    private module BaseTypes {
      /**
       * Holds if `baseMention` is a (transitive) base type mention of `sub`,
       * and `t` is mentioned (implicitly) at `path` inside `baseMention`. For
       * example, in
       *
       * ```csharp
       * class C<T1> { }
       *
       * class Base<T2> { }
       *
       * class Mid<T3> : Base<C<T3>> { }
       *
       * class Sub<T4> : Mid<C<T4>> { } // Sub<T4> extends Base<C<C<T4>>
       * ```
       *
       * - ``C`1`` is mentioned at `T2` for immediate base type mention `Base<C<T3>>`
       *   of `Mid`,
       * - `T3` is mentioned at `T2.T1` for immediate base type mention `Base<C<T3>>`
       *   of `Mid`,
       * - ``C`1`` is mentioned at `T3` for immediate base type mention `Mid<C<T4>>`
       *   of `Sub`, and
       * - `T4` is mentioned at `T3.T1` for immediate base type mention `Mid<C<T4>>`
       *   of `Sub`, and
       * - ``C`1`` is mentioned at `T2` and implicitly at `T2.T1` for transitive base type
       *   mention `Base<C<T3>>` of `Sub`.
       * - `T4` is mentioned implicitly at `T2.T1.T1` for transitive base type mention
       *   `Base<C<T3>>` of `Sub`.
       */
      pragma[nomagic]
      predicate baseTypeMentionHasTypeAt(Type sub, TypeMention baseMention, TypePath path, Type t) {
        exists(TypeMention immediateBaseMention |
          pragma[only_bind_into](immediateBaseMention) =
            getABaseTypeMention(pragma[only_bind_into](sub))
        |
          // immediate base class
          baseMention = immediateBaseMention and
          t = immediateBaseMention.resolveTypeAt(path)
          or
          // transitive base class
          exists(Type immediateBase | immediateBase = resolveTypeMentionRoot(immediateBaseMention) |
            not t = immediateBase.getATypeParameter() and
            baseTypeMentionHasTypeAt(immediateBase, baseMention, path, t)
            or
            exists(TypePath path0, TypePath prefix, TypePath suffix, TypeParameter tp |
              /*
               * Example:
               *
               * - `prefix = "T2.T1"`,
               * - `path0 = "T3"`,
               * - `suffix = ""`,
               * - `path = "T2.T1"`
               *
               * ```csharp
               * class C<T1> { }
               *       ^ `t`
               *
               * class Base<T2> { }
               *
               * class Mid<T3> : Base<C<T3>> { }
               * //    ^^^ `immediateBase`
               * //        ^^ `tp`
               * //              ^^^^^^^^^^^ `baseMention`
               *
               * class Sub<T4> : Mid<C<T4>> { }
               * //    ^^^ `sub`
               * //              ^^^^^^^^^^ `immediateBaseMention`
               * ```
               */

              baseTypeMentionHasTypeAt(immediateBase, baseMention, prefix, tp) and
              tp = immediateBase.getATypeParameter() and
              t = immediateBaseMention.resolveTypeAt(path0) and
              path0.isCons(tp, suffix) and
              path = prefix.append(suffix)
            )
          )
        )
      }
    }

    private import BaseTypes

    /** Provides the input to `Matching`. */
    signature module MatchingInputSig {
      /**
       * A position inside a declaration. For example, the integer position of a
       * parameter inside a method or the return type of a method.
       */
      bindingset[this]
      class DeclarationPosition {
        /** Gets a textual representation of this position. */
        bindingset[this]
        string toString();
      }

      /** A declaration, for example a method. */
      class Declaration {
        /** Gets a textual representation of this declaration. */
        string toString();

        /** Gets the location of this declaration. */
        Location getLocation();

        /** Gets the type parameter at position `tppos` of this declaration, if any. */
        TypeParameter getTypeParameter(TypeParameterPosition tppos);

        /**
         * Gets the declared type of this declaration at `path` for position `dpos`.
         *
         * For example, if this declaration is the method `int M(bool b)`,
         * then the declared type at parameter position `0` is `bool`, the
         * declared type at the `this` position is the class type, and the
         * declared return type is `int`.
         */
        Type getDeclaredType(DeclarationPosition dpos, TypePath path);
      }

      /**
       * A position inside an access. For example, the integer position of an
       * argument inside a method call.
       */
      bindingset[this]
      class AccessPosition {
        /** Gets a textual representation of this position. */
        bindingset[this]
        string toString();
      }

      /** An access that targets a declaration, for example a method call. */
      class Access {
        /** Gets a textual representation of this access. */
        string toString();

        /** Gets the location of this access. */
        Location getLocation();

        /**
         * Gets the type at `path` for the type argument at position `tapos` of
         * this access, if any.
         *
         * For example, in a method call like `M<int>()`, `int` is an explicit
         * type argument at position `0`.
         */
        Type getTypeArgument(TypeArgumentPosition tapos, TypePath path);

        /**
         * Gets the inferred type at `path` for the position `apos` of this access.
         *
         * For example, if this access is the method call `M(42)`, then the inferred
         * type at argument position `0` is `int`.
         */
        Type getInferredType(AccessPosition apos, TypePath path);

        /** Gets the declaration that this access targets. */
        Declaration getTarget();
      }

      /** Holds if `apos` and `dpos` match. */
      bindingset[apos]
      bindingset[dpos]
      predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos);

      /**
       * Holds if matching an inferred type `t` at `path` inside an access at `apos`
       * against the declaration `target` means that the type should be adjusted to
       * `tAdj` at `pathAdj`.
       *
       * For example, in
       *
       * ```csharp
       * void M(int? i) {}
       * M(42);
       * ```
       *
       * the inferred type of `42` is `int`, but it should be adjusted to `int?`
       * when matching against `M`.
       */
      bindingset[apos, target, path, t]
      default predicate adjustAccessType(
        AccessPosition apos, Declaration target, TypePath path, Type t, TypePath pathAdj, Type tAdj
      ) {
        pathAdj = path and
        tAdj = t
      }
    }

    /**
     * Provides logic for matching types at accesses against types at the
     * declarations that the accesses target.
     *
     * Matching takes both base types and explicit type arguments into account.
     */
    module Matching<MatchingInputSig Input> {
      private import Input

      /**
       * Holds if `a` targets `target` and the type for `apos` at `path` in `a`
       * is `t` after adjustment by `target`.
       */
      pragma[nomagic]
      private predicate adjustedAccessType(
        Access a, AccessPosition apos, Declaration target, TypePath path, Type t
      ) {
        target = a.getTarget() and
        exists(TypePath path0, Type t0 |
          t0 = a.getInferredType(apos, path0) and
          adjustAccessType(apos, target, path0, t0, path, t)
        )
      }

      /**
       * Gets the type of the type argument at `path` in `a` that corresponds to
       * the type parameter `tp` in `target`, if any.
       *
       * Note that this predicate crucially does not depend on type inference,
       * and hence can appear in negated position, e.g., as in
       * `directTypeMatch`.
       */
      bindingset[a, target]
      pragma[inline_late]
      private Type getTypeArgument(Access a, Declaration target, TypeParameter tp, TypePath path) {
        exists(TypeArgumentPosition tapos, TypeParameterPosition tppos |
          result = a.getTypeArgument(tapos, path) and
          tp = target.getTypeParameter(tppos) and
          typeArgumentParameterPositionMatch(tapos, tppos)
        )
      }

      /**
       * Holds if the type `t` at `path` of `a` matches the type parameter `tp`
       * of `target`.
       */
      pragma[nomagic]
      private predicate directTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        exists(AccessPosition apos, DeclarationPosition dpos, TypePath pathToTypeParam |
          tp = target.getDeclaredType(dpos, pathToTypeParam) and
          accessDeclarationPositionMatch(apos, dpos) and
          adjustedAccessType(a, apos, target, pathToTypeParam.append(path), t)
        )
      }

      private module AccessBaseType {
        /**
         * Holds if inferring types at `a` might depend on the type at `path` of
         * `apos` having `baseMention` as a transitive base type mention.
         */
        private predicate relevantAccess(Access a, AccessPosition apos, TypePath path, Type base) {
          exists(Declaration target, DeclarationPosition dpos |
            adjustedAccessType(a, apos, target, _, _) and
            accessDeclarationPositionMatch(apos, dpos)
          |
            path.isEmpty() and declarationBaseType(target, dpos, base, _, _)
            or
            typeParameterConstraintHasTypeParameter(target, dpos, path, _, base, _, _)
          )
        }

        pragma[nomagic]
        private Type inferTypeAt(
          Access a, AccessPosition apos, TypePath prefix, TypeParameter tp, TypePath suffix
        ) {
          relevantAccess(a, apos, prefix, _) and
          exists(TypePath path0 |
            result = a.getInferredType(apos, prefix.append(path0)) and
            path0.isCons(tp, suffix)
          )
        }

        /**
         * Holds if `baseMention` is a (transitive) base type mention of the
         * type of `a` at position `apos` at path `pathToSub`, and `t` is
         * mentioned (implicitly) at `path` inside `base`. For example, in
         *
         * ```csharp
         * class C<T1> { }
         *
         * class Base<T2> { }
         *
         * class Mid<T3> : Base<C<T3>> { }
         *
         * class Sub<T4> : Mid<C<T4>> { }
         *
         *     new Sub<int>().ToString();
         * //  ^^^^^^^^^^^^^^ node at `apos`
         * //  ^^^^^^^^^^^^^^^^^^^^^^^^^ `a`
         * ```
         *
         * where the method call is an access and `new Sub<int>()` is at an
         * access position, which is the receiver of a method call, we have:
         *
         * `baseMention` | `path`       | `t`
         * ------------- | ------------ | ---
         * `Mid<C<T4>>`  | `"T3"`       | ``C`1``
         * `Mid<C<T4>>`  | `"T3.T1"`    | `int`
         * `Base<C<T3>>` | `"T2"`       | ``C`1``
         * `Base<C<T3>>` | `"T2.T1"`    | ``C`1``
         * `Base<C<T3>>` | `"T2.T1.T1"` | `int`
         */
        pragma[nomagic]
        predicate hasBaseTypeMention(
          Access a, AccessPosition apos, TypePath pathToSub, TypeMention baseMention, TypePath path,
          Type t
        ) {
          relevantAccess(a, apos, pathToSub, resolveTypeMentionRoot(baseMention)) and
          exists(Type sub | sub = a.getInferredType(apos, pathToSub) |
            not t = sub.getATypeParameter() and
            baseTypeMentionHasTypeAt(sub, baseMention, path, t)
            or
            exists(TypePath prefix, TypePath suffix, TypeParameter tp |
              tp = sub.getATypeParameter() and
              baseTypeMentionHasTypeAt(sub, baseMention, prefix, tp) and
              t = inferTypeAt(a, apos, pathToSub, tp, suffix) and
              path = prefix.append(suffix)
            )
          )
        }
      }

      /**
       * Holds if the type of `a` at `apos` has the base type `base`, and when
       * viewed as an element of that type has the type `t` at `path`.
       */
      pragma[nomagic]
      private predicate accessBaseType(
        Access a, AccessPosition apos, Type base, TypePath path, Type t
      ) {
        exists(TypeMention tm |
          AccessBaseType::hasBaseTypeMention(a, apos, TypePath::nil(), tm, path, t) and
          base = resolveTypeMentionRoot(tm)
        )
      }

      /**
       * Holds if the declared type at `decl` for `dpos` at the `path` is `tp`
       * and `path` starts with a type parameter of `base`.
       */
      pragma[nomagic]
      private predicate declarationBaseType(
        Declaration decl, DeclarationPosition dpos, Type base, TypePath path, TypeParameter tp
      ) {
        tp = decl.getDeclaredType(dpos, path) and
        path.isCons(base.getATypeParameter(), _)
      }

      /**
       * Holds if the (transitive) base type `t` at `path` of `a` for some
       * `AccessPosition` matches the type parameter `tp`, which is used in the
       * declared types of `target`.
       *
       * For example, in
       *
       * ```csharp
       * class C<T1> { }
       *
       * class Base<T2> {
       * //         ^^ `tp`
       *     public C<T2> Method() { ... }
       * //               ^^^^^^ `target`
       * }
       *
       * class Mid<T3> : Base<C<T3>> { }
       *
       * class Sub<T4> : Mid<C<T4>> { }
       *
       *    new Sub<int>().Method(); // Note: `Sub<int>` is a subtype of `Base<C<C<int>>>`
       * // ^^^^^^^^^^^^^^^^^^^^^^^ `a`
       * ```
       *
       * we have that type parameter `T2` of `Base` is matched as follows:
       *
       * `path`    | `t`
       * --------- | -------
       * `""`      | ``C`1``
       * `"T1"`    | ``C`1``
       * `"T1.T1"` | `int`
       */
      pragma[nomagic]
      private predicate baseTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        target = a.getTarget() and
        exists(AccessPosition apos, DeclarationPosition dpos, Type base, TypePath pathToTypeParam |
          accessBaseType(a, apos, base, pathToTypeParam.append(path), t) and
          declarationBaseType(target, dpos, base, pathToTypeParam, tp) and
          accessDeclarationPositionMatch(apos, dpos)
        )
      }

      /**
       * Holds if for `a` and corresponding `target`, the type parameter `tp` is
       * matched by a type argument at the access with type `t` and type path
       * `path`.
       */
      pragma[nomagic]
      private predicate explicitTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        target = a.getTarget() and
        t = getTypeArgument(a, target, tp, path)
      }

      /**
       * Holds if `tp1` and `tp2` are distinct type parameters of `target`, the
       * declared type at `apos` mentions `tp1` at `path1`, `tp1` has a base
       * type mention of type `constrant` that mentions `tp2` at the path
       * `path2`.
       *
       * For this example
       * ```csharp
       * interface IFoo<A> { }
       * void M<T1, T2>(T2 item) where T2 : IFoo<T1> { }
       * ```
       * with the method declaration being the target and the for the first
       * parameter position, we have the following
       * - `path1 = ""`,
       * - `tp1 = T2`,
       * - `constraint = IFoo`,
       * - `path2 = "A"`,
       * - `tp2 = T1`
       */
      pragma[nomagic]
      private predicate typeParameterConstraintHasTypeParameter(
        Declaration target, DeclarationPosition dpos, TypePath path1, TypeParameter tp1,
        Type constraint, TypePath path2, TypeParameter tp2
      ) {
        tp1 = target.getTypeParameter(_) and
        tp2 = target.getTypeParameter(_) and
        tp1 != tp2 and
        tp1 = target.getDeclaredType(dpos, path1) and
        exists(TypeMention tm |
          tm = getABaseTypeMention(tp1) and
          tm.resolveTypeAt(path2) = tp2 and
          constraint = resolveTypeMentionRoot(tm)
        )
      }

      pragma[nomagic]
      private predicate typeConstraintBaseTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        target = a.getTarget() and
        exists(
          TypeMention base, AccessPosition apos, DeclarationPosition dpos, TypePath pathToTp,
          TypePath pathToTp2
        |
          accessDeclarationPositionMatch(apos, dpos) and
          typeParameterConstraintHasTypeParameter(target, dpos, pathToTp2, _,
            resolveTypeMentionRoot(base), pathToTp, tp) and
          AccessBaseType::hasBaseTypeMention(a, apos, pathToTp2, base, pathToTp.append(path), t)
        )
      }

      pragma[inline]
      private predicate typeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        // A type given at the access corresponds directly to the type parameter
        // at the target.
        explicitTypeMatch(a, target, path, t, tp)
        or
        // We can infer the type of `tp` from one of the access positions
        directTypeMatch(a, target, path, t, tp)
        or
        // We can infer the type of `tp` by going up the type hiearchy
        baseTypeMatch(a, target, path, t, tp)
        or
        // We can infer the type of `tp` by a type bound
        typeConstraintBaseTypeMatch(a, target, path, t, tp)
      }

      /**
       * Gets the inferred type of `a` at `path` for position `apos`.
       *
       * For example, in
       *
       * ```csharp
       * class C<T1> { }
       *
       * class Base<T2> {
       *     public C<T2> Method() { ... }
       * }
       *
       * class Mid<T3> : Base<C<T3>> { }
       *
       * class Sub<T4> : Mid<C<T4>> { }
       *
       *    new Sub<int>().Method(); // Note: Sub<int> is a subtype of Base<C<C<int>>>
       * // ^^^^^^^^^^^^^^^^^^^^^^^ `a`
       * ```
       *
       * we infer the following types for the return position:
       *
       * `path`       | `t`
       * ------------ | -------
       * `""`         | ``C`1``
       * `"T1"`       | ``C`1``
       * `"T1.T1"`    | ``C`1``
       * `"T1.T1.T1"` | `int`
       *
       * We also infer the following types for the receiver position:
       *
       * `path`       | `t`
       * ------------ | -------
       * `""`         | ``Base`1``
       * `"T2"`       | ``C`1``
       * `"T2.T1"`    | ``C`1``
       * `"T2.T1.T1"` | `int`
       */
      pragma[nomagic]
      Type inferAccessType(Access a, AccessPosition apos, TypePath path) {
        exists(DeclarationPosition dpos | accessDeclarationPositionMatch(apos, dpos) |
          // A suffix of `path` leads to a type parameter in the target
          exists(Declaration target, TypePath prefix, TypeParameter tp, TypePath suffix |
            tp = target.getDeclaredType(pragma[only_bind_into](dpos), prefix) and
            path = prefix.append(suffix) and
            typeMatch(a, target, suffix, result, tp)
          )
          or
          // `path` corresponds directly to a concrete type in the declaration
          exists(Declaration target |
            result = target.getDeclaredType(pragma[only_bind_into](dpos), path) and
            target = a.getTarget() and
            not result instanceof TypeParameter
          )
        )
      }
    }

    /** Provides consitency checks. */
    module Consistency {
      query predicate missingTypeParameterId(TypeParameter tp) {
        not exists(getTypeParameterId(tp))
      }

      query predicate nonFunctionalTypeParameterId(TypeParameter tp) {
        getTypeParameterId(tp) != getTypeParameterId(tp)
      }

      query predicate nonInjectiveTypeParameterId(TypeParameter tp1, TypeParameter tp2) {
        getTypeParameterId(tp1) = getTypeParameterId(tp2) and
        tp1 != tp2
      }
    }
  }
}
